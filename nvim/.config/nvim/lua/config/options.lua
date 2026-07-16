vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Netrw settings
vim.g.netrw_liststyle = 3
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
-- vim.g.netrw_keepdir = 1          -- nie zmieniaj cwd przy nawigacji
-- vim.g.netrw_browse_split = 0     -- otwieraj w aktywnym oknie

-- -- toggle Lex
-- vim.keymap.set("n", "<leader>e", function()
--   if vim.bo.filetype == "netrw" then
--     vim.cmd("Rex")
--   else
--     vim.cmd("Lex")
--   end
-- end, { desc = "Toggle netrw" })

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false
vim.opt.swapfile = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.winborder = "rounded" -- okna są zaokrąglone

-- vim.opt.clipboard = "unnamedplus"

vim.opt.autoread = true
vim.opt.cursorline = false

-- Powoduje centrowanie pliku
vim.opt.scrolloff = 999

vim.opt.virtualedit = "block"

vim.opt.inccommand = "split"

vim.opt.ignorecase = true

vim.opt.wrapmargin = 2
vim.opt.formatoptions:append("t")
vim.opt.linebreak = true

-- umożliwia terminalowi wykorzystywanie większej palety kolorów
vim.opt.termguicolors = true

-- Set up diagnostics
vim.opt.signcolumn = "yes:1"

vim.diagnostic.config({
    virtual_lines = {current_line = true},
})
