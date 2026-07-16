local M = {}

M.setup = function ()
    require("render-markdown").setup({
        heading = {
            icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
            width = "block",
        },
    })
end

return M
