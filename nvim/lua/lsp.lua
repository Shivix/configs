local on_attach = function(client, _)
    client.server_capabilities.semanticTokensProvider = nil
end

require("lspconfig").clangd.setup {
    on_attach = on_attach,
}
require("lspconfig").pyright.setup {
    on_attach = on_attach,
}
require("lspconfig").rust_analyzer.setup {
    on_attach = on_attach,
}
require("lspconfig").gopls.setup {
    on_attach = on_attach,
}
require("lspconfig").sumneko_lua.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
}
