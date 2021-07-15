local function escape(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.g.mapleader = escape("<Space>")

vim.g.gruvbox_bold = 0
vim.g.gruvbox_contrast_dark = "hard"
vim.cmd("colorscheme gruvbox")
vim.cmd("set iskeyword-=_")  -- treat underscores as word breaks
vim.cmd("au TextYankPost * lua vim.highlight.on_yank {higroup='IncSearch', timeout=150, on_visual=true}")

vim.o.showmode = false
vim.o.hidden = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.conceallevel = 0
vim.wo.conceallevel = 0
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.smartindent = true
vim.bo.smartindent = true
vim.o.relativenumber = true
vim.wo.relativenumber = true
vim.o.number = true
vim.wo.number = true
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.o.cursorline = true
vim.wo.cursorline = true
vim.o.undofile = true
vim.bo.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Activate plugins
local custom_gruvbox = require("lualine.themes.gruvbox")
custom_gruvbox.normal.a.bg = "#CC8400"
require("lualine").setup{options = {theme  = custom_gruvbox}}
require("bufferline").setup{options = {show_buffer_close_icons = false}}
require("colorizer").setup{}
require("hop").setup{}
require("gitsigns").setup{}
require("telescope").setup{}
require("telescope").load_extension("fzy_native")
require("todo-comments").setup{}

-- Make Ranger replace netrw and be the file explorer
vim.g.rnvimr_ex_enable = 1

-- Startify settings
vim.g.startify_session_dir = "~/.config/nvim/session"
vim.g.startify_lists = {{ type = "files",	   	header = {"   Files"}},
						{ type = "dir",       	header = {"   Current Directory ".. vim.fn.getcwd()}},
						{ type = "sessions",  	header = {"   Sessions"}},
						{ type = "bookmarks", 	header = {"   Bookmarks"}}}

vim.g.startify_bookmarks = {"~/.config/nvim/lua/settings.lua",
							"~/.config/nvim/lua/plugins.lua",
							"~/.config/nvim/lua/mappings.lua",
							"~/.config/nvim/lua/lsp.lua",
							"~/.config/fish/config.fish",
							"~/Documents/Notes/ProjectIdeas.md",
							"~/Documents",
							"~/CppProjects",
							"~/RustProjects",
							"~/BashProjects",
							"~/LuaProjects",
							"~/HTMLProjects",
							"~/HaskellProjects",
							"~/GitHub"}

vim.g.startify_change_to_vcs_root = 1

vim.g.startify_custom_header = {[[        _   __         _    ___          ]],
								[[       / | / /__  ____| |  / (_)___ ___  ]],
								[[      /  |/ / _ \/ __ \ | / / / __ `__ \ ]],
								[[     / /|  /  __/ /_/ / |/ / / / / / / / ]],
								[[    /_/ |_/\___/\____/|___/_/_/ /_/ /_/  ]]}

