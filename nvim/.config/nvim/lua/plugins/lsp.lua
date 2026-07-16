local M = {}

M.setup = function ()
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-tool-installer").setup({
        ensure_installed = {
            "lua_ls",
            "html",
            "cssls",
            "ts_ls",
            "pyright",
            "ruff",
            "marksman",
            "tinymist",
            {
                "rust_analyzer",
                condition = function()
                    return vim.fn.executable("cargo") == 1
                end,
            },
        },
    })

    vim.lsp.enable({ "lua_ls", "html", "cssls", "ts_ls", "pyright", "ruff", "rust_analyzer", "typst" })
end

return M
