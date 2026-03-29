local ls = require("luasnip")

return {
    ls.snippet("resetbox", {
        ls.text_node({
            "*, *::before, *::after {",
            "    box-sizing: border-box;",
            "}",
            "",
            "* {",
            "    margin: 0;",
            "    padding: 0;",
            "    line-height: 1.5;",
            "}",
        }),
    }),
}
