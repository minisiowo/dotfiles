return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "zk",
                mode = { "n", "x", "o" },
                function() require("flash").jump() end,
                desc = "Jump",
            },
            {
                "zK",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc = "Treesitter jump",
            },
            {
                "zr",
                mode = "o",
                function() require("flash").remote() end,
                desc = "Remote jump",
            },
            {
                "zR",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc = "Treesitter search jump",
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc = "Toggle search",
            },
        },

    }
}
