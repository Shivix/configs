vim.g.mapleader = " "
vim.g.gruvbox_bold = 0

-- stylua: ignore
vim.api.nvim_exec( [[
    colorscheme gruvbox
]], true)
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })

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
vim.opt.signcolumn = "no"
vim.opt.iskeyword:remove("_") -- treat underscores as word breaks

vim.api.nvim_create_user_command("Fd", "args `fd <args>`", { nargs = 1 })

vim.api.nvim_create_augroup("main_group", {})
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 150, on_visual = true }
    end,
    group = "main_group",
})
local function deduce_filetype()
    local filename = vim.api.nvim_buf_get_name(0)
    local begin_pos = filename:find("[.]") + 1
    local end_pos = filename:find(".j2") - 1
    vim.bo.filetype = filename:sub(begin_pos, end_pos)
end
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.j2",
    callback = deduce_filetype,
    group = "main_group",
})

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
