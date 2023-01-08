local key_sets = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
}

for open, close in pairs(key_sets) do
    vim.keymap.set("i", open, open .. close .. "<Left>", {})
    vim.keymap.set("i", close, function()
        local pos = vim.api.nvim_win_get_cursor(0)[2] + 1
        local next_char = vim.api.nvim_get_current_line():sub(pos, pos)

        if next_char == close then
            return "<Right>"
        end
        return close
    end, { expr = true })
end

local function if_pair_else(lhs, rhs)
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local pair = vim.api.nvim_get_current_line():sub(pos, pos + 1)

    for open, close in pairs(key_sets) do
        if pair == open .. close then
            return lhs
        end
    end
    return rhs
end

vim.keymap.set("i", "<BS>", function()
    return if_pair_else("<BS><Del>", "<BS>")
end, { expr = true })
vim.keymap.set("i", "<CR>", function()
    return if_pair_else("<CR><ESC>==O", "<CR>")
end, { expr = true })

vim.api.nvim_create_user_command("Fd", "args `fd <args>`", { nargs = 1 })
vim.api.nvim_create_user_command("QFRun", "cexpr execute('!<args>')", { nargs = 1 })
vim.api.nvim_create_user_command("Todo", "vimgrep /TODO/g %", { nargs = 0 })

vim.keymap.set("n", "<C-b>", "<C-^>", {})

vim.keymap.set("i", "jk", "<Esc>", {})

-- stay in visual when tabbing
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("v", ">", ">gv", {})

vim.keymap.set("n", "<C-h>", "<C-w>h", {})
vim.keymap.set("n", "<C-j>", "<C-w>j", {})
vim.keymap.set("n", "<C-k>", "<C-w>k", {})
vim.keymap.set("n", "<C-l>", "<C-w>l", {})

-- make terminal mode mappings close to insert
vim.keymap.set("t", "jk", "<C-\\><C-n>", {})

vim.keymap.set("n", "<leader>s", ":set spell!<CR>", {})

vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gr", require("fzf-lua").lsp_references, {})
vim.keymap.set("n", "gh", ":ClangdSwitchSourceHeader<CR>", {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "<C-n>", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "<C-p>", vim.diagnostic.goto_next, {})
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>ql", ":copen 20<CR>", {})

local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>ff", fzf.files, {})
vim.keymap.set("n", "<leader>fg", fzf.live_grep, {})
vim.keymap.set("n", "<leader>fh", fzf.help_tags, {})
vim.keymap.set("n", "<leader>fj", fzf.jumps, {})
vim.keymap.set("n", "<leader>fq", fzf.quickfix, {})
vim.keymap.set("n", "<leader>fr", fzf.live_grep_resume, {})

vim.keymap.set("n", "<F5>", ":Over<CR>", {})
vim.keymap.set("n", "<F6>", ":Step<CR>", {})
