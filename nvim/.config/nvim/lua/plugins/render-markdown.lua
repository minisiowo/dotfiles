local M = {}

M.setup = function ()
    -- LuaLS cannot infer this plugin's annotated setup argument.
    ---@diagnostic disable-next-line: redundant-parameter
    require("render-markdown").setup({
        heading = {
            icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
            width = "block",
        },
    })
end

return M
