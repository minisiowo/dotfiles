local M = {}

M.setup = function()
    require("yazi").setup({
        -- Use same window style as your other plugins
        floating_window_scaling_factor = 0.9,
        yazi_floating_window_border = "rounded",
        yazi_floating_window_winblend = 0,

        -- Keymaps when yazi is open
        keymaps = {
            show_help = "<f1>",
            open_file_in_vertical_split = "<c-v>",
            open_file_in_horizontal_split = "<c-x>",
            open_file_in_tab = "<c-t>",
            grep_in_directory = "<c-s>",
            replace_in_directory = "<c-g>",
            send_to_quickfix_list = "<c-q>",
        },

        -- Integration with your snacks.nvim picker for grep
        -- integrations = {
        --     grep_in_directory = function(directory)
        --         -- Uses snacks picker if available
        --         if package.loaded["snacks"] then
        --             require("snacks").picker.grep({ cwd = directory })
        --         end
        --     end,
        -- },
    })
    -- Keymaps to open yazi
    vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Yazi<cr>", { desc = "Open yazi at current file" })
    vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Open yazi in working directory" })
end

return M
