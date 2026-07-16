local M = {}

M.setup = function ()

    require("typst-preview").setup{
        dependencies_bin = {
            tinymist = "tinymist",
        },
    }

end

return M
