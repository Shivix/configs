local function escape(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.g.mapleader = escape("<Space>")
vim.g.gruvbox_bold = 0
vim.g.gruvbox_contrast_dark = "hard"

vim.api.nvim_exec([[
    au colorscheme * hi Normal guibg=NONE
    colorscheme gruvbox
    command Bd bp|bd #
    au TextYankPost * lua vim.highlight.on_yank{higroup='IncSearch', timeout=150, on_visual=true}
    au TermOpen * setlocal nonumber norelativenumber showtabline=0
    au BufEnter,BufWinEnter,TabEnter *.yml.j2 set ft=yaml
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
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.iskeyword:remove('_'); -- treat underscores as word breaks

--remove after 6.0
vim.g.did_load_filetypes = 1

local disabled_plugins = {
    "getscript",
    "getscriptPlugin",
    "logipat",
    "remote_plugins",
    "rrhelper",
    "tar",
    "tarPlugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin"
}
for _, plugin in pairs(disabled_plugins) do
    vim.g["loaded_" .. plugin] = 1
end
