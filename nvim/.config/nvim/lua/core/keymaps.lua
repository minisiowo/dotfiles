-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<S-L>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-H>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', { desc = 'Close Current Buffer' }) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', { desc = 'New Buffer' }) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Format Current Buffer
vim.keymap.set('n', '<leader>f', function()
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format document' })

-- Lint Current Buffer  
vim.keymap.set('n', '<leader>l', function()
  require('lint').try_lint()
end, { desc = 'Trigger linting for current file' })

-- Mapowania dla trybu normalnego
vim.keymap.set('n', 'j', function() return vim.v.count > 0 and 'j' or 'gj' end, { noremap = true, expr = true })
vim.keymap.set('n', 'k', function() return vim.v.count > 0 and 'k' or 'gk' end, { noremap = true, expr = true })
vim.keymap.set('n', '<Down>', function() return vim.v.count > 0 and '<Down>' or 'gj' end, { noremap = true, expr = true })
vim.keymap.set('n', '<Up>', function() return vim.v.count > 0 and '<Up>' or 'gk' end, { noremap = true, expr = true })

-- Mapowania dla trybu wizualnego
vim.keymap.set('v', 'j', function() return vim.v.count > 0 and 'j' or 'gj' end, { noremap = true, expr = true })
vim.keymap.set('v', 'k', function() return vim.v.count > 0 and 'k' or 'gk' end, { noremap = true, expr = true })
vim.keymap.set('v', '<Down>', function() return vim.v.count > 0 and '<Down>' or 'gj' end, { noremap = true, expr = true })
vim.keymap.set('v', '<Up>', function() return vim.v.count > 0 and '<Up>' or 'gk' end, { noremap = true, expr = true })
