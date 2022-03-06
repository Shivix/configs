local keymap = vim.api.nvim_set_keymap
local options = {noremap=true, silent=true}

keymap('n', "<M-l>", ":bnext<CR>", options)
keymap('n', "<M-h>", ":bprevious<CR>", options)
keymap('n', "<C-w>", ":Bd<CR>", options)

-- escape be hard to press yo
keymap('i', "jk", "<Esc>", {noremap = true})

-- Better tabbing
keymap('v', "<", "<gv", {noremap = true})
keymap('v', ">", ">gv", {noremap = true})

-- switch between divided windows
keymap('n', "<C-h>", "<C-w>h", {noremap = true})
keymap('n', "<C-j>", "<C-w>j", {noremap = true})
keymap('n', "<C-k>", "<C-w>k", {noremap = true})
keymap('n', "<C-l>", "<C-w>l", {noremap = true})


-- enter normal mode in terminal mode
keymap('t', "jk", "<C-\\><C-n>", {})
keymap('t', "<C-h>", "<C-\\><C-n><C-w>h", {noremap = true})
keymap('t', "<C-j>", "<C-\\><C-n><C-w>j", {noremap = true})
keymap('t', "<C-k>", "<C-\\><C-n><C-w>k", {noremap = true})
keymap('t', "<C-l>", "<C-\\><C-n><C-w>l", {noremap = true})

keymap('n', "s", ":HopChar2<CR>", {})

keymap('n', "<leader>ff", ":lua require('telescope.builtin').find_files({path_display={shorten = 5}})<CR>", {})
keymap('n', "<leader>fg", ":lua require('telescope.builtin').live_grep()<CR>", {})
keymap('n', "<leader>fd", ":lua require('telescope.builtin').lsp_definitions()<CR>", {})
keymap('n', "<leader>fr", ":lua require('telescope.builtin').lsp_references()<CR>", {})
keymap('n', "<leader>fh", ":lua require('telescope.builtin').help_tags()<CR>", {})
keymap('n', "<leader>fb", ":lua require('telescope').extensions.file_browser.file_browser()<CR>", {})
keymap('n', "<leader>fc", ":lua require('telescope').extensions.neoclip.default()<CR>", {})

keymap('n', "gd", ":lua vim.lsp.buf.definition()<CR>", options)
keymap('n', "gD", ":lua vim.lsp.buf.declaration()<CR>", options)
keymap('n', "gr", ":lua vim.lsp.buf.references()<CR>", options)
keymap('n', "gi", ":lua vim.lsp.buf.implementation()<CR>", options)
keymap('n', "K", ":lua vim.lsp.buf.hover()<CR>", options)
keymap('n', "<leader>k", ":lua vim.lsp.buf.signature_help()<CR>", options)
keymap('n', "<C-n>", ":lua vim.diagnostic.goto_prev()<CR>", options)
keymap('n', "<C-p>", ":lua vim.diagnostic.goto_next()<CR>", options)
keymap('n', "<leader>qf", ":lua vim.lsp.buf.code_action()<CR>", options)
keymap('n', "<leader>e", ":lua vim.diagnostic.open_float()<CR>", options)
keymap('n', "<leader>i", ":lua require('lsp_extensions').inlay_hints{ prefix = '=> ', highlight = 'Comment', enabled = {'TypeHint', 'ChainingHint'}}<CR>", options)

keymap('n', "<leader>s", ":set spell!<CR>", options)

