require("lspconfig").bashls.setup{}
require("lspconfig").clangd.setup{}
require("lspconfig").cmake.setup{}
require("lspconfig").html.setup{}
require("lspconfig").rust_analyzer.setup{}
require("lspconfig").pyright.setup{}

require('rust-tools').setup()

local sumneko_root_path = "/home/shivix/.lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"

require'lspconfig'.sumneko_lua.setup {
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

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}

require("nvim-treesitter.configs").setup{highlight = {enable = true}}
