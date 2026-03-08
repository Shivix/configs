local close_by_open = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
}

local function count_opens(line, cursor_pos, open)
    local prefix = line:sub(1, cursor_pos)
    local match = prefix:match("[" .. open .. "]+$")
    return #match or 0
end

vim.keymap.set("i", "<CR>", function()
    local line = vim.api.nvim_get_current_line()

    if vim.bo.filetype == "lua" then
        if line:match("^%s*if.+then$") or line:match("^%s*for.+do$") then
            return "end<Left><Left><Left><CR><ESC>O"
        end
    end

    local cursor_pos = vim.api.nvim_win_get_cursor(0)[2]
    -- If there are characters after open or cursor is not at end of line, won't match any opens.
    local open = line:sub(cursor_pos)
    local close = close_by_open[open]
    if close ~= nil then
        local n = count_opens(line, cursor_pos, open)
        return string.rep(close .. "<Left>", n) .. "<CR><ESC>==O"
    end
    return "<CR>"
end, { expr = true })

vim.keymap.set("n", "<C-b>", "<C-^>")

vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "Jk", "<Esc>")
vim.keymap.set("t", "jk", "<C-\\><C-n>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-j>", function()
    local win_below = vim.fn.win_getid(vim.fn.winnr("j"))
    local current_win = vim.api.nvim_get_current_win()

    if win_below == current_win or win_below == 0 then
        vim.cmd("copen")
    else
        vim.cmd("wincmd j")
    end
end)
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<leader>s", ":set spell!<CR>")

vim.keymap.set("i", "<Down>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    else
        return "<Down>"
    end
end, { expr = true })
vim.keymap.set("i", "<Up>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    else
        return "<Up>"
    end
end, { expr = true })
vim.keymap.set("i", "<Tab>", function()
    local col = vim.fn.col(".")
    local char = vim.fn.getline("."):sub(col - 1, col - 1)
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    elseif char:match("[%a%p]") then
        if vim.bo.omnifunc == "" then
            return "<C-n>"
        end
        return "<C-x><C-o>"
    else
        return "<Tab>"
    end
end, { expr = true })

vim.keymap.set("n", "gd", function()
    if vim.bo.filetype ~= "man" then
        return vim.lsp.buf.definition()
    end
    local word = vim.fn.expand("<cWORD>")
    local match = word:match("[%w.@_-]+%(%w+%)")

    if match then
        vim.cmd("Man " .. match)
    end
end)
vim.keymap.set("n", "gh", ClangSwitchHeader)
vim.keymap.set("n", "<C-n>", function()
    vim.diagnostic.jump { count = 1 }
end)
vim.keymap.set("n", "<C-p>", function()
    vim.diagnostic.jump { count = -1 }
end)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>fs", "1z=")

-- RTS style keybinds for using marks
for i = 1, 9 do
    vim.keymap.set("n", "<C-" .. i .. ">", function()
        vim.cmd("norm!m" .. string.char(64 + i))
        print("Control group " .. i .. " set")
    end)
    vim.keymap.set("n", "g" .. i, function()
        local _, _, bufnr, filename = unpack(vim.api.nvim_get_mark(string.char(64 + i), {}))
        if filename == "" then
            print("Mark for " .. i .. " not set")
            return
        end
        if bufnr ~= 0 then
            vim.api.nvim_set_current_buf(bufnr)
        else
            vim.cmd("edit " .. filename)
        end
    end)
end
