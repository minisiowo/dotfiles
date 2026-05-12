import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { spawn } from "node:child_process";

const STATUS_KEY = "codex-usage";
const REQUEST_TIMEOUT_MS = Number(process.env.PI_CODEX_USAGE_TIMEOUT_MS ?? 12_000);

type RateLimitWindow = {
	usedPercent: number;
	windowDurationMins: number | null;
	resetsAt: number | null;
};

type CreditsSnapshot = {
	hasCredits: boolean;
	unlimited: boolean;
	balance: string;
};

type RateLimitSnapshot = {
	primary: RateLimitWindow | null;
	secondary: RateLimitWindow | null;
	credits: CreditsSnapshot | null;
	planType: string | null;
	rateLimitReachedType: string | null;
};

type RateLimitResponse = {
	rateLimits: RateLimitSnapshot;
};

let refreshing = false;
let enabled = process.env.PI_CODEX_USAGE_DISABLED !== "1";
let lastSnapshot: RateLimitSnapshot | undefined;
let lastError: string | undefined;

export default function (pi: ExtensionAPI) {
	async function refresh(ctx: ExtensionContext) {
		if (!enabled || refreshing) return;
		if (!isOpenAIModel(ctx)) {
			lastSnapshot = undefined;
			lastError = undefined;
			ctx.ui.setStatus(STATUS_KEY, undefined);
			return;
		}
		refreshing = true;
		try {
			lastSnapshot = (await readCodexRateLimits()).rateLimits;
			lastError = undefined;
		} catch (error) {
			lastError = error instanceof Error ? error.message : String(error);
		} finally {
			refreshing = false;
			renderStatus(ctx);
		}
	}

	function start(ctx: ExtensionContext) {
		renderStatus(ctx);
		void refresh(ctx);
	}

	pi.on("session_start", async (_event, ctx) => {
		start(ctx);
	});

	pi.on("model_select", async (_event, ctx) => {
		start(ctx);
	});

	pi.on("agent_end", async (_event, ctx) => {
		void refresh(ctx);
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		ctx.ui.setStatus(STATUS_KEY, undefined);
	});

	pi.registerCommand("codex-usage", {
		description: "Show/refresh Codex usage limits in the PI footer",
		handler: async (args, ctx) => {
			const action = args.trim().toLowerCase();
			if (action === "off" || action === "disable") {
				enabled = false;
				ctx.ui.setStatus(STATUS_KEY, undefined);
				ctx.ui.notify("Codex usage: disabled", "info");
				return;
			}
			if (action === "on" || action === "enable") {
				enabled = true;
				start(ctx);
				ctx.ui.notify("Codex usage: enabled", "info");
				return;
			}
			await refresh(ctx);
			ctx.ui.notify(formatNotification(), lastError ? "warning" : "info");
		},
	});
}

function renderStatus(ctx: ExtensionContext) {
	if (!enabled || !isOpenAIModel(ctx)) {
		ctx.ui.setStatus(STATUS_KEY, undefined);
		return;
	}

	const theme = ctx.ui.theme;
	if (lastSnapshot) {
		const fiveHour = formatWindow("5h", lastSnapshot.primary);
		const weekly = formatWindow("7d", lastSnapshot.secondary);
		const credits = lastSnapshot.credits
			? lastSnapshot.credits.unlimited
				? "credits ∞"
				: `credits ${lastSnapshot.credits.balance}`
			: "";
		const reached = lastSnapshot.rateLimitReachedType ? theme.fg("warning", "  limit reached") : "";
		ctx.ui.setStatus(
			STATUS_KEY,
			theme.fg("accent", "Codex") +
				theme.fg("dim", `  ${fiveHour}  ${weekly}${credits ? `  ${credits}` : ""}`) +
				reached,
		);
		return;
	}

	if (lastError) {
		ctx.ui.setStatus(STATUS_KEY, theme.fg("warning", "Codex limits: unavailable"));
		return;
	}

	ctx.ui.setStatus(STATUS_KEY, theme.fg("dim", "Codex limits: …"));
}

function isOpenAIModel(ctx: ExtensionContext): boolean {
	const model = ctx.model;
	if (!model) return false;
	const provider = String(model.provider ?? "").toLowerCase();
	const id = String(model.id ?? "").toLowerCase();
	return provider.includes("openai") || id.includes("gpt-") || id.includes("o3") || id.includes("o4") || id.includes("codex");
}

function formatWindow(label: string, window: RateLimitWindow | null): string {
	if (!window) return `${label} —`;
	const remaining = Math.max(0, Math.min(100, 100 - Math.round(window.usedPercent)));
	const reset = window.resetsAt ? ` ↻ ${formatReset(window.resetsAt)}` : "";
	return `${label} ${remaining}% left${reset}`;
}

function formatReset(epochSeconds: number): string {
	const date = new Date(epochSeconds * 1000);
	const hours = String(date.getHours()).padStart(2, "0");
	const minutes = String(date.getMinutes()).padStart(2, "0");
	return `${hours}:${minutes}`;
}

function formatNotification(): string {
	if (lastError) return `Failed to fetch Codex limits: ${lastError}`;
	if (!lastSnapshot) return "Codex limits: no data";
	return `Codex: ${formatWindow("5h", lastSnapshot.primary)}, ${formatWindow("7d", lastSnapshot.secondary)}`;
}

async function readCodexRateLimits(): Promise<RateLimitResponse> {
	return new Promise((resolve, reject) => {
		const child = spawn("codex", ["app-server", "--listen", "stdio://"], {
			stdio: ["pipe", "pipe", "pipe"],
			env: process.env,
		});

		let buffer = "";
		let stderr = "";
		let initialized = false;
		let settled = false;

		const timeout = setTimeout(() => finish(new Error("timeout while talking to codex app-server")), REQUEST_TIMEOUT_MS);

		function finish(error?: Error, value?: RateLimitResponse) {
			if (settled) return;
			settled = true;
			clearTimeout(timeout);
			child.kill();
			if (error) reject(error);
			else resolve(value!);
		}

		child.on("error", (error) => finish(error));
		child.stderr.on("data", (chunk) => {
			stderr += chunk.toString();
		});
		child.on("exit", (code) => {
			if (!settled && code !== 0) {
				finish(new Error(stderr.trim() || `codex app-server exited with code ${code}`));
			}
		});

		child.stdout.on("data", (chunk) => {
			buffer += chunk.toString();
			let newline: number;
			while ((newline = buffer.indexOf("\n")) >= 0) {
				const line = buffer.slice(0, newline).trim();
				buffer = buffer.slice(newline + 1);
				if (!line) continue;
				let message: any;
				try {
					message = JSON.parse(line);
				} catch {
					continue;
				}
				if (message.id === 1 && message.result && !initialized) {
					initialized = true;
					send({ id: 2, method: "account/rateLimits/read" });
				} else if (message.id === 2) {
					if (message.error) finish(new Error(message.error.message ?? JSON.stringify(message.error)));
					else finish(undefined, message.result as RateLimitResponse);
				}
			}
		});

		function send(message: unknown) {
			child.stdin.write(`${JSON.stringify(message)}\n`);
		}

		send({
			id: 1,
			method: "initialize",
			params: {
				clientInfo: { name: "pi-codex-usage", title: "PI Codex Usage", version: "0.1.0" },
				capabilities: { experimentalApi: true, optOutNotificationMethods: [] },
			},
		});
	});
}
