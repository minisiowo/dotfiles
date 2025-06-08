-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "github_dark",
  transparency = true,
}

-- M.nvdash = { load_on_startup = true }
M.ui = {
  telescope = {style = "bordered"},
}

M.term = {
  winopts = { number = false },
  sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
  float = {
     row = 0.3, col = 0.25,
     width = 0.5, height = 0.4,
     border = "single",
  },
}

return M
