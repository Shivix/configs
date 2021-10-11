require("lspconfig").bashls.setup{}
require("lspconfig").clangd.setup{}
require("lspconfig").cmake.setup{}
require("lspconfig").html.setup{}
require("lspconfig").rust_analyzer.setup{}
require("lspconfig").pyright.setup{}

local sumneko_root_path = "/home/shivix/.lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"

require("lspconfig").sumneko_lua.setup{
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';')
            },
            diagnostics = {globals = {'vim'}},
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true,
						   [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
            },
			telemetry = {enable = false}
        }
    }
}

vim.o.completeopt = "menuone,noselect"

local cmp = require("cmp")
cmp.setup{
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'buffer' },
        { name = 'path' },
    }
}

