local M = {}

M.setup = function()
    -- LuaLS cannot infer this plugin's annotated setup argument.
    ---@diagnostic disable-next-line: redundant-parameter
    require("bufferline").setup({
        options = {
            close_command = function(bufnr)
                require("mini.bufremove").delete(bufnr, false)
            end,
            right_mouse_command = function(bufnr)
                require("mini.bufremove").delete(bufnr, false)
            end,
            diagnostics = "nvim_lsp",
            always_show_bufferline = false,
            diagnostics_indicator = function(_, _, diagnostics)
                local result = (diagnostics.error and " " .. diagnostics.error .. " " or "")
                    .. (diagnostics.warning and " " .. diagnostics.warning or "")
                return vim.trim(result)
            end,
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "Neo-tree",
                    highlight = "Directory",
                    text_align = "left",
                },
            },
        },
    })

    local mappings = {
        ["<leader>bp"] = { "<cmd>BufferLineTogglePin<cr>", "Toggle buffer pin" },
        ["<leader>bP"] = { "<cmd>BufferLineGroupClose ungrouped<cr>", "Close unpinned buffers" },
        ["<leader>br"] = { "<cmd>BufferLineCloseRight<cr>", "Close buffers to the right" },
        ["<leader>bl"] = { "<cmd>BufferLineCloseLeft<cr>", "Close buffers to the left" },
        ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", "Pick buffer" },
        ["<S-h>"] = { "<cmd>BufferLineCyclePrev<cr>", "Previous buffer" },
        ["<S-l>"] = { "<cmd>BufferLineCycleNext<cr>", "Next buffer" },
        ["[b"] = { "<cmd>BufferLineCyclePrev<cr>", "Previous buffer" },
        ["]b"] = { "<cmd>BufferLineCycleNext<cr>", "Next buffer" },
        ["[B"] = { "<cmd>BufferLineMovePrev<cr>", "Move buffer left" },
        ["]B"] = { "<cmd>BufferLineMoveNext<cr>", "Move buffer right" },
    }
    for lhs, mapping in pairs(mappings) do
        vim.keymap.set("n", lhs, mapping[1], { desc = mapping[2], silent = true })
    end

    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
            vim.schedule(function()
                pcall(nvim_bufferline)
            end)
        end,
    })
end

return M
