vim.g.mapleader = " "
vim.g.gruvbox_bold = 0
vim.g.gruvbox_contrast_dark = "hard"

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
vim.opt.iskeyword:remove("_") -- treat underscores as word breaks

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

--[[local function root_dir()
    local current_dir = vim.fn.expand("%:p:h")
    local home_dir = os.getenv("HOME")

    if not current_dir:find(home_dir) then
        return
    end

    while current_dir ~= home_dir do
        local file = io.open(current_dir .. "/.git", "r")
        if file ~= nil then
            io.close(file)
            vim.api.nvim_set_current_dir(current_dir)
            return
        end
        -- set to parent directory
        current_dir = current_dir:sub(1, current_dir:match(".*/()") - 2)
    end
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = root_dir,
    group = "main_group",
})]]--
