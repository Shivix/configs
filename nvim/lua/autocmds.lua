local main_group = "main_group"
local function create_buf_enter_autocmd(pattern, callback)
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = pattern,
        callback = callback,
        group = main_group,
    })
end
vim.api.nvim_create_augroup(main_group, {})
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 150, on_visual = true }
    end,
    group = main_group,
})
-- If there is no / in the pattern, vim will only check against the filename
create_buf_enter_autocmd("*.*.j2", function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    local filetype = buf_name:match("([^.]+).j2$")
    if filetype == "yml" then
        filetype = "yaml"
    end
    vim.bo.filetype = filetype
end)
create_buf_enter_autocmd("configmap.yaml", function()
    vim.bo.filetype = "helm"
end)
create_buf_enter_autocmd("*.rs", function()
    vim.opt.makeprg = "cargo build"
    vim.opt.errorformat = "%Eerror: %m," .. "%Wwarning: %m," .. "%Inote: %m," .. "%C %#--> %f:%l:%c"
    vim.cmd("packadd termdebug")
    vim.g.termdebugger = "rust-gdb"
    Formatter = "rustfmt"
end)
create_buf_enter_autocmd("*.cpp,*.hpp,*.c,*.h,*.cxx,*.hxx", function()
    vim.cmd("packadd termdebug")
    Formatter = "clang-format -i"
end)
create_buf_enter_autocmd("*.go", function()
    vim.cmd("packadd termdebug")
    Formatter = "go fmt"
end)
create_buf_enter_autocmd("*.lua", function()
    Formatter = "stylua"
end)
create_buf_enter_autocmd("scratch.md", function()
    vim.opt.foldmethod = "expr"
    vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
end)
