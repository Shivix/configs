local keymap = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

function Qfix_toggle()
    Qfix_open = not Qfix_open
    if Qfix_open then
        vim.api.nvim_command("copen 20")
    else
        vim.api.nvim_command("cclose")
    end
end

vim.api.nvim_create_user_command("Fd", "args `fd <args>`", { nargs = 1 })
vim.api.nvim_create_user_command("Run", "cexpr execute('!<args>')", { nargs = 1 })
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
keymap("n", "<leader>o", "", { callback = Qfix_toggle })
keymap("n", "<leader>r", ":lua vim.lsp.buf.rename()<CR>", options)

keymap("n", "<leader>ff", ":lua require('fzf-lua').files()<CR>", options)
keymap("n", "<leader>fg", ":lua require('fzf-lua').live_grep()<CR>", options)
keymap("n", "<leader>fh", ":lua require('fzf-lua').help_tags()<CR>", options)
keymap("n", "<leader>fj", ":lua require('fzf-lua').jumps()<CR>", options)
keymap("n", "<leader>fq", ":lua require('fzf-lua').quickfix()<CR>", options)
