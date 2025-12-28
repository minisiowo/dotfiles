return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch       = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },

        -- jedno z poniższych wystarczy, ale mogą być oba
        cmd  = "Neotree",          -- :Neotree <tab> też załaduje plugin
        keys = {
            {
                "<leader>e",
                "<cmd>Neotree toggle<CR>",   -- ← string, nie funkcja
                desc = "Toggle NeoTree",
            },
            {
                "<leader>=",
                "<cmd>vertical resize +5<CR>",
                desc = "NeoTree width +5",
            },
            {
                "<leader>-",
                "<cmd>vertical resize -5<CR>",
                desc = "NeoTree width -5",
            },
        },

        opts = {
            window = {
                width = function()
                    local cols = vim.o.columns
                    local w = math.floor(cols * 0.25) -- bazowo 25%
                    local min_w, max_w = 28, 50       -- dopasuj pod siebie
                    return math.max(min_w, math.min(max_w, w))
                end,
            },
            filesystem = {
                follow_current_file = { enabled = true },
            },
        }
    }
}
