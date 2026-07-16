local M = {}

M.setup = function ()
    require("neo-tree").setup({
        close_if_last_window = true,
        default_component_configs = {
            indent = {
                padding = 0,
            },
            icon = {
                folder_closed = "+",
                folder_open = "-",
                folder_empty = "∅",
                folder_empty_open = "∅",
                provider = function() end,
                default = "",
                use_filtered_colors = true,
            },
            git_status = {
                symbols = {
                    added = "[A]",
                    modified = "[M]",
                    deleted = "[D]",
                    renamed = "[R]",
                    untracked = "[?]",
                    ignored = "[ ]",
                    unstaged = "[u]",
                    staged = "[s]",
                    conflict = "[!]",
                },
            },
        },
        window = {
            width = 35,
            mappings = {
                ["l"] = "open",
                ["h"] = "close_node",
            },
        },
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
            },
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
        },
    })
end

return M
