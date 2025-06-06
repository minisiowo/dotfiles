-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("options.options")
require("options.filesettings")

-- Jawne ładowanie pluginów
local plugins = {
  require("plugins.oneliners"),
  require("plugins.catppuccin"),
  require("plugins.telescope"),
  require("plugins.treesitter"),
  require("plugins.neo-tree"),
}

require("lazy").setup(plugins, {
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true },
})

