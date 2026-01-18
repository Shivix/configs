local key_sets = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
}

local function count_opens(line, col, open)
    local prefix = line:sub(1, col)
    local match = prefix:match("[" .. open .. "]+$")
    return #match or 0
end

vim.keymap.set("i", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local open = line:sub(pos)

    if vim.bo.filetype == "lua" then
        if line:match("^%s*if.+then$") or line:match("^%s*for.+do$") then
            return "end<Left><Left><Left><CR><ESC>O"
        end
    end

    local close = key_sets[open]
    if close ~= nil then
        local n = count_opens(line, pos, open)
        return string.rep(close.."<Left>", n).."<CR><ESC>==O"
    end
    return "<CR>"
end, { expr = true })

vim.keymap.set("n", "<C-b>", "<C-^>")

vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "Jk", "<Esc>")
vim.keymap.set("t", "jk", "<C-\\><C-n>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
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
vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<C-n>", function()
    vim.diagnostic.jump { count = 1 }
end)
vim.keymap.set("n", "<C-p>", function()
    vim.diagnostic.jump { count = -1 }
end)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)

local fzf = require("fzf-lua")
vim.keymap.set("n", "gr", fzf.lsp_references)
vim.keymap.set("n", "<leader>fe", fzf.lsp_workspace_diagnostics)
vim.keymap.set("n", "<leader>ff", fzf.files)
vim.keymap.set("n", "<leader>fg", fzf.live_grep)
vim.keymap.set("n", "<leader>fh", fzf.help_tags)
vim.keymap.set("n", "<leader>fj", fzf.jumps)
vim.keymap.set("n", "<leader>fo", fzf.oldfiles)
vim.keymap.set("n", "<leader>fq", fzf.quickfix)
vim.keymap.set("n", "<leader>fr", fzf.resume)
vim.keymap.set("n", "<leader>fs", fzf.spell_suggest)
vim.keymap.set("n", "<leader>ft", fzf.builtin)

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
