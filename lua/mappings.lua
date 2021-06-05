vim.api.nvim_set_keymap('i', "<C-j>", "<C-n>", {noremap = true})
vim.api.nvim_set_keymap('i', "<C-k>", "<C-p>", {noremap = true})

-- switch buffers
vim.api.nvim_set_keymap('n', "<M-l>", ":bnext<CR>", {noremap = true})
vim.api.nvim_set_keymap('n', "<M-h>", ":bprevious<CR>", {noremap = true})

-- escape be hard to press yo
vim.api.nvim_set_keymap('i', "jk", "<Esc>", {noremap = true})

-- Better tabbing
vim.api.nvim_set_keymap('v', "<", "<gv", {noremap = true})
vim.api.nvim_set_keymap('v', ">", ">gv", {noremap = true})

-- switch between divided windows
vim.api.nvim_set_keymap('n', "<C-h>", "<C-w>h", {noremap = true})
vim.api.nvim_set_keymap('n', "<C-j>", "<C-w>j", {noremap = true})
vim.api.nvim_set_keymap('n', "<C-k>", "<C-w>k", {noremap = true})
vim.api.nvim_set_keymap('n', "<C-l>", "<C-w>l", {noremap = true})

-- open ranger
vim.api.nvim_set_keymap('n', "<leader>t", ":RnvimrToggle<CR>", {})

vim.api.nvim_set_keymap('n', "s", "<Plug>(easymotion-s2)", {})

local options = {noremap=true, silent=true}
vim.api.nvim_set_keymap('n', "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", options)
vim.api.nvim_set_keymap('n', "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", options)
vim.api.nvim_set_keymap('n', "gr", "<cmd>lua vim.lsp.buf.references()<CR>", options)
vim.api.nvim_set_keymap('n', "K", "<cmd>lua vim.lsp.buf.hover()<CR>", options)
vim.api.nvim_set_keymap('n', "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", options)
vim.api.nvim_set_keymap('n', "<C-n>", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", options)
vim.api.nvim_set_keymap('n', "<C-p>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", options)
vim.api.nvim_set_keymap('n', "<space>r", "<cmd>lua vim.lsp.buf.rename()<CR>", options)
vim.api.nvim_set_keymap('n', "<space>f", "<cmd>lua vim.lsp.buf.code_action()<CR>", options)

vim.api.nvim_set_keymap('n', "<leader>p", ":Glow<CR>", {})
