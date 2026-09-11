local M = {}

local theme = require("omarchy.theme")
local transparency = require("omarchy.transparency")
local watcher = require("omarchy.watcher")

local function notify_error(message)
    vim.notify("Omarchy theme: " .. message, vim.log.levels.ERROR)
end

local function apply_theme()
    local ok, err = theme.apply()
    if not ok then
        notify_error(err)
        return false
    end

    vim.schedule(transparency.apply)
    return true
end

function M.setup()
    transparency.setup()

    if not apply_theme() then
        -- Keep the previous standalone Kanagawa configuration as a safe fallback.
        local ok, err = pcall(function()
            require("plugins.colorscheme").setup()
        end)
        if not ok then
            notify_error("Kanagawa fallback failed: " .. err)
        end
    end

    vim.api.nvim_create_user_command("OmarchyThemeReload", function()
        apply_theme()
    end, { desc = "Reload the current Omarchy colorscheme" })

    local current_dir = vim.fs.dirname(vim.fs.dirname(theme.path))
    local watching, watch_error = watcher.start(current_dir, apply_theme)
    if not watching then
        notify_error(watch_error)
    end
end

return M
