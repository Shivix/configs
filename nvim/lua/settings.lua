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
]], true)

vim.api.nvim_create_augroup("main_group", {})
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank{higroup='IncSearch', timeout=150, on_visual=true}
    end,
    group = "main_group"
})
vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter","TabEnter"}, {
    pattern = "*.yml.j2",
    command = "set ft=yaml",
    group = "main_group"
})
vim.api.nvim_create_autocmd("TermOpen", {
    command = "setlocal nonumber norelativenumber showtabline=0",
    group = "main_group"
})

vim.g.clipboard = {
    name = "xsel",
    copy = {
        ['+'] = "xsel -ib",
        ['*'] = "xsel -ib",
    },
    paste = {
        ['+'] = "xsel -ob",
        ['*'] = "xsel -ob",
    },
    cache_enabled = 0,
}

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
