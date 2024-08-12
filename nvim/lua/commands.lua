vim.api.nvim_create_user_command("Fd", "args `fd <args>`", { nargs = 1 })
vim.api.nvim_create_user_command("QFRun", "cexpr execute('!<args>')", { nargs = 1 })

vim.api.nvim_create_user_command("Blame", function()
    local pos = vim.api.nvim_win_get_cursor(0)[1]
    vim.cmd("!git blame -wCCC % -L" .. pos .. "," .. pos)
end, { nargs = 0 })
vim.api.nvim_create_user_command("Format", function()
    if vim.bo.modified then
        print("Please save the buffer before formatting")
        return
    end
    vim.cmd("!" .. Formatter .. " %")
end, { nargs = 0 })
vim.api.nvim_create_user_command("Lint", function()
    vim.cmd("!" .. Linter .. " %")
end, { nargs = 0 })

vim.api.nvim_create_user_command("GdbB", function()
    local gdb_cmd = "b " .. vim.fn.expand("%") .. ":" .. vim.fn.line(".")
    vim.fn.setreg("+", gdb_cmd)
end, { nargs = 0 })
vim.api.nvim_create_user_command("Debug", function(opts)
    if vim.fn.exists(":Termdebug") == 0 then
        vim.cmd("packadd termdebug")
    end
    vim.cmd("Termdebug")
    if opts.args ~= "" then
        vim.cmd("call TermDebugSendCommand('target remote :" .. opts.args .. "')")
    end
end, { nargs = "?" })

vim.api.nvim_create_user_command("GHLink", function()
    local remote =
        vim.fn.system("git remote get-url upstream 2>/dev/null || git remote get-url origin")
    local repo = remote:match("github.com[:/](.+).git")
    assert(repo, "repo not found")
    local file = vim.fn.expand("%")
    local line = vim.fn.line(".")
    vim.fn.setreg("+", "github.com/" .. repo .. "/blob/master/" .. file .. "#L" .. line)
end, { nargs = 0 })

function GetLine(offset)
    local cur_line = vim.fn.line(".")
    return vim.fn.getline(cur_line + offset)
end
