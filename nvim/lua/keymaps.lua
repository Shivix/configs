local key_sets = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
}

for open, close in pairs(key_sets) do
    -- Ctrl-G U will prevent <Left> from breaking with . repeat
    vim.keymap.set("i", open, open .. close .. "<C-g>U<Left>", {})
    vim.keymap.set("i", close, function()
        local pos = vim.api.nvim_win_get_cursor(0)[2] + 1
        local next_char = vim.api.nvim_get_current_line():sub(pos, pos)

        if next_char == close then
            return "<C-g>U<Right>"
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

vim.keymap.set("n", "<C-b>", "<C-^>", {})

vim.keymap.set("i", "jk", "<Esc>", {})
vim.keymap.set("i", "kj", "<Esc>", {})

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
vim.keymap.set("n", "gr", function()
    require("fzf-lua").lsp_references()
end, {})
vim.keymap.set("n", "gh", ":ClangdSwitchSourceHeader<CR>", {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "<C-n>", function()
    vim.diagnostic.jump { count = 1 }
end, {})
vim.keymap.set("n", "<C-p>", function()
    vim.diagnostic.jump { count = -1 }
end, {})
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})

vim.keymap.set("n", "<leader>ff", function()
    require("fzf-lua").files()
end, {})
vim.keymap.set("n", "<leader>fg", function()
    require("fzf-lua").live_grep()
end, {})
vim.keymap.set("n", "<leader>fh", function()
    require("fzf-lua").help_tags()
end, {})
vim.keymap.set("n", "<leader>fj", function()
    require("fzf-lua").jumps()
end, {})
vim.keymap.set("n", "<leader>fq", function()
    require("fzf-lua").quickfix()
end, {})
vim.keymap.set("n", "<leader>fr", function()
    require("fzf-lua").live_grep_resume()
end, {})
vim.keymap.set("n", "<leader>fe", function()
    require("fzf-lua").lsp_workspace_diagnostics()
end, {})
vim.keymap.set("n", "<leader>fs", function()
    require("fzf-lua").lsp_live_workspace_symbols()
end, {})
