return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            spec = {
                { "<leader>b", group = "Buffer" },
                { "<leader>c", group = "Code" },
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Goto" },
                { "<leader>l", group = "LSP" },
                { "<leader>n", group = "Notifications" },
                { "<leader>s", group = "Split" },
                { "<leader>t", group = "Terminal" },
                { "<leader>v", group = "Visual" },
            },
        },
    },
}
