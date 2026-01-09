-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- EXAMPLE
local servers = { "html", "cssls", "angularls", "graphql", "ts_ls", "basedpyright" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  if lsp ~= "basedpyright" then
    vim.lsp.config[lsp] = {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end
end

vim.lsp.config.basedpyright = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,

  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",     
        reportMissingTypeStubs = false,
        diagnosticMode = "workspace",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        watchForSourceChanges = true,
      },
    },
  },
}

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

-- configuring single server, example: typescript
-- vim.lsp.config.ts_ls = {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
