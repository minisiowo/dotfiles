return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            explorer = {
                enabled = true,
                replace_netrw = true,
            },
            input = {
                enabled = true,
            },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            picker = {
                enabled = true,
                ui_select = true,
                sources = {
                    explorer = {
                        hidden = true,
                        ignored = true,
                    },
                },
            },
            terminal = {
                enabled = true,
            },
        },
        keys = {
            {
                "<leader>e",
                function()
                    require("snacks").explorer()
                end,
                desc = "Toggle file explorer",
            },
            {
                "<leader>ff",
                function()
                    require("snacks").picker.files()
                end,
                desc = "Find files",
            },
            {
                "<leader>fg",
                function()
                    require("snacks").picker.grep()
                end,
                desc = "Search by grep",
            },
            {
                "<leader>fb",
                function()
                    require("snacks").picker.buffers()
                end,
                desc = "Find buffers",
            },
            {
                "<leader>fh",
                function()
                    require("snacks").picker.help()
                end,
                desc = "Search help tags",
            },
            {
                "<leader>tt",
                function()
                    require("snacks").terminal()
                end,
                desc = "Toggle terminal",
            },
            {
                "<leader>nh",
                function()
                    require("snacks").notifier.show_history()
                end,
                desc = "Show notification history",
            },
            {
                "<leader>nd",
                function()
                    require("snacks").notifier.hide()
                end,
                desc = "Dismiss all notifications",
            },
        },
    },
}
