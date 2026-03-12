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
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                background = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                buffer = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                buffer_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
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
                close_button = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                close_button_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                close_button_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Normal",
                    },
                },
                separator = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                separator_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
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
                duplicate = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                    italic = false,
                },
                duplicate_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                    italic = false,
                },
                duplicate_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Normal",
                    },
                    italic = false,
                },
                modified = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
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
                modified_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "String",
                    },
                },
                numbers = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                numbers_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                numbers_selected = {
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
                diagnostic = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                    fg = {
                        attribute = "fg",
                        highlight = "Comment",
                    },
                },
                diagnostic_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
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
                    italic = false,
                },
                hint = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                hint_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                hint_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    italic = false,
                },
                info = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                info_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                info_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    italic = false,
                },
                warning = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                warning_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                warning_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    italic = false,
                },
                error = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                error_visible = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
                },
                error_selected = {
                    bg = {
                        attribute = "bg",
                        highlight = "CursorLine",
                    },
                    italic = false,
                },
                offset_separator = {
                    bg = {
                        attribute = "bg",
                        highlight = "StatusLine",
                    },
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
                desc = "Close current buffer",
            },
        },
    },
}
