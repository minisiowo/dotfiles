return {
    {
        -- kolejność jest ważna, najpierw mason, potem mason-lsp a na końcu nvim-lsp
        "mason-org/mason.nvim",
        lazy = false,
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
                "dockerfile-language-server", -- LSP: dockerls
                "emmet-language-server", -- LSP: emmet_language_server
                "eslint_d",            -- lint: eslint_d
                "html-lsp",            -- LSP: html
                "json-lsp",            -- LSP: jsonls
                "prettierd",           -- formatter: prettierd
                "pyright",             -- LSP: pyright
                "roslyn",              -- LSP: roslyn (via roslyn.nvim)
                "ruff",                -- LSP/lint/format: ruff
                "rust-analyzer",       -- LSP: rust_analyzer
                "tinymist",            -- LSP: tinymist
                "typescript-language-server", -- LSP: ts_ls
                "lua-language-server", -- LSP: lua_ls
                "yaml-language-server", -- LSP: yamlls
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
        dependencies = {
            "mason-org/mason.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            local util = require("lspconfig.util")
            local compose_schema = "https://raw.githubusercontent.com/compose-spec/compose-spec/main/schema/compose-spec.json"
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            vim.lsp.log.set_level("error")

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Show references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

            vim.lsp.config("tinymist", {
                capabilities = capabilities,
                settings = {
                    formatterMode = "typstyle",
                },
            })

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
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

            vim.lsp.config("jsonls", {
                capabilities = capabilities,
            })

            vim.lsp.config("pyright", {
                capabilities = capabilities,
                root_markers = {
                    "pyrightconfig.json",
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    "Pipfile",
                    ".git",
                },
                workspace_required = false,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "openFilesOnly",
                        },
                    },
                },
            })

            vim.lsp.config("ruff", {
                capabilities = capabilities,
                root_markers = {
                    "pyproject.toml",
                    "ruff.toml",
                    ".ruff.toml",
                    ".git",
                },
                workspace_required = false,
                on_attach = function(client)
                    client.server_capabilities.hoverProvider = false
                end,
            })

            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
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
                capabilities = capabilities,
                root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
                single_file_support = true,
            })

            vim.lsp.config("html", {
                capabilities = capabilities,
                root_dir = util.root_pattern("package.json", ".git"),
            })

            vim.lsp.config("cssls", {
                capabilities = capabilities,
                single_file_support = true,
                settings = {
                    css = { validate = true },
                    scss = { validate = true },
                    less = { validate = true },
                },
            })

            vim.lsp.config("emmet_language_server", {
                capabilities = capabilities,
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

            vim.lsp.config("dockerls", {
                capabilities = capabilities,
            })

            vim.lsp.config("yamlls", {
                capabilities = capabilities,
                settings = {
                    redhat = {
                        telemetry = {
                            enabled = false,
                        },
                    },
                    yaml = {
                        validate = true,
                        hover = true,
                        completion = true,
                        format = {
                            enable = false,
                        },
                        schemaStore = {
                            enable = true,
                        },
                        schemas = {
                            [compose_schema] = {
                                "/docker-compose.yml",
                                "/docker-compose.yaml",
                                "/compose.yml",
                                "/compose.yaml",
                            },
                        },
                    },
                },
            })

            -- tutaj nazwy LSP, nie nazwy z MASON'A (od neovim 11+)
            vim.lsp.enable({
                "cssls",
                "dockerls",
                "emmet_language_server",
                "html",
                "jsonls",
                "lua_ls",
                "pyright",
                "ruff",
                "rust_analyzer",
                "tinymist",
                "ts_ls",
                "yamlls",
            })
        end
    },
    -- for java LSP, dlatego nie uruchamiam tego w lsp.enable
    -- { "mfussenegger/nvim-jdtls" },
}
