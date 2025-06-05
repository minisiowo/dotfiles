return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  
  config = function()
    require("neo-tree").setup({
      window = {
        position = "right",
        width = 30,
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_default",
      },
    })

    require('transparent').clear_prefix('NeoTree')
    vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")
  end,
}
