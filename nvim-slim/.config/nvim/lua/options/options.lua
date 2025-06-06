vim.g.mapleader = " "

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber= true

-- Wyłączam pliki tymczasowe, które pozwalają na ich odzyskiwanie itp, bez śmieci
vim.opt.swapfile = false

-- Nawigacja
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Utrzymuj zaznaczenie po shiftowaniu w trybie wizualnym
vim.cmd([[
  xnoremap < <gv
  xnoremap > >gv
]])

-- Sekcja z podświetlaniem podczas szukajki
vim.o.hlsearch = true -- podświetlenie włączone (domyślnie)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })

-- Skrót na zamykanie neovim
vim.keymap.set("n", "<leader>Q", function()
  if vim.bo.modified then
    vim.notify("Nie zapisano zmian!", vim.log.levels.WARN)
  else
    vim.cmd("qa")
  end
end, { desc = "Quit if no unsaved changes" })

