return {
	{
		"nvim-lualine/lualine.nvim",
		opts = function()
			local theme = require("lualine.themes.auto")

			for _, mode in pairs(theme) do
				for _, section in pairs(mode) do
					section.bg = "none"
				end
			end

			return {
				options = {
					theme = theme,
					disabled_filetypes = {
						statusline = { "NvimTree" },
					},
				},
				sections = {
					lualine_a = {},
					lualine_c = { {
						"filename",
						path = 1,
					} },
					lualine_b = { "branch", "diff" },
					lualine_x = { "filetype" },
					lualine_y = {
						{
							"diagnostics",
							sources = { "nvim_workspace_diagnostic" },
						},
					},
					lualine_z = {},
				},
			}
		end,
	},
}
