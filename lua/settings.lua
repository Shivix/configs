local function escape(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.g.mapleader = escape("<Space>")

vim.g.gruvbox_bold = 0
vim.g.gruvbox_contrast_dark = "hard"
vim.cmd("colorscheme gruvbox")

vim.cmd("set iskeyword-=_")  -- treat underscores as word breaks
-- vim.opt.iskeyword:remove("_")

vim.o.showmode = false
vim.o.hidden = true
vim.o.splitbelow = true		-- Horizontal splits will automatically be below
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
vim.o.clipboard = "unnamedplus" -- Copy paste between vim and everything else
vim.o.termguicolors = true
vim.o.cursorline = true
vim.wo.cursorline = true
vim.o.undofile = true
vim.bo.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true

local custom_gruvbox = require("lualine.themes.gruvbox")
custom_gruvbox.normal.a.bg = "#CC8400"
require("lualine").setup{options = {theme  = custom_gruvbox}}

require("bufferline").setup{options = {show_buffer_close_icons = false}}

require("colorizer").setup()

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

-- case insensitive easymotion
vim.g.EasyMotion_smartcase = 1


--[[
nnoremap  <leader>bc "eyy$:call CalcLines()<CR>

---------------------------------------------------------------------
Calculate:
    clean up an expression, pass it to bc, return answer
function! Calculate (s)

	let str = a:s

	-- remove newlines and trailing spaces
	let str = substitute (str, "\n",   "", "g")
	let str = substitute (str, '\s*$', "", "g")

	-- sub common func names for bc equivalent
	let str = substitute (str, '\csin\s*(',  's (', 'g')
	let str = substitute (str, '\ccos\s*(',  'c (', 'g')
	let str = substitute (str, '\catan\s*(', 'a (', 'g')
	let str = substitute (str, "\cln\s*(",   'l (', 'g')
	let str = substitute (str, '\clog\s*(',  'l (', 'g')
	let str = substitute (str, '\cexp\s*(',  'e (', 'g')

	-- alternate exponitiation symbols
	let str = substitute (str, '\*\*', '^', "g")
	let str = substitute (str, '`', '^',    "g")

	-- escape chars for shell
	let str = escape (str, '*();&><|')

	let preload = exists ("g:bccalc_preload") ? g:bccalc_preload : ""

	-- run bc
	let answer = system ("echo " . str . " \| bc -l " . preload)

	-- strip newline
	let answer = substitute (answer, "\n", "", "")

	-- strip trailing 0s in decimals
	let answer = substitute (answer, '\.\(\d*[1-9]\)0\+', '.\1', "")

	return answer
endfunction

---------------------------------------------------------------------
CalcLines:

--take expression from lines, either visually selected or the current line,
--pass to calculate function, echo or past answer after '='
function! CalcLines()

	let has_equal = 0

	-- remove newlines and trailing spaces
	let @e = substitute (@e, "\n", "",   "g")
	let @e = substitute (@e, '\s*$', "", "g")

	-- if we end with an equal, strip, and remember for output
	if @e =~ "=$"
		let @e = substitute (@e, '=$', "", "")
		let has_equal = 1
	endif

	-- if there is another equal in the line, assume chained equations, remove
	-- leading ones
	let @e = substitute (@e, '^.\+=', '', '')

	let answer = Calculate (@e)

	-- append answer or echo
	if has_equal == 1
		exec "normal a" . answer
	else
		echo "answer = " . answer
	endif
endfunction
]]
