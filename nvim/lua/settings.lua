vim.g.mapleader = " "

vim.opt.clipboard = "unnamed"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.icm = "split"
vim.opt.ignorecase = true
vim.opt.iskeyword:remove("_")
vim.opt.laststatus = 3
vim.opt.mouse = nil
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.signcolumn = "no"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.undofile = true

-- nvim can auto detect this on startup, we do it manually to improve startup time
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
