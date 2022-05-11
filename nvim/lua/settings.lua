vim.g.mapleader = " "
vim.g.gruvbox_bold = 0

-- stylua: ignore
vim.api.nvim_exec( [[
    au colorscheme * hi Normal guibg=NONE
    colorscheme gruvbox
    command Bd bp|bd #
]], true)

vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamed"
vim.opt.laststatus = 3
vim.opt.iskeyword:remove("_") -- treat underscores as word breaks
vim.opt.path:append("**")

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

vim.api.nvim_create_augroup("main_group", {})
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 150, on_visual = true }
    end,
    group = "main_group",
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.yml.j2",
    command = "set ft=yaml",
    group = "main_group",
})
vim.api.nvim_create_autocmd("TermOpen", {
    command = "setlocal nonumber norelativenumber showtabline=0",
    group = "main_group",
})

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
    "zipPlugin",
}
for _, plugin in pairs(disabled_plugins) do
    vim.g["loaded_" .. plugin] = 1
end
