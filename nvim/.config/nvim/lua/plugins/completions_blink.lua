return {
    {   -- completions
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                dependencies = { "rafamadriz/friendly-snippets" },
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("luasnip.loaders.from_lua").lazy_load({
                        paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
                    })
                end,
            },
        },
        version = "1.*",

        opts = {
            keymap = {
                preset = "default",
                ["<C-b>"] = false,
                ["<C-f>"] = false,
                ["<S-Up>"] = { "scroll_documentation_up", "fallback" },
                ["<S-Down>"] = { "scroll_documentation_down", "fallback" },
            }, -- "default" "super-tab", "enter" lub "none"
            appearance = {
                nerd_font_variant = "mono"
            },
            completion = { documentation = { auto_show = false } }, -- zmien na true, jeśli okno dokumentacji ma się pojawiać automatycznie
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
}
