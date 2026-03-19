return {
    {
        -- kolejność jest ważna, najpierw mason, potem mason-lsp a na końcu nvim-lsp
        "mason-org/mason.nvim",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            -- tutaj nazwy z Mason'a, a nie nazwy LSP
            ensure_installed = {
                "json-lsp",            -- LSP: jsonls
                "roslyn",              -- LSP: roslyn (via roslyn.nvim)
                "tinymist",            -- LSP: tinymist
                "lua-language-server", -- LSP: lua_ls
                -- "jdtls",               -- Java (odpala nvim-jdtls)
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
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Show references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

            vim.lsp.config("tinymist", {
                settings = {
                    formatterMode = "typstyle",
                },
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            checkThirdParty = "Disable",
                        },
                    },
                },
            })

            vim.lsp.config("jsonls", {})

            -- tutaj nazwy LSP, nie nazwy z MASON'A (od neovim 11+)
            vim.lsp.enable({ "lua_ls", "tinymist", "jsonls" })
        end
    },
    -- for java LSP, dlatego nie uruchamiam tego w lsp.enable
    -- { "mfussenegger/nvim-jdtls" },
}
