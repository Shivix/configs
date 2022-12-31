local options = { noremap = true, silent = true }
local expr = { expr = true, silent = true }
local keymap = vim.api.nvim_set_keymap

local key_sets = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
}

for open, close in pairs(key_sets) do
    keymap("i", open, open .. close .. "<Left>", options)
    vim.keymap.set("i", close, function()
        local pos = vim.api.nvim_win_get_cursor(0)[2] + 1
        local next_char = vim.api.nvim_get_current_line():sub(pos, pos)

        if next_char == close then
            return "<Right>"
        end
        return close
    end, expr)
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
end, expr)
vim.keymap.set("i", "<CR>", function()
    return if_pair_else("<CR><ESC>==O", "<CR>")
end, expr)

vim.api.nvim_create_user_command("Fd", "args `fd <args>`", { nargs = 1 })
vim.api.nvim_create_user_command("QFRun", "cexpr execute('!<args>')", { nargs = 1 })
vim.api.nvim_create_user_command("Todo", "vimgrep /TODO/g %", { nargs = 0 })

keymap("n", "<C-b>", "<C-^>", options)

keymap("i", "jk", "<Esc>", { noremap = true })

-- stay in visual when tabbing
keymap("v", "<", "<gv", { noremap = true })
keymap("v", ">", ">gv", { noremap = true })

keymap("n", "<C-h>", "<C-w>h", { noremap = true })
keymap("n", "<C-j>", "<C-w>j", { noremap = true })
keymap("n", "<C-k>", "<C-w>k", { noremap = true })
keymap("n", "<C-l>", "<C-w>l", { noremap = true })

-- make terminal mode mappings close to insert
keymap("t", "jk", "<C-\\><C-n>", {})

keymap("n", "<leader>s", ":set spell!<CR>", options)

keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", options)
keymap("n", "gr", ":lua require('fzf-lua').lsp_references()<CR>", options)
keymap("n", "gh", ":ClangdSwitchSourceHeader<CR>", options)
keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", options)
keymap("n", "<leader>k", ":lua vim.lsp.buf.signature_help()<CR>", options)
keymap("n", "<C-n>", ":lua vim.diagnostic.goto_prev()<CR>", options)
keymap("n", "<C-p>", ":lua vim.diagnostic.goto_next()<CR>", options)
keymap("n", "<leader>e", ":lua vim.diagnostic.open_float()<CR>", options)
keymap("n", "<leader>qf", ":lua vim.lsp.buf.code_action()<CR>", options)
keymap("n", "<leader>o", ":lua vim.api.nvim_command('copen 20')<CR>", options)
keymap("n", "<leader>r", ":lua vim.lsp.buf.rename()<CR>", options)

keymap("n", "<leader>ff", ":lua require('fzf-lua').files()<CR>", options)
keymap("n", "<leader>fg", ":lua require('fzf-lua').live_grep()<CR>", options)
keymap("n", "<leader>fh", ":lua require('fzf-lua').help_tags()<CR>", options)
keymap("n", "<leader>fj", ":lua require('fzf-lua').jumps()<CR>", options)
keymap("n", "<leader>fq", ":lua require('fzf-lua').quickfix()<CR>", options)
keymap("n", "<leader>fr", ":lua require('fzf-lua').live_grep_resume()<CR>", options)

keymap("n", "<F5>", ":Over<CR>", options)
keymap("n", "<F6>", ":Step<CR>", options)
