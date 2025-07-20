vim.g.mapleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_winsize = -35

vim.opt.clipboard = "unnamed"
vim.opt.completeopt = "menu,menuone,popup"
vim.opt.expandtab = true
vim.opt.icm = "split"
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = "tab:» ,trail:*"
vim.opt.mouse = ""
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.signcolumn = "no"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.loader.enable()

vim.g.clipboard = {
    name = "xsel",
    copy = {
        ["+"] = "xsel -ib",
        ["*"] = "xsel -ib",
    },
    paste = {
        ["+"] = "xsel -ob",
        ["*"] = "xsel -ob",
    },
    cache_enabled = 0,
}
