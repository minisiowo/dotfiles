local M = {}

local function first_existing_path(paths)
    for _, path in ipairs(paths) do 
        if vim.uv.fs_stat(path) then
            return path
        end
    end
end

local home = vim.uv.os_homedir()

local vault_path = first_existing_path({
    home .. "/Documents/minisiowy-vault",
    "/mnt/c/Users/DMikolajczyk/Documents/minisiowy-vault",
})


M.setup = function ()
    require"obsidian".setup({
        legacy_commands = false,
        workspaces = {
            {
                name = "main",
                path = vault_path,
            },
        },
        templates = {
            folder = "00 templates",
            date_format = "YYYY-MM-DD",
            time_format = "HH:mm",
        },
        note_id_func = require("obsidian.builtin").title_id,
        note = {
            template = "new_note_nvim.md", -- A template you can define your self
        },
        frontmatter = { enabled = false },
        attachments = {
            folder = "01 attachments",
        }
    })
end

return M
