local function escape(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.g.mapleader = escape("<Space>")
vim.g.gruvbox_bold = 0
vim.g.gruvbox_contrast_dark = "hard"
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1

vim.api.nvim_exec([[
    colorscheme gruvbox
    hi Normal guibg=NONE
    command Bd bp|bd #
    au TextYankPost * lua vim.highlight.on_yank{higroup='IncSearch', timeout=150, on_visual=true}
    au TermOpen * setlocal nonumber norelativenumber showtabline=0
    au BufNew,BufRead *.yml.j2 set ft=yaml
]], true)

vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.conceallevel = 3
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.iskeyword:remove('_'); -- treat underscores as word breaks

