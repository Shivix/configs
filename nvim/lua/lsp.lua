require("lspconfig").clangd.setup {}
require("lspconfig").bashls.setup {}
require("lspconfig").html.setup {}
require("lspconfig").pyright.setup {}
require("lspconfig").rust_analyzer.setup {}
require("lspconfig").gopls.setup {}

local sumneko_root_path = "/home/shivix/.lua-language-server"
local sumneko_binary = "/usr/bin/lua-language-server"

require("lspconfig").sumneko_lua.setup {
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
            },
            telemetry = { enable = false },
        },
    },
}
