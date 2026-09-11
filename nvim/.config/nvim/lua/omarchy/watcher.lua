local M = {}

local poll
local debounce

local function close_handle(handle)
    if handle and not handle:is_closing() then
        handle:stop()
        handle:close()
    end
end

function M.start(path, callback)
    close_handle(poll)
    close_handle(debounce)

    poll = vim.uv.new_fs_poll()
    debounce = vim.uv.new_timer()
    if not poll or not debounce then
        return false, "libuv could not create the Omarchy theme watcher"
    end

    poll:start(path, 500, function(error, previous, current)
        if error or not previous or not current then
            return
        end

        debounce:stop()
        debounce:start(100, 0, vim.schedule_wrap(callback))
    end)

    local group = vim.api.nvim_create_augroup("OmarchyThemeWatcher", { clear = true })
    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = group,
        once = true,
        callback = function()
            close_handle(poll)
            close_handle(debounce)
            poll = nil
            debounce = nil
        end,
    })

    return true
end

return M
