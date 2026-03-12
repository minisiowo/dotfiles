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
                desc = "Explorer",
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
                desc = "Live grep",
            },
            {
                "<leader>fb",
                function()
                    require("snacks").picker.buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>fh",
                function()
                    require("snacks").picker.help()
                end,
                desc = "Help",
            },
            {
                "<leader>tt",
                function()
                    require("snacks").terminal()
                end,
                desc = "Terminal",
            },
            {
                "<leader>nh",
                function()
                    require("snacks").notifier.show_history()
                end,
                desc = "Notification history",
            },
            {
                "<leader>nd",
                function()
                    require("snacks").notifier.hide()
                end,
                desc = "Dismiss notifications",
            },
        },
    },
}
