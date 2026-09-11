local M = {}

M.setup = function ()

    -- LuaLS cannot infer this plugin's annotated setup argument.
    ---@diagnostic disable-next-line: redundant-parameter
    require("typst-preview").setup{
        dependencies_bin = {
            tinymist = "tinymist",
        },
    }

end

return M
