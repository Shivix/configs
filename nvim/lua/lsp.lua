local on_init = function(client, _)
    client.server_capabilities.semanticTokensProvider = nil
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false

require("lspconfig").clangd.setup {
    capabilities = capabilities,
    on_init = on_init,
}
require("lspconfig").gopls.setup {
    capabilities = capabilities,
    on_init = on_init,
}
require("lspconfig").lua_ls.setup {
    capabilities = capabilities,
    on_init = on_init,
    settings = {
        Lua = {
            runtime = {
                version = "Lua 5.4",
            },
            diagnostics = { globals = { "vim" } },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                }
            },
            telemetry = { enable = false },
        },
    },
}
require("lspconfig").pyright.setup {
    capabilities = capabilities,
    on_init = on_init,
}
require("lspconfig").rust_analyzer.setup {
    capabilities = capabilities,
    on_init = on_init,
}
require("lspconfig").zls.setup {
    capabilities = capabilities,
    on_init = on_init,
}
