local language_servers = {
    {
        name = "clangd",
        cmd = { "clangd" },
        filetype = { "cpp", "c" },
        root_dir = { "Makefile", "CMakeLists.txt", ".clang-format", ".clang-tidy", ".git" },
    },
    {
        name = "lua_ls",
        cmd = { "lua-language-server" },
        filetype = { "lua" },
        root_dir = { "Makefile", "stylua.toml", ".git" },
        settings = {
            Lua = {
                runtime = {
                    version = "Lua 5.4",
                },
                diagnostics = { globals = { "vim" } },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        "${3rd}/luv/library",
                    },
                },
                telemetry = { enable = false },
            },
        },
    },
    {
        name = "gopls",
        cmd = { "gopls" },
        filetype = { "go" },
        root_dir = { "go.mod", "go.sum", ".git" },
    },
    {
        name = "pyright",
        cmd = { "pyright" },
        filetype = { "python" },
        root_dir = { "setup.py", "pyproject.toml", ".git" },
    },
    {
        name = "rust-analyzer",
        cmd = { "rust-analyzer" },
        filetype = { "rust" },
        root_dir = { "cargo.toml", "cargo.lock", ".git" },
    },
    {
        name = "zls",
        cmd = { "zls" },
        filetype = { "zig" },
        root_dir = { "build.zig", "build.zig.zon", ".git" },
    },
}

local augroup = vim.api.nvim_create_augroup("LspStart", { clear = true })
for _, ls in pairs(language_servers) do
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = ls.filetype,
        callback = function(ev)
            vim.lsp.start({
                name = ls.name,
                cmd = ls.cmd,
                root_dir = vim.fs.root(ev.buf, ls.root_dir),
                capabilities = ls.capabilities,
                settings = ls.settings,
            }, { bufnr = ev.buf })
        end,
    })
end

function ClangSwitchHeader()
    local bufnr = vim.api.nvim_get_current_buf()
    -- using { method = testDocument/switchSourceHeader } seems to return all clients.
    local client = vim.lsp.get_clients({ name = "clangd" })[1]
    if client == nil then
        print("Clangd not attached")
        return
    end
    client.request(
        "textDocument/switchSourceHeader",
        { uri = vim.uri_from_bufnr(bufnr) },
        function(err, result)
            if err then
                error(err.message)
            end
            if not result then
                print("Corresponding file cannot be determined")
                return
            end
            vim.api.nvim_command("edit " .. vim.uri_to_fname(result))
        end,
        bufnr
    )
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client.supports_method("textDocument/semanticTokensProvider") then
            --client.server_capabilities.semanticTokensProvider = nil
        end
    end,
})
