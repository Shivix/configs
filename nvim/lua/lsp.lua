require("lspconfig").bashls.setup{}
require("lspconfig").clangd.setup{}
require("lspconfig").cmake.setup{}
require("lspconfig").html.setup{}
require("lspconfig").pyright.setup{}
require("lspconfig").rust_analyzer.setup{}
-- rust analyzer setup through rust-tools plugin

local sumneko_root_path = "/home/shivix/.lua-language-server"
local sumneko_binary = "/usr/bin/lua-language-server"

require("lspconfig").sumneko_lua.setup{
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ';')
            },
            diagnostics = {globals = {"vim"}},
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						   [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true}
            },
			telemetry = {enable = false}
        }
    }
}

