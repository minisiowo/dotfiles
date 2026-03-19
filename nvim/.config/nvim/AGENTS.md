# Repository Guidelines

## Project Structure & Module Organization
This repository is a Lua-based Neovim configuration rooted at `init.lua`. Startup bootstraps `lazy.nvim`, then loads `lua/options.lua`, plugin specs from `lua/plugins/`, and `lua/autocmds.lua`. Plugin specs are split into one file per feature under `lua/plugins/` such as `lsp-config.lua`, `treesitter.lua`, `snacks.lua`, `formatting.lua`, and `theme.lua`. Shared workflow helpers that are not plugin specs live in plain Lua modules such as `lua/project_workflow.lua`. Post-load tweaks that rely on plugin runtime state belong in `after/plugin/`, which currently includes `after/plugin/transparency.lua` and `after/plugin/project_workflow.lua`. Disabled or experimental modules are kept alongside active ones with a `.disabled` suffix instead of being deleted.

## Build, Test, and Development Commands
Use Neovim itself as the runtime and validation target.

- `nvim` launches the config locally for interactive testing.
- `nvim --headless "+qa"` performs a minimal startup smoke test.
- `nvim --headless "+Lazy! sync" +qa` installs or updates plugins declared through `lazy.nvim`.
- `nvim --headless "+checkhealth" +qa` runs Neovim health checks for providers and plugin dependencies.
- `nvim --headless "+lua require('lazy').load({plugins={'nvim-lspconfig'}})" +qa` is a useful pattern for smoke-testing a changed plugin spec.

On a fresh machine, first launch may clone `lazy.nvim` automatically, so `git` access is part of bootstrap.

## Coding Style & Naming Conventions
Follow the existing Lua style: small focused modules, `return { ... }` for plugin specs, and descriptive lowercase file names with hyphens or underscores matching the feature name. Use 4-space indentation. Prefer direct `vim.opt`, `vim.api.nvim_create_autocmd`, and `vim.keymap.set` usage over custom wrappers. Keep comments short and only where the behavior is non-obvious. If you are disabling a module temporarily, prefer renaming it with `.disabled` to preserve local history and intent.

## Testing Guidelines
There is no dedicated automated test suite in this repo. Validate changes with at least a headless startup check and one manual interactive pass in `nvim`, focused on the feature you touched. For plugin spec changes, ensure `Lazy` can load the affected plugin without errors. For LSP or filetype-specific changes, open a matching buffer and confirm the relevant integration attaches cleanly. For workflow or keymap changes, verify the mapped action actually opens the expected split, terminal, picker, or project command. Treat a clean startup as the minimum bar; run `checkhealth` when the change touches providers, toolchains, or UI integrations.

## Commit & Pull Request Guidelines
Recent commits use short, lowercase summaries such as `clamshell mode changes` and sometimes a scope prefix like `opencode:`. Keep commit messages concise, imperative, and scoped to one change. Pull requests should describe the user-visible behavior change, list any required external tools or plugins, and include screenshots or short recordings for visible UI updates such as colorscheme, statusline, or picker/explorer behavior.
