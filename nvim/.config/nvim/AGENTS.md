# Repository Guidelines

## Project Structure & Module Organization
This repository is a Lua-based Neovim configuration rooted at `init.lua`. Core editor settings live in `lua/options.lua`, autocommands in `lua/autocmds.lua`, and Java-specific LSP bootstrap code in `lua/jdtls/jdtls_setup.lua`. Plugin specs are split into one file per feature under `lua/plugins/` such as `lsp-config.lua`, `treesitter.lua`, and `neo-tree.lua`. Post-load tweaks that rely on plugin runtime state belong in `after/plugin/`.

## Build, Test, and Development Commands
Use Neovim itself as the runtime and validation target.

- `nvim` launches the config locally for interactive testing.
- `nvim --headless "+Lazy! sync" +qa` installs or updates plugins declared through `lazy.nvim`.
- `nvim --headless "+checkhealth" +qa` runs Neovim health checks for providers and plugin dependencies.
- `nvim --headless "+lua require('lazy').load({plugins={'nvim-lspconfig'}})" +qa` is a useful pattern for smoke-testing a changed plugin spec.

When editing a single Lua file from inside Neovim, `<leader>o` writes and re-sources the current buffer.

## Coding Style & Naming Conventions
Follow the existing Lua style: small focused modules, `return { ... }` for plugin specs, and descriptive lowercase file names with hyphens or underscores matching the feature name. Existing files mostly use 4-space indentation; keep that convention in new code even if older files contain tabs. Prefer direct `vim.opt`, `vim.api.nvim_create_autocmd`, and `vim.keymap.set` usage over custom wrappers. Keep comments short and only where the behavior is non-obvious.

## Testing Guidelines
There is no dedicated automated test suite in this repo. Validate changes with headless startup checks and one manual interactive pass in `nvim`, focused on the feature you touched. For LSP or UI changes, confirm the affected filetype or plugin loads without errors. Treat a clean `checkhealth` and startup as the minimum bar before submitting.

## Commit & Pull Request Guidelines
Recent commits use short, lowercase summaries such as `clamshell mode changes` and sometimes a scope prefix like `opencode:`. Keep commit messages concise, imperative, and scoped to one change. Pull requests should describe the user-visible behavior change, list any required external tools or plugins, and include screenshots or short recordings for visible UI updates such as theme, statusline, or explorer changes.
