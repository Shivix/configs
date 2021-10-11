local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.api.nvim_command("packadd packer.nvim")
end

-- Auto compile when there are changes in plugins.lua
vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")

local custom_gruvbox = require("lualine.themes.gruvbox")
custom_gruvbox.normal.a.bg = "#CC8400"

return require("packer").startup(function(use)
	use {"wbthomason/packer.nvim"}
	use {"neovim/nvim-lspconfig"}
	use {"hrsh7th/nvim-cmp"}
	use {"hrsh7th/cmp-nvim-lsp"}
	use {"hrsh7th/cmp-nvim-lua"}
	use {"hrsh7th/cmp-buffer"}
	use {"hrsh7th/cmp-path"}
	use {"jiangmiao/auto-pairs"}
	use {"hoob3rt/lualine.nvim",
        config = function() require("lualine").setup{
            options = {theme = custom_gruvbox}
        } end
    }
	use {"akinsho/bufferline.nvim",
        config = function() require("bufferline").setup{
            options = {
                show_buffer_close_icons = false,
                left_trunc_marker = '<',
                right_trunc_marker = '>',
            }
        } end
    }
	use {"Shivix/gruvbox.nvim",
        requires = {"rktjmp/lush.nvim"}
    }
    use {"goolord/alpha-nvim",
        config = function()
            local startify = require("alpha.themes.startify")
            startify.nvim_web_devicons.enabled = false
            startify.nvim_web_devicons.highlight = false
            startify.section.header.val = {
                [[        _   __         _    ___          ]],
				[[       / | / /__  ____| |  / (_)___ ___  ]],
				[[      /  |/ / _ \/ __ \ | / / / __ `__ \ ]],
				[[     / /|  /  __/ /_/ / |/ / / / / / / / ]],
				[[    /_/ |_/\___/\____/|___/_/_/ /_/ /_/  ]],
				[[   ------------------------------------- ]],
				[[    ]] ..
                #vim.tbl_keys(packer_plugins) .. " plugins | " .. os.date("%d-%m-%Y | %H:%M:%S")
            }
            startify.section.top_buttons.val = {
                startify.button( "e", "New file" , ":ene <BAR> startinsert <CR>"),
                startify.button( "f", "Find file" , "<cmd>lua require('telescope.builtin').find_files{path_display={shorten=5}}<CR>"),
                startify.button( "b", "Browse files" , "<cmd>lua require('telescope.builtin').file_browser{cwd='~/'}<CR>"),
                startify.button( "s", "Settings" , "<cmd>lua require('telescope.builtin').find_files{cwd='~/.config/nvim'}<CR>"),
                startify.button( "c", "Configs" , "<cmd>lua require('telescope.builtin').file_browser{cwd='~/.config'}<CR>"),
                startify.button( "t", "Terminal" , ":term <CR>"),
                startify.button( "u", "Update Plugins" , ":PackerUpdate <CR>"),
            }
            require("alpha").setup(startify.opts)
        end
    }
	use {"nvim-lua/plenary.nvim",
        module = "plenary"
    }
    use {"Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = function()
            require("crates").setup{
                text = {
                    loading    = "=> Loading",
                    version    = "=> %s",
                    prerelease = "=> %s",
                    yanked     = "=> %s",
                    nomatch    = "=> No match",
                    update     = "=> %s",
                    error      = "=> Error fetching crate",
                },
                highlight = {
                    loading    = "CratesNvimLoading",
                    version    = "CratesNvimVersion",
                    prerelease = "CratesNvimPreRelease",
                    yanked     = "CratesNvimYanked",
                    nomatch    = "CratesNvimNoMatch",
                    update     = "CratesNvimUpdate",
                    error      = "CratesNvimError",
                },
            }
        end,
    }
	use {"nvim-telescope/telescope.nvim",
        module = "telescope",
        requires = {"nvim-lua/popup.nvim"},
        config = function() require("telescope").setup{} end
    }
	use {"lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup{} end
    }
	use	{"phaazon/hop.nvim",
        config = function () require("hop").setup{} end
    }
	use {"norcalli/nvim-colorizer.lua",
        config = function() require("colorizer").setup{} end
    }
	use {"nvim-treesitter/nvim-treesitter",
        config = function() require("nvim-treesitter.configs").setup{
            highlight = {enable = true},
            refactor = {
                highlight_definitions = {enable = true},
                smart_rename = {enable = true, keymaps = {smart_rename = "<leader>r"}}
            }
        } end
    }
	use {"nvim-treesitter/nvim-treesitter-refactor"}
	use {"simrat39/rust-tools.nvim",
        ft = "rust",
        config = function() require("rust-tools").setup{} end
    }
    use {"ahmedkhalf/project.nvim",
        config = function() require("project_nvim").setup{} end
    }
end)

