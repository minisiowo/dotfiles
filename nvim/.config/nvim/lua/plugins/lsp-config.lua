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
                "css-lsp",             -- LSP: cssls
                "emmet-language-server", -- LSP: emmet_language_server
                "eslint_d",            -- lint: eslint_d
                "html-lsp",            -- LSP: html
                "json-lsp",            -- LSP: jsonls
                "prettierd",           -- formatter: prettierd
                "roslyn",              -- LSP: roslyn (via roslyn.nvim)
                "rust-analyzer",       -- LSP: rust_analyzer
                "tinymist",            -- LSP: tinymist
                "typescript-language-server", -- LSP: ts_ls
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
            local util = require("lspconfig.util")

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

            vim.lsp.config("rust_analyzer", {
                root_dir = util.root_pattern("Cargo.toml", "rust-project.json", ".git"),
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        procMacro = {
                            enable = true,
                        },
                    },
                },
            })

            vim.lsp.config("ts_ls", {
                root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
                single_file_support = true,
            })

            vim.lsp.config("html", {
                root_dir = util.root_pattern("package.json", ".git"),
            })

            vim.lsp.config("cssls", {
                root_dir = util.root_pattern("package.json", ".git"),
            })

            vim.lsp.config("emmet_language_server", {
                root_dir = util.root_pattern("package.json", ".git"),
                filetypes = {
                    "css",
                    "eruby",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "less",
                    "sass",
                    "scss",
                    "typescriptreact",
                },
            })

            -- tutaj nazwy LSP, nie nazwy z MASON'A (od neovim 11+)
            vim.lsp.enable({
                "cssls",
                "emmet_language_server",
                "html",
                "jsonls",
                "lua_ls",
                "rust_analyzer",
                "tinymist",
                "ts_ls",
            })
        end
    },
    -- for java LSP, dlatego nie uruchamiam tego w lsp.enable
    -- { "mfussenegger/nvim-jdtls" },
}
