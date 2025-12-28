vim.g.mapleader = " "
vim.g.maplocalleader = ","

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

vim.opt.clipboard = "unnamedplus"

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

vim.opt.fillchars:append({ eob = " " })

-- Update and source current file
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>", {desc = "Update and Source Current File"})

-- Buffer navigations
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "H", ":bprevious<CR>")
vim.keymap.set("n", "L", ":bnext<CR>")

-- Line content select
vim.keymap.set("n", "<leader>vl", "_vg_", { desc = "Select line content" })

-- Noh
vim.keymap.set("n", "<Esc>", function()
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
    end
end)

-- Build in LSP Related
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {desc = "LSP File Foramt"})
