local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.api.nvim_command("packadd packer.nvim")
end

vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")-- Auto compile when there are changes in plugins.lua

return require("packer").startup(function(use)
	use "wbthomason/packer.nvim"
	use "neovim/nvim-lspconfig"
	use "hrsh7th/nvim-compe"
	use "kevinhwang91/rnvimr"
	use "jiangmiao/auto-pairs"
	use "hoob3rt/lualine.nvim"
	use "akinsho/nvim-bufferline.lua"
	use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
	use "mhinz/vim-startify"
	use "airblade/vim-gitgutter"
	use "easymotion/vim-easymotion"
	use "tweekmonster/startuptime.vim"
	use "npxbr/glow.nvim"
	use "norcalli/nvim-colorizer.lua"
	use "nvim-treesitter/nvim-treesitter"
	use "simrat39/rust-tools.nvim"
end)
