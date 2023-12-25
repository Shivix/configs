local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    "neovim/nvim-lspconfig",
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup {
                auto_install = false,
                ensure_installed = {
                    "bash",
                    "cmake",
                    "cpp",
                    "dockerfile",
                    "fish",
                    "go",
                    "gomod",
                    "latex",
                    "lua",
                    "make",
                    "markdown",
                    "python",
                    "regex",
                    "rust",
                    "toml",
                    "vim",
                    "yaml",
                },
                highlight = { enable = true },
            }
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            require("gruvbox").setup {
                bold = false,
                italic = {
                    strings = false,
                    operators = false,
                    comments = false,
                },
                overrides = {
                    Identifier = { fg = "#efe2c1" },
                    Typedef = { fg = "#fabd2f" },
                    StatusLine = { fg = "#fabd2f", bg = "#32302f", reverse = false },
                    Function = { fg = "#8ec07c" },
                    Include = { fg = "#d3869b" },
                    PreProc = { fg = "#d3869b" },
                    Delimiter = { fg = "#fe8019" },
                },
                transparent_mode = true,
            }
            vim.api.nvim_exec2("colorscheme gruvbox", { output = true })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
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
                    { name = "nvim_lsp_signature_help" },
                },
            }
        end,
    },
    {
        "ibhagwan/fzf-lua",
        config = function()
            require("fzf-lua").setup {
                fzf_opts = { ["--layout"] = "default" },
                winopts = {
                    border = { "", "", "", "", "", "", "", "" },
                    fullscreen = true,
                    preview = {
                        default = "bat",
                        vertical = "up:60%",
                        scrollbar = false,
                    },
                },
                files = {
                    git_icons = false,
                    file_icons = false,
                },
                grep = {
                    git_icons = false,
                    file_icons = false,
                },
                keymap = {
                    fzf = {
                        ["ctrl-d"] = "preview-half-page-down",
                        ["ctrl-u"] = "preview-half-page-up",
                    },
                },
            }
        end,
    },
}, {
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
