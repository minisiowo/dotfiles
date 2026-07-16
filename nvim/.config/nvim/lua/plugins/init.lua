vim.pack.add({
    "https://github.com/rebelot/kanagawa.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/christoomey/vim-tmux-navigator",
    { src = "https://github.com/Saghen/blink.cmp", version = "v1" },
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("3") },
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    -- { src = "https://github.com/obsidian-nvim/obsidian.nvim", version = vim.version.range "*" },
    "https://github.com/kdheepak/lazygit.nvim",
    "https://github.com/mikavilpas/yazi.nvim",
    "https://codeberg.org/andyg/leap.nvim.git",
    "https://github.com/chomosuke/typst-preview.nvim",
})

require("plugins.colorscheme").setup()
require("plugins.mini").setup()
require("plugins.blink").setup()
require("plugins.render-markdown").setup()
-- require("plugins.obsidian-nvim").setup()
require("plugins.neo-tree").setup()
require("plugins.treesitter").setup()
require("plugins.lsp").setup()
require("plugins.lazygit").setup()
require("plugins.yazi").setup()
require("plugins.leap").setup()
require("plugins.typst-preview").setup()
