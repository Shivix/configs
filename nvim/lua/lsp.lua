local language_servers = {
    -- TODO: WIP
    ansiblels = {
        cmd = { "ansible-language-server", "--stdio" },
        -- Don't want this always running on every yaml, how do we know? Manually trigger? Always run but only on work laptop?
        filetype = { "yaml.ansible" },
        --root_markers = {},
        settings = {
            ansible = {
                ansible = {
                    path = "ansible",
                },
                executionEnvironment = {
                    enabled = false,
                },
                validation = {
                    enabled = true,
                    lint = {
                        enabled = true,
                        path = "ansible-lint",
                    },
                },
            },
        },
    },
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
    -- using { method = textDocument/switchSourceHeader } seems to return all clients.
    local clients = vim.lsp.get_clients { bufnr = bufnr }
    print(vim.inspect(clients))
end, { nargs = 0 })

function ClangSwitchHeader()
    local bufnr = vim.api.nvim_get_current_buf()
    -- using { method = textDocument/switchSourceHeader } seems to return all clients.
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
                error(tostring(err))
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
