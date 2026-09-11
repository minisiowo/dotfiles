local M = {}

-- Stock Omarchy themes use these plugins. Keeping them installed makes theme
-- switches instant and avoids doing network work from the file watcher.
M.packages = {
    { src = "https://github.com/bjarneo/aether.nvim", name = "aether", version = "v3" },
    "https://github.com/bjarneo/hackerman.nvim",
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/neanias/everforest-nvim",
    "https://github.com/kepano/flexoki-neovim",
    "https://github.com/ellisonleao/gruvbox.nvim",
    "https://github.com/rebelot/kanagawa.nvim",
    "https://github.com/omacom-io/lumon.nvim",
    "https://github.com/tahayvr/matteblack.nvim",
    "https://github.com/EdenEast/nightfox.nvim",
    "https://github.com/ribru17/bamboo.nvim",
    "https://github.com/OldJobobo/retro-82.nvim",
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    "https://github.com/ficcdaf/ashen.nvim",
    "https://github.com/folke/tokyonight.nvim",
}

-- Lazy specs identify plugins by repository, while setup() usually lives in a
-- shorter Lua module. This map bridges the generated Omarchy file to vim.pack.
M.modules = {
    ["bjarneo/aether.nvim"] = "aether",
    ["bjarneo/hackerman.nvim"] = "hackerman",
    ["catppuccin/nvim"] = "catppuccin",
    ["neanias/everforest-nvim"] = "everforest",
    ["kepano/flexoki-neovim"] = "flexoki",
    ["ellisonleao/gruvbox.nvim"] = "gruvbox",
    ["rebelot/kanagawa.nvim"] = "kanagawa",
    ["omacom-io/lumon.nvim"] = "lumon",
    ["tahayvr/matteblack.nvim"] = "matteblack",
    ["EdenEast/nightfox.nvim"] = "nightfox",
    ["ribru17/bamboo.nvim"] = "bamboo",
    ["OldJobobo/retro-82.nvim"] = "retro-82",
    ["rose-pine/neovim"] = "rose-pine",
    ["ficcdaf/ashen.nvim"] = "ashen",
    ["folke/tokyonight.nvim"] = "tokyonight",
}

return M
