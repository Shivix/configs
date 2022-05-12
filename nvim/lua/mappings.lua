local keymap = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

keymap("n", "<C-b>", "<C-^>", options)

keymap("i", "jk", "<Esc>", { noremap = true })

keymap("n", "<leader>r", ":%s/<C-r><C-w>/<C-r><C-w>/gc<Left><Left><Left>", { noremap = true })

-- stay in visual when tabbing
keymap("v", "<", "<gv", { noremap = true })
keymap("v", ">", ">gv", { noremap = true })

keymap("n", "<C-h>", "<C-w>h", { noremap = true })
keymap("n", "<C-j>", "<C-w>j", { noremap = true })
keymap("n", "<C-k>", "<C-w>k", { noremap = true })
keymap("n", "<C-l>", "<C-w>l", { noremap = true })

-- make terminal mode mappings close to insert
keymap("t", "jk", "<C-\\><C-n>", {})
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { noremap = true })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { noremap = true })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { noremap = true })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { noremap = true })

keymap("n", "s", ":HopChar2<CR>", { noremap = true })

keymap("n", "<leader>s", ":set spell!<CR>", options)

keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", options)
keymap("n", "gD", ":lua vim.lsp.buf.declaration()<CR>", options)
keymap("n", "gr", ":lua vim.lsp.buf.references()<CR>", options)
keymap("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", options)
keymap("n", "gh", ":ClangdSwitchSourceHeader<CR>", options)
keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", options)
keymap("n", "<leader>k", ":lua vim.lsp.buf.signature_help()<CR>", options)
keymap("n", "<C-n>", ":lua vim.diagnostic.goto_prev()<CR>", options)
keymap("n", "<C-p>", ":lua vim.diagnostic.goto_next()<CR>", options)
keymap("n", "<leader>qf", ":lua vim.lsp.buf.code_action()<CR>", options)
keymap("n", "<leader>e", ":lua vim.diagnostic.open_float()<CR>", options)
