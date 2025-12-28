return {
    {
        -- kolejność jest ważna, najpierw mason, potem mason-lsp a na końcu nvim-lsp
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            -- tutaj nazwy z Mason'a, a nie nazwy LSP
            ensure_installed = {
                "tinymist",            -- LSP: tinymist
                "lua-language-server", -- LSP: lua_ls
                "jdtls",               -- Java (odpala nvim-jdtls)
            },
            run_on_start = true,
            auto_update = false,
        },
    },
    {
        -- jest to plugin z gotowymi konfiguracjami dla serwerów LSP
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            vim.lsp.set_log_level("error")
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

            vim.lsp.config('tinymist', {
                settings = {
                    formatterMode = "typstyle",
                },
            })

            -- tutaj nazwy LSP, nie nazwy z MASON'A (od neovim 11+)
            vim.lsp.enable({"lua_ls", "tinymist"})
        end
    },
    -- for java LSP, dlatego nie uruchamiam tego w lsp.enable
    { "mfussenegger/nvim-jdtls" },
}
