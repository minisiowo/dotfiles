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

vim.opt.autoread = true

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

vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix list" })

vim.opt.fillchars:append({ eob = " " })

-- Update and source current file
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>", { desc = "Save and source file" })

-- Buffer navigations
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>s=", "<C-w>=", { desc = "Equalize splits" })
vim.keymap.set("n", "<leader>sH", "<cmd>vertical resize -5<CR>", { desc = "Shrink split width" })
vim.keymap.set("n", "<leader>sL", "<cmd>vertical resize +5<CR>", { desc = "Grow split width" })
vim.keymap.set("n", "<leader>sJ", "<cmd>resize -3<CR>", { desc = "Shrink split height" })
vim.keymap.set("n", "<leader>sK", "<cmd>resize +3<CR>", { desc = "Grow split height" })

vim.keymap.set("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Line content select
vim.keymap.set("n", "<leader>vl", "_vg_", { desc = "Select line without indent" })

-- Noh
vim.keymap.set("n", "<Esc>", function()
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
    end
end, { desc = "Clear search highlight" })
