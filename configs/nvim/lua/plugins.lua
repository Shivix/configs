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
    local update_log = {}
    for _, plugin in ipairs(plugins) do
        print("Updating plugin: " .. plugin)
        local install_path = plugin_path .. plugin
        local pull = vim.fn.system("git -C " .. install_path .. " pull")
        if vim.v.shell_error ~= 0 then
            print("Could not git pull plugin, please manually fix: ", install_path)
            table.insert(update_log, plugin .. "\n" .. pull)
        end
        if not pull:find("up to date") then
            table.insert(update_log, plugin .. "\n" .. vim.fn.system {
                "git",
                "-C",
                install_path,
                "log",
                "HEAD@{1}..HEAD",
                "--pretty=reference",
            })
        else
            table.insert(update_log, plugin .. "\nUp to date")
        end
    end
    if #update_log > 0 then
        if vim.fn.bufname("%") ~= "" then
            vim.cmd("new")
        end
        vim.bo.filetype = "gitrebase"
        vim.api.nvim_buf_set_lines(
            vim.api.nvim_get_current_buf(),
            0,
            -1,
            false,
            vim.split(table.concat(update_log, "\n"), "\n")
        )
    end
end, { nargs = 0 })

require("fzf-lua").setup {
    fzf_opts = {
        ["--layout"] = "default",
    },
    manpages = {
        previewer = "man_native",
    },
    winopts = {
        border = "none",
        fullscreen = true,
        treesitter = false,
        preview = {
            default = "bat",
            border = "border-left",
        },
    },
    defaults = {
        git_icons = false,
        file_icons = false,
    },
    previewers = {
        bat = {
            -- Avoid default --style=number arg being added
            args = "--color=always",
        },
    },
    lsp = {
        symbols = {
            -- Hide icons in lsp symbol pickers
            symbol_style = 3,
        },
    },
}

local ensure_installed = {
    "bash",
    "cmake",
    "c",
    "cpp",
    "dockerfile",
    "fish",
    "go",
    "json",
    "xml",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "perl",
    "python",
    "rust",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
    "zig",
}
if vim.fn.executable("tree-sitter") == 0 then
    vim.notify("tree-sitter CLI is required to install parsers", vim.log.levels.ERROR)
    return
end
local treesitter = require("nvim-treesitter")
treesitter.install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if
            vim.list_contains(
                treesitter.get_installed(),
                vim.treesitter.language.get_lang(args.match)
            )
        then
            vim.schedule(function()
                vim.treesitter.start(args.buf)
            end)
        end
    end,
})
