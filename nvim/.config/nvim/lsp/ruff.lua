---@type vim.lsp.Config
return {
  settings = vim.NIL,
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
