local plugin_path = vim.fn.stdpath("data") .. "/local/plugins/"
vim.opt.runtimepath:prepend(plugin_path)
local plugin_list = {}

local function install_plugin(repo)
    local slash_pos = repo:find("/")
    local plugin_name = repo:sub(slash_pos + 1, -1)
    local install_path = plugin_path .. plugin_name
    if vim.uv.fs_stat(install_path) == nil then
        print("Installing plugin: " .. repo)
        vim.fn.system {
            "git",
            "clone",
            "--depth=1",
            "--filter=blob:none",
            "https://github.com/" .. repo .. ".git",
            install_path,
        }
    end
    vim.opt.runtimepath:prepend(install_path)
    table.insert(plugin_list, { path = install_path, name = plugin_name })
end

vim.api.nvim_create_user_command("UpdatePlugins", function()
    for _, plugin in ipairs(plugin_list) do
        print("Updating plugin: " .. plugin.name)
        local pull = vim.fn.system("git -C " .. plugin.path .. " pull")
        if not pull:find("up to date") then
            local new_commits = vim.fn.system(
                "git -C " .. plugin.path .. " log HEAD@{1}..HEAD --pretty=reference 2>/dev/null"
            )
            print(new_commits)
        end
    end
end, { nargs = 0 })

install_plugin("ellisonleao/gruvbox.nvim")
install_plugin("ibhagwan/fzf-lua")
install_plugin("hrsh7th/nvim-cmp")
install_plugin("hrsh7th/cmp-nvim-lsp")
install_plugin("hrsh7th/cmp-nvim-lua")
install_plugin("hrsh7th/cmp-buffer")
install_plugin("hrsh7th/cmp-path")
install_plugin("hrsh7th/cmp-nvim-lsp-signature-help")
install_plugin("neovim/nvim-lspconfig")
install_plugin("nvim-treesitter/nvim-treesitter")
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
        {
            name = "nvim_lsp",
            entry_filter = function(entry)
                return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Snippet
            end,
        },
        { name = "nvim_lua" },
        { name = "buffer" },
        { name = "path" },
        { name = "nvim_lsp_signature_help" },
    },
}
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
require("fzf-lua").setup {
    fzf_opts = {
        ["--layout"] = "default",
    },
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
        -- "latex", requires node to install
        "lua",
        "make",
        "markdown",
        "python",
        "regex",
        "rust",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
    },
    highlight = { enable = true },
}
