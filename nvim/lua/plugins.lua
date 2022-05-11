local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.api.nvim_command("packadd packer.nvim")
end

-- Auto compile when there are changes in plugins.lua
vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")

return require("packer").startup(function(use)
    use { "wbthomason/packer.nvim" }
    use { "neovim/nvim-lspconfig" }
    use {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup {
                highlight = { enable = true },
                refactor = {
                    highlight_definitions = { enable = true },
                    smart_rename = {
                        enable = true,
                        keymaps = { smart_rename = "<leader>r" },
                    },
                },
            }
        end,
    }
    use { "nvim-treesitter/nvim-treesitter-refactor" }
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup {
                preselect = cmp.PreselectMode.None,
                mapping = {
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(4),
                    ["<Down>"] = cmp.mapping.select_next_item(),
                    ["<Up>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.config.disable,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "buffer" },
                    { name = "path" },
                },
            }
        end,
    }
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {}
        end,
    }
    use {
        "hoob3rt/lualine.nvim",
        config = function()
            local custom_gruvbox = require("lualine.themes.gruvbox")
            custom_gruvbox.normal.a.bg = "#CC8400"
            custom_gruvbox.insert.c.bg = custom_gruvbox.normal.c.bg
            require("lualine").setup {
                options = {
                    icons_enabled = false,
                    theme = custom_gruvbox,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        "branch",
                        "diff",
                        {
                            "diagnostics",
                            sources = {
                                "nvim_diagnostic",
                            },
                        },
                    },
                    lualine_c = {},
                    lualine_x = { "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            }
        end,
    }
    use {
        "akinsho/bufferline.nvim",
        config = function()
            require("bufferline").setup {
                options = {
                    show_buffer_close_icons = false,
                    left_trunc_marker = "<",
                    right_trunc_marker = ">",
                },
            }
        end,
    }
    use { "Shivix/gruvbox.nvim" }
    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {}
        end,
    }
    use {
        "phaazon/hop.nvim",
        cmd = "HopChar2",
        config = function()
            require("hop").setup {}
        end,
    }
    use {
        "norcalli/nvim-colorizer.lua",
        cmd = "ColorizerToggle",
        config = function()
            require("colorizer").setup {}
        end,
    }
    use { "nathom/filetype.nvim" }
    use { "lewis6991/impatient.nvim" }
end)
