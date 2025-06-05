return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    local mason = require 'mason'
    local mason_tool_installer = require 'mason-tool-installer'

    -- enable mason and configure icons
    mason.setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    mason_tool_installer.setup {
      ensure_installed = {
        -- LSP servers
        'lua-language-server',
        'typescript-language-server',
        'html-lsp',
        'css-lsp',
        'tailwindcss-language-server',
        'pyright',
        'ruff',
        'dockerfile-language-server',
        'sqlls',
        'terraform-ls',
        'json-lsp',
        'yaml-language-server',

        -- Formatters
        'prettier',
        'stylua',
        'shfmt',

        -- Linters
        'eslint_d',
        'checkmake',
        'hadolint',
        'shellcheck',
      },
      auto_update = false,
      run_on_start = true,
    }
  end,
}
