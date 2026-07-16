local M = {}

M.setup = function()
    vim.keymap.set({ 'n', 'x', 'o' }, 'zk',  '<Plug>(leap)', { desc = "Leap" })
    vim.keymap.set('n',               'zK', '<Plug>(leap-from-window)', { desc = "Leap From Window"})
end

return M
