return {
    {
        "echasnovski/mini.pick",
        version = "*",
        keys = {
            { "<leader>ff", function() require("mini.pick").builtin.files() end,     desc = "MiniPick: find files" },
            { "<leader>fg", function() require("mini.pick").builtin.grep_live() end, desc = "MiniPick: live grep" },
            { "<leader>fb", function() require("mini.pick").builtin.buffers() end,   desc = "MiniPick: buffers" },
            { "<leader>fh", function() require("mini.pick").builtin.help() end,      desc = "MiniPick: help tags" },
        },
    }
}
