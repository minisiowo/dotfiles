return {
    {   -- completions
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets" },
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
