local function quickfix_or_edit(shell_cmd, title)
    local lines = vim.fn.systemlist(shell_cmd)
    if #lines > 1 then
        local old_efm = vim.bo.errorformat
        vim.opt.errorformat = "%f"
        vim.fn.setqflist({}, " ", { title = title, lines = lines })
        vim.cmd("copen")
        vim.opt.errorformat = old_efm
    elseif #lines == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(lines[1]))
    end
end

vim.api.nvim_create_user_command("Fp", function(opts)
    local cmd = "fd --hidden --exclude .git --type file | fp --filter-scores -e " .. opts.args
    quickfix_or_edit(cmd, "Fp: " .. opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Fd", function(opts)
    local cmd = "fd --hidden --exclude .git --type file --full-path " .. opts.args
    quickfix_or_edit(cmd, "Fd: " .. opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("Fdp", function(opts)
    local cmd = "fd --hidden --exclude .git --type file --full-path "
        .. opts.args
        .. " | fp -e "
        .. opts.args
    quickfix_or_edit(cmd, "Fd: " .. opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Rg", function(opts)
    -- Combines args into one string compared to :grep
    local lines = vim.fn.systemlist("rg --vimgrep '" .. opts.args .. "'")
    if #lines > 1 then
        vim.fn.setqflist({}, " ", { title = "Rg: " .. opts.args, lines = lines })
        vim.cmd("copen")
    elseif #lines == 1 then
        local parts = vim.split(lines[1], ":")
        local row = tonumber(parts[2])
        local col = tonumber(parts[3])
        vim.cmd("edit " .. vim.fn.fnameescape(parts[1]))
        vim.api.nvim_win_set_cursor(0, { row, col - 1 })
    end
end, { nargs = "*" })

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
    -- Assumes pwd is the repo root directory.
    local file = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
    local line = vim.fn.line(".")
    vim.fn.setreg("+", "github.com/" .. repo .. "/blob/master/" .. file .. "#L" .. line)
end, { nargs = 0 })

function GetLine(offset)
    local cur_line = vim.fn.line(".")
    return vim.fn.getline(cur_line + offset)
end

vim.api.nvim_create_user_command("Prefix", function()
    local line = vim.api.nvim_get_current_line()
    local lines = vim.fn.systemlist("prefix -vor " .. vim.fn.shellescape(line))

    vim.lsp.util.open_floating_preview(lines, "dosini")
end, { nargs = 0 })

local ns = vim.api.nvim_create_namespace("hexcolors")
vim.api.nvim_create_user_command("ColourHex", function(opts)
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    if opts.args == "off" then
        return
    end
    for lnum, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
        for s, hex in line:gmatch("()#(%x%x%x%x%x%x)") do
            local group = "Hex_" .. hex
            vim.api.nvim_set_hl(0, group, { bg = "#" .. hex })
            vim.api.nvim_buf_set_extmark(0, ns, lnum - 1, s - 1, {
                end_col = s + 6,
                hl_group = group,
            })
        end
    end
end, { nargs = "?" })
