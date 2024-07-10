vim.api.nvim_create_user_command("Fd", "args `fd <args>`", { nargs = 1 })
vim.api.nvim_create_user_command("QFRun", "cexpr execute('!<args>')", { nargs = 1 })
vim.api.nvim_create_user_command("Todo", "vimgrep /TODO/g %", { nargs = 0 })
vim.api.nvim_create_user_command("Blame", function()
    local pos = vim.api.nvim_win_get_cursor(0)[1]
    vim.cmd("!git blame % -L" .. pos .. "," .. pos)
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
    vim.fn.system("echo " .. gdb_cmd .. " | " .. vim.g.clipboard.copy["+"] .. " --trim")
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

function GetLine(offset)
    local cur_line = vim.fn.line(".")
    return vim.fn.getline(cur_line + offset)
end
