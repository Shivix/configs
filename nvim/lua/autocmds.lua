local function deduce_j2_filetype()
    local filename = vim.api.nvim_buf_get_name(0)
    local _, dot_count = filename:gsub("[.]", "")
    local begin_pos = 0
    for _ = 1, dot_count - 1 do
        begin_pos = filename:find("[.]", begin_pos) + 1
    end
    local end_pos = filename:find(".j2") - 1
    local filetype = filename:sub(begin_pos, end_pos)
    if filetype == "yml" then
        filetype = "yaml"
    end
    vim.bo.filetype = filetype
end

vim.api.nvim_create_augroup("main_group", {})
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 150, on_visual = true }
    end,
    group = "main_group",
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.j2",
    callback = deduce_j2_filetype,
    group = "main_group",
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.rs",
    callback = function()
        vim.opt.makeprg = "cargo build"
        vim.opt.errorformat = '%Eerror: %m,'..'%Wwarning: %m,'..'%Inote: %m,'..'%C %#--> %f:%l:%c'
        vim.cmd("packadd termdebug")
        vim.g.termdebugger = "rust-gdb"
    end,
    group = "main_group",
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.cpp,*.hpp,*.c,*.h,*.cxx,*.hxx",
    callback = function()
        vim.cmd("packadd termdebug")
    end,
    group = "main_group",
})
