require "nvchad.options"

vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber= true

-- Wyłączam pliki tymczasowe, które pozwalają na ich odzyskiwanie itp, bez śmieci
vim.opt.swapfile = false


-- Utrzymuj zaznaczenie po shiftowaniu w trybie wizualnym
vim.cmd([[
  xnoremap < <gv
  xnoremap > >gv
]])

-- Sekcja z podświetlaniem podczas szukajki
vim.o.hlsearch = true -- podświetlenie włączone (domyślnie)
