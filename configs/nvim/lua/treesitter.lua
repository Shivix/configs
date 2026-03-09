local parsers = {
    "bash",
    "cpp",
    "go",
    "python",
    "rust",
    "yaml",
    "zig",
}

if vim.fn.executable("tree-sitter") == 0 then
    vim.notify("tree-sitter CLI is required to install parsers", vim.log.levels.ERROR)
    return
end

local parser_path = vim.fn.stdpath("data") .. "/parsers/"

local function install_parsers(update)
    for _, lang in ipairs(parsers) do
        local parser = "tree-sitter-" .. lang
        -- Installed as .so files, so fine to install for lua 5.4.
        local install_path = parser_path .. "lib/luarocks/rocks-5.4/" .. parser

        if vim.uv.fs_stat(install_path) == nil or update then
            vim.notify("Installing parser: " .. parser)
            vim.fn.system {
                "luarocks",
                "--tree=" .. parser_path,
                "install",
                parser,
            }
        end
        -- Find the version name directory
        local entries = vim.fs.dir(install_path)
        local full_path
        for name, type in entries do
            if type == "directory" then
                full_path = install_path .. "/" .. name
                break
            end
        end
        if full_path == nil then
            vim.notify("parser version directory not found for: " .. parser, vim.log.levels.ERROR)
            return
        end
        vim.opt.runtimepath:prepend(full_path)
    end
end

install_parsers(false)

vim.api.nvim_create_user_command("UpdateParsers", function()
    install_parsers(true)
end, { nargs = 0 })

vim.api.nvim_create_user_command("RemoveParser", function(opts)
    local parser = "tree-sitter-" .. opts.args
    local output = vim.fn.system {
        "luarocks",
        "--tree=" .. parser_path,
        "remove",
        parser,
    }
    vim.notify(output)
end, { nargs = 1 })

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        vim.schedule(function()
            pcall(vim.treesitter.start, args.buf)
        end)
    end,
})
