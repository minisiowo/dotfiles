return {
  'xiyaowong/transparent.nvim',
  lazy = false, -- Important! Don't lazy load this plugin
  priority = 1000, -- Load this before other plugins
  config = function()
    require('transparent').setup {
      extra_groups = {
        -- Base groups
        'NormalFloat',
        'NvimTreeNormal',
      },
    }

    -- Clear specific plugin highlights
    require('transparent').clear_prefix 'BufferLine'
    require('transparent').clear_prefix 'NeoTree'
    -- require('transparent').clear_prefix 'lualine'

    -- Additional transparency groups for dynamic highlights
    vim.g.transparent_groups = vim.list_extend(
      vim.g.transparent_groups or {},
      vim.tbl_map(function(v)
        return v.hl_group
      end, vim.tbl_values(require('bufferline.config').highlights))
    )
  end,
}
