local main_group = "main_group"
local function create_autocmd(event, pattern, callback)
    vim.api.nvim_create_autocmd(event, {
        pattern = pattern,
        callback = callback,
        group = main_group,
    })
end
vim.api.nvim_create_augroup(main_group, {})

create_autocmd("TextYankPost", nil, function()
    vim.hl.on_yank()
end)
-- If there is no / in the pattern, vim will only check against the filename
create_autocmd({ "BufRead", "BufNewFile" }, "*.*.j2", function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    local filetype = buf_name:match("([^.]+).j2$")
    if filetype == "yml" then
        filetype = "yaml"
    end
    vim.bo.filetype = filetype
end)
create_autocmd({ "BufRead", "BufNewFile" }, "configmap.yaml", function()
    vim.bo.filetype = "helm"
end)
create_autocmd({ "BufRead", "BufNewFile" }, "*.zsh", function()
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
    if vim.fn.isdirectory("cmake-build-debug") == 1 then
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
    vim.opt.makeprg = "luac -p %"
    vim.opt.errorformat = "luac: %f:%l: %m"
end)
create_autocmd("BufEnter", "*.py", function()
    Formatter = "ruff format"
end)
create_autocmd("BufEnter", "*.zig", function()
    vim.opt.makeprg = "zig build"
    Formatter = "zig fmt"
end)

create_autocmd("BufEnter", "*.sent", function()
    vim.cmd([[
        syntax match Macro "^@.*$"
        syntax match Comment "^#.*$"
        syntax match Operator "\\"
    ]])
end)
create_autocmd("BufEnter", "*.lus", function()
    vim.cmd("set ft=markdown")
end)

create_autocmd("VimEnter", "*", function()
    -- Do not use if we're diffing files
    if vim.opt.diff:get() then
        return
    end
    local files = vim.fn.argv()
    if type(files) == "table" and #files > 1 then
        local qflist = {}
        for _, file in ipairs(files) do
            table.insert(qflist, { filename = file, lnum = 1 })
        end
        vim.fn.setqflist(qflist, "r")
        vim.cmd("copen")
    end
end)

local function remove_quickfix_item()
    local list = vim.fn.getqflist()
    local item_pos = vim.fn.line(".")
    table.remove(list, item_pos)
    vim.fn.setqflist(list, "r")
    vim.fn.cursor(item_pos, 1)
end
create_autocmd("FileType", "qf", function()
    vim.keymap.set("n", "dd", remove_quickfix_item, { buffer = 0 })
end)
