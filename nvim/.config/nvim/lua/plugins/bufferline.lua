return {
    {
        "akinsho/bufferline.nvim",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                mode = "buffers",
                always_show_bufferline = false,
                auto_toggle_bufferline = true,
                diagnostics = "nvim_lsp",
                separator_style = "thin",
                show_close_icon = false,
                show_buffer_close_icons = false,
                offsets = {
                    {
                        filetype = "snacks_layout_box",
                        text = "Explorer",
                        highlight = "Directory",
                        text_align = "left",
                        separator = true,
                    },
                },
            },
            highlights = {
                fill = {
                    bg = "NONE",
                },
                background = {
                    bg = "NONE",
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                buffer_visible = {
                    bg = "NONE",
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                buffer_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Normal",
                    },
                    bold = true,
                    italic = false,
                },
                separator = {
                    bg = "NONE",
                    fg = "NONE",
                },
                separator_visible = {
                    bg = "NONE",
                    fg = "NONE",
                },
                separator_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    fg = "NONE",
                },
                indicator_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Directory",
                    },
                },
                modified = {
                    bg = "NONE",
                    fg = {
                        attribute = "fg",
                        highlight = "String",
                    },
                },
                modified_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "String",
                    },
                },
                diagnostic = {
                    bg = "NONE",
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                diagnostic_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                },
                offset_separator = {
                    bg = "NONE",
                    fg = {
                        attribute = "fg",
                        highlight = "WinSeparator",
                    },
                },
            },
        },
        keys = {
            {
                "<leader>bp",
                "<cmd>BufferLinePick<cr>",
                desc = "Pick buffer",
            },
            {
                "<leader>bc",
                function()
                    require("snacks").bufdelete()
                end,
                desc = "Close buffer",
            },
        },
    },
}
