local main_group = "main_group"
local function create_autocmd(event, pattern, callback)
    vim.api.nvim_create_autocmd(event, {
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
create_autocmd("BufEnter", "*.*.j2", function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    local filetype = buf_name:match("([^.]+).j2$")
    if filetype == "yml" then
        filetype = "yaml"
    end
    vim.bo.filetype = filetype
end)
create_autocmd("BufEnter", "configmap.yaml", function()
    vim.bo.filetype = "helm"
end)
create_autocmd("BufEnter", "*.zsh", function()
    vim.bo.filetype = "sh"
end)
create_autocmd("BufEnter", "*.rs", function()
    vim.opt.makeprg = "cargo build"
    vim.opt.errorformat = "%Eerror: %m," .. "%Wwarning: %m," .. "%Inote: %m," .. "%C %#--> %f:%l:%c"
    vim.g.termdebugger = "rust-gdb"
    Formatter = "rustfmt"
end)
create_autocmd("BufEnter", "*.cpp,*.hpp,*.c,*.h,*.cxx,*.hxx", function()
    Linter = "clang-tidy"
    Formatter = "clang-format -i"
    if vim.fn.isdirectory("cmake-build-debug") then
        vim.opt.makeprg = "make --no-print-directory -j -C cmake-build-debug"
    else
        vim.opt.makeprg = "make -j"
    end
end)
create_autocmd("BufEnter", "*.go", function()
    Formatter = "go fmt"
end)
create_autocmd("BufEnter", "*.lua", function()
    Linter = "selene"
    Formatter = "stylua"
end)
create_autocmd("BufEnter", "*.py", function()
    Formatter = "yapf -i"
end)
create_autocmd("BufEnter", "scratch.md", function()
    vim.opt.foldmethod = "expr"
    vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
end)
create_autocmd("BufLeave", "scratch.md", function()
    vim.opt.foldmethod = "manual"
    vim.wo.foldexpr = ""
end)

local function remove_quickfix_item()
    local list = vim.fn.getqflist()
    local item_pos = vim.fn.line(".")
    table.remove(list, item_pos)
    vim.fn.setqflist(list, "r")
    vim.fn.cursor(item_pos, 1)
end
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "d", remove_quickfix_item, { buffer = 0 })
    end,
})
