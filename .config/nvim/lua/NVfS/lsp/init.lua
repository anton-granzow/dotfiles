local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

--require "NVfS.lsp.lsp-installer"
require "NVfS.lsp.mason"
require("NVfS.lsp.handlers").setup()
