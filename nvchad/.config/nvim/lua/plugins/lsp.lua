return {

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- PYTHON SECTION
        "pyright",
        "black",
        "isort",
        -- LUA
        "lua-language-server",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "lua-language-server",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
     config = function()
        require "configs.lspconfig"
     end,
  },

}
