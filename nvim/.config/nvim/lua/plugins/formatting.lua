return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            notify_on_error = true,
            formatters_by_ft = {
                css = { "prettierd", "prettier" },
                html = { "prettierd", "prettier" },
                javascript = { "prettierd", "prettier" },
                json = { "prettierd", "prettier" },
                python = { "ruff_format" },
                rust = { "rustfmt" },
                yaml = { "prettierd", "prettier", stop_after_first = true },
            },
        },
        config = function(_, opts)
            require("conform").setup(opts)
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                python = { "ruff" },
            }
        end,
    },
}
