local plugin_path = vim.fn.stdpath("data") .. "/local/plugins/"
vim.opt.runtimepath:prepend(plugin_path)

local plugins = {
    "ibhagwan/fzf-lua",
    "nvim-treesitter/nvim-treesitter",
}

for _, plugin in ipairs(plugins) do
    local install_path = plugin_path .. plugin
    vim.opt.runtimepath:prepend(install_path)
    if vim.uv.fs_stat(install_path) == nil then
        print("Installing plugin: " .. plugin)
        vim.fn.system {
            "git",
            "clone",
            "--depth=1",
            "--filter=blob:none",
            "https://github.com/" .. plugin .. ".git",
            install_path,
        }
    end
end

vim.api.nvim_create_user_command("UpdatePlugins", function()
    local new_commits = {}
    for _, plugin in ipairs(plugins) do
        print("Updating plugin: " .. plugin)
        local install_path = plugin_path .. plugin
        local pull = vim.fn.system("git -C " .. install_path .. " pull")
        if not pull:find("up to date") then
            table.insert(new_commits, plugin .. "\n" .. vim.fn.system {
                "git",
                "-C",
                install_path,
                "log",
                "HEAD@{1}..HEAD",
                "--pretty=reference",
            })
        end
    end
    if #new_commits > 0 then
        if vim.fn.bufname("%") ~= "" then
            vim.cmd("new")
        end
        vim.bo.filetype = "gitrebase"
        vim.api.nvim_buf_set_lines(
            vim.api.nvim_get_current_buf(),
            0,
            -1,
            false,
            vim.split(table.concat(new_commits, "\n"), "\n")
        )
    end
end, { nargs = 0 })

require("fzf-lua").setup {
    fzf_opts = {
        ["--layout"] = "default",
    },
    winopts = {
        border = { "", "", "", "│", "", "", "", "" },
        fullscreen = true,
        preview = {
            horizontal = "right:50%",
            scrollbar = false,
        },
    },
    defaults = {
        git_icons = false,
        file_icons = false,
    },
    lsp = {
        symbols = {
            symbol_style = 3,
        },
    },
}

require("nvim-treesitter.configs").setup {
    auto_install = false,
    ensure_installed = {
        "bash",
        "cmake",
        --"c", Included by default.
        "cpp",
        "dockerfile",
        "fish",
        "go",
        --"lua", Included by default.
        "make",
        --"markdown", Included by default.
        "perl",
        "python",
        "rust",
        "toml",
        --"vim", Included by default.
        --"vimdoc", Included by default.
        "yaml",
        "zig",
    },
    highlight = { enable = true },
}
