return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			float = {
				transparent = true,
			},
		},
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd("colorscheme catppuccin")
        end,
	},
    -- {
    --     "rebelot/kanagawa.nvim",
    --     opts = {
    --         transparent = true,
    --         theme = "dragon",
    --         overrides = function(colors)
    --             local theme = colors.theme
    --             return {
    --                 NormalFloat                 = { bg = "none" },
    --                 FloatBorder                 = { bg = "none" },
    --                 FloatTitle                  = { bg = "none" },
    --
    --                 -- Ciemniejsze tło dla niektórych okien
    --                 NormalDark                  = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
    --
    --                 -- blink.cmp – przezroczyste menu i dokumentacja
    --                 BlinkCmpMenu                = { link = "NormalFloat" },
    --                 BlinkCmpMenuBorder          = { link = "FloatBorder" },
    --                 BlinkCmpDocumentation       = { link = "NormalFloat" },
    --                 BlinkCmpDocumentationBorder = { link = "FloatBorder" },
    --
    --                 -- czytelna selekcja bez tła (podkreślenie/bold zamiast bg)
    --                 BlinkCmpMenuSelection       = { bg = "none", fg = theme.syn.special1, bold = true, underline = false },
    --
    --                 -- Popularne pluginy
    --                 LazyNormal                  = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    --                 MasonNormal                 = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    --             }
    --         end,
    --     },
    --     config = function(_, opts)
    --         require("kanagawa").setup(opts)
    --         vim.cmd("colorscheme kanagawa-dragon")
    --     end,
    -- },
    -- {
    --     "tahayvr/matteblack.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         -- vim.cmd.colorscheme "matteblack"
    --         require("matteblack").colorscheme()
    --     end,
    -- }
}
