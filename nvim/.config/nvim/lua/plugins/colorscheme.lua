local M = {}

M.setup = function ()
    require("kanagawa").setup({
        transparent = true,
        overrides = function(colors)
            local theme = colors.theme

            return {
                NormalFloat = { bg = "none" },
                FloatBorder = { bg = "none" },
                FloatTitle = { bg = "none" },
                NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                MiniPickPrompt = { bg = "none" },
                MiniPickPromptPrefix = { bg = "none" },
                BlinkCmpMenu = { link = "NormalFloat" },
                BlinkCmpMenuBorder = { link = "FloatBorder" },
                BlinkCmpDocumentation = { link = "NormalFloat" },
                BlinkCmpDocumentationBorder = { link = "FloatBorder" },
                BlinkCmpMenuSelection = {
                    bg = "none",
                    fg = theme.syn.special1,
                    bold = true,
                    underline = false,
                },
            }
        end,
        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none",
                    },
                },
            },
        },
    })

    vim.cmd("colorscheme kanagawa-dragon")
end

return M
