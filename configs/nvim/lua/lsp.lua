local language_servers = {
    clangd = {
        filetype = { "cpp", "c" },
        root_markers = { ".clangd", ".clang-format", ".clang-tidy", "compile_commands.json" },
    },
    gopls = {
        filetype = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.mod", "go.sum" },
    },
    ["lua-language-server"] = {
        filetype = { "lua" },
        root_markers = { "Makefile", "stylua.toml" },
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
    pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetype = { "python" },
        root_markers = { "pyproject.toml", "requirements.txt", "setup.py" },
    },
    ["rust-analyzer"] = {
        filetype = { "rust" },
        root_markers = { "Cargo.lock", "Cargo.toml" },
    },
    zls = {
        filetype = { "zig", "zir" },
        root_markers = { "build.zig", "build.zig.zon" },
    },
}

vim.lsp.config("*", {
    root_markers = { ".git" },
})

vim.diagnostic.config {
    virtual_text = true,
}

for name, ls in pairs(language_servers) do
    vim.lsp.config[name] = {
        cmd = ls.cmd or { name },
        root_markers = ls.root_markers,
        capabilities = ls.capabilities,
        settings = ls.settings,
        filetypes = ls.filetype,
    }
    vim.lsp.enable(name)
end

vim.api.nvim_create_user_command("ActiveLS", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients { bufnr = bufnr }
    print(vim.inspect(clients))
end, { nargs = 0 })

function ClangSwitchHeader()
    local client = vim.lsp.get_clients({ name = "clangd" })[1]
    if client == nil then
        print("Clangd not attached")
        return
    end
    client:request(
        "textDocument/switchSourceHeader",
        vim.lsp.util.make_text_document_params(),
        function(err, result)
            if err then
                error(tostring(err))
            end
            if not result then
                print("Cannot find corresponding file")
                return
            end
            vim.api.nvim_command("edit " .. vim.uri_to_fname(result))
        end
    )
end
