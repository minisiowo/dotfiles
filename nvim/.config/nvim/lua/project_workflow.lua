local M = {}

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO, { title = "Project workflow" })
end

local function buf_dir(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr or 0)
    if name == "" then
        return (vim.uv or vim.loop).cwd()
    end

    return vim.fs.dirname(name)
end

local function find_up(names, start_path, opts)
    local found = vim.fs.find(names, vim.tbl_extend("force", {
        path = start_path,
        upward = true,
    }, opts or {}))[1]

    if not found then
        return nil
    end

    return vim.fs.dirname(found)
end

local function package_manager(root)
    if vim.fn.filereadable(root .. "/pnpm-lock.yaml") == 1 then
        return "pnpm", "pnpm dev"
    end

    if vim.fn.filereadable(root .. "/yarn.lock") == 1 then
        return "yarn", "yarn dev"
    end

    if vim.fn.filereadable(root .. "/bun.lockb") == 1 or vim.fn.filereadable(root .. "/bun.lock") == 1 then
        return "bun", "bun run dev"
    end

    return "npm", "npm run dev"
end

local function open_terminal(cmd, cwd, title)
    local executable = vim.fn.split(cmd)[1]
    if executable ~= nil and vim.fn.executable(executable) == 0 then
        notify("Missing executable: " .. executable, vim.log.levels.ERROR)
        return
    end

    vim.cmd("botright split")
    vim.cmd("resize 14")
    local chan = vim.fn.termopen(cmd, { cwd = cwd })
    if not chan then
        notify("Could not open terminal job", vim.log.levels.ERROR)
        return
    end

    if title then
        vim.api.nvim_buf_set_name(0, title)
    end

    vim.cmd("startinsert")
end

local function rust_root(bufnr)
    return find_up({ "Cargo.toml", "rust-project.json", ".git" }, buf_dir(bufnr))
end

local function web_root(bufnr)
    return find_up({
        "package.json",
        "vite.config.js",
        "vite.config.mjs",
        "vite.config.cjs",
        "vite.config.ts",
        ".git",
    }, buf_dir(bufnr))
end

local function tauri_root(bufnr)
    local start_path = buf_dir(bufnr)
    local src_tauri_dir = vim.fs.find("src-tauri", {
        path = start_path,
        upward = true,
        type = "directory",
    })[1]

    if src_tauri_dir then
        return vim.fs.dirname(src_tauri_dir)
    end

    local tauri_conf = vim.fs.find("tauri.conf.json", {
        path = start_path,
        upward = true,
    })[1]

    if tauri_conf then
        local tauri_dir = vim.fs.dirname(tauri_conf)
        if vim.fs.basename(tauri_dir) == "src-tauri" then
            return vim.fs.dirname(tauri_dir)
        end

        return tauri_dir
    end

    return nil
end

local function run_in_root(get_root, cmd, title)
    local root = get_root(0)
    if not root then
        notify("Could not find project root for " .. title, vim.log.levels.WARN)
        return
    end

    open_terminal(cmd, root, title)
end

function M.format_buffer()
    local ok, conform = pcall(require, "conform")
    if ok then
        conform.format({
            async = true,
            lsp_fallback = true,
        })
        return
    end

    vim.lsp.buf.format({ async = true })
end

function M.lint_current()
    if vim.bo.filetype == "rust" then
        M.run_cargo_clippy()
        return
    end

    local ok, lint = pcall(require, "lint")
    if not ok then
        notify("nvim-lint is not available", vim.log.levels.ERROR)
        return
    end

    local linters = lint.linters_by_ft[vim.bo.filetype]
    if not linters or vim.tbl_isempty(linters) then
        notify("No linter configured for " .. vim.bo.filetype, vim.log.levels.WARN)
        return
    end

    lint.try_lint()
    notify("Lint started for " .. vim.bo.filetype)
end

function M.run_cargo_check()
    run_in_root(rust_root, "cargo check", "cargo-check")
end

function M.run_cargo_clippy()
    run_in_root(rust_root, "cargo clippy", "cargo-clippy")
end

function M.run_cargo_test()
    run_in_root(rust_root, "cargo test", "cargo-test")
end

function M.run_tauri_dev()
    run_in_root(tauri_root, "cargo tauri dev", "tauri-dev")
end

function M.run_tauri_build()
    run_in_root(tauri_root, "cargo tauri build", "tauri-build")
end

function M.run_frontend_dev()
    local root = web_root(0)
    if not root then
        notify("Could not find frontend project root", vim.log.levels.WARN)
        return
    end

    local manager, cmd = package_manager(root)
    notify("Starting frontend dev with " .. manager)
    open_terminal(cmd, root, "frontend-dev")
end

return M
