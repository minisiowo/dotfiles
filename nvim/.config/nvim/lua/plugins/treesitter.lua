local M = {}

M.setup = function ()
    require("nvim-treesitter").install({
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "html",
        "css",
        "javascript",
        "typescript",
        "python",
        "rust",
        "markdown",
        "markdown_inline",
        "typst",
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
            pcall(vim.treesitter.start)
        end,
    })
end

return M
