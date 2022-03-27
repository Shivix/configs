local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.api.nvim_command("packadd packer.nvim")
end

-- Auto compile when there are changes in plugins.lua
vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")

local custom_gruvbox = require("lualine.themes.gruvbox")
custom_gruvbox.normal.a.bg = "#CC8400"
custom_gruvbox.insert.c.bg = custom_gruvbox.normal.c.bg

return require("packer").startup(function(use)
    use {"wbthomason/packer.nvim"}
    use {"neovim/nvim-lspconfig"}
    use {"nvim-lua/lsp_extensions.nvim"}
    use {"nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup{
                highlight = {enable = true},
                refactor = {
                    highlight_definitions = {enable = true},
                    smart_rename = {
                        enable = true, keymaps = {smart_rename = "<leader>r"}
                    }
                }
            }
        end
    }
    use {"nvim-treesitter/nvim-treesitter-refactor"}
    use {"hrsh7th/nvim-cmp",
        requires = {{"hrsh7th/cmp-nvim-lsp"},
                   {"hrsh7th/cmp-nvim-lua"},
                   {"hrsh7th/cmp-buffer"},
                   {"hrsh7th/cmp-path"}},
        config = function()
            local cmp = require("cmp")
            cmp.setup{
                preselect = cmp.PreselectMode.None,
                mapping = {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(4),
                    ['<Down>'] = cmp.mapping.select_next_item(),
                    ['<Up>'] = cmp.mapping.select_prev_item(),
                    ['<CR>'] = cmp.config.disable,
                },
                sources = {
                    {name = "nvim_lsp"},
                    {name = "nvim_lua"},
                    {name = "buffer"},
                    {name = "path"},
                },
            }
        end,
    }
    use {"windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup{}
        end
    }
    use {"hoob3rt/lualine.nvim",
        config = function()
            require("lualine").setup{
                options = {
                    icons_enabled = false,
                    theme = custom_gruvbox,
                },
                sections = {
                    lualine_a = {"mode"},
                    lualine_b = {"branch", "diff", {"diagnostics", sources={"nvim_diagnostic"}}},
                    lualine_c = {},
                    lualine_x = {"fileformat", "filetype"},
                    lualine_y = {"progress"},
                    lualine_z = {"location"}
                },
            }
        end
    }
    use {"akinsho/bufferline.nvim",
        config = function()
            require("bufferline").setup{
                options = {
                    show_buffer_close_icons = false,
                    left_trunc_marker = '<',
                    right_trunc_marker = '>',
                }
            }
        end
    }
    use {"nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        module = "telescope",
        requires = {{"nvim-lua/popup.nvim"},
                   {"nvim-telescope/telescope-file-browser.nvim"}},
        config = function()
            require("telescope").setup{
                defaults = { layout_strategy = "vertical" }
            }
            require("telescope").load_extension("file_browser")
        end
    }
    use {"Shivix/gruvbox.nvim"}
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
                startify.button('n', "New file" , ":ene <BAR> startinsert <CR>"),
                startify.button('f', "Find file" , "<cmd>lua require('telescope.builtin').find_files{path_display={shorten=5}}<CR>"),
                startify.button('b', "Browse files" , "<cmd>lua require('telescope').extensions.file_browser.file_browser{cwd='~/'}<CR>"),
                startify.button('s', "Settings" , "<cmd>lua require('telescope.builtin').find_files{cwd='~/.config/nvim'}<CR>"),
                startify.button('c', "Configs" , "<cmd>lua require('telescope').extensions.file_browser.file_browser{cwd='~/.config'}<CR>"),
                startify.button('t', "Terminal" , ":term <CR>"),
                startify.button('u', "Update Plugins" , ":PackerUpdate <CR>"),
            }
            startify.section.mru.val = {}
            startify.section.mru_cwd.val = {
                {type = "padding", val = 1},
                {type = "text", val = "Recent Files" , opts = { hl = "SpecialComment", shrink_margin = false}},
                {type = "padding", val = 1},
                {type = "group", val = function() return { startify.mru(0, vim.fn.getcwd(), 16) } end, opts = {shrink_margin = false}},
            }
            startify.section.bottom_buttons.val = {}
            startify.section.footer.type = "text"
            local fortune = require("alpha.fortune")(80)
            startify.section.footer.val = fortune
            require("alpha").setup(startify.opts)
        end
    }
    use {"nvim-lua/plenary.nvim", module = "plenary"}
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
        end
    }
    use {"lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup{} end
    }
    use	{"phaazon/hop.nvim",
        cmd = "HopChar2",
        config = function() require("hop").setup{} end
    }
    use {"norcalli/nvim-colorizer.lua",
        cmd = "ColorizerToggle",
        config = function() require("colorizer").setup{} end
    }
    use {"ahmedkhalf/project.nvim",
        config = function() require("project_nvim").setup{} end
    }
    use {"AckslD/nvim-neoclip.lua",
        config = function()
            require("neoclip").setup{}
        end
    }
    use {"nathom/filetype.nvim"}
    use {"lewis6991/impatient.nvim"}
end)
