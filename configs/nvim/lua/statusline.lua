local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VLINE",
    [""] = "VBLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "VREPLACE",
    ["c"] = "COMMAND",
    ["t"] = "TERMINAL",
}

local lsp_status

vim.lsp.handlers["$/progress"] = function(_, progress, _)
    lsp_status = progress
    vim.api.nvim_command("redrawstatus!")
end

function StatusLine()
    local diagnostics = vim.diagnostic.count(0)
    local warnings = diagnostics[vim.diagnostic.severity.WARN] or 0
    local errors = diagnostics[vim.diagnostic.severity.ERROR] or 0
    local lsp_info = "W:" .. warnings .. " E:" .. errors
    if lsp_status and lsp_status.value.message and lsp_status.value.kind ~= "end" then
        lsp_info = "progress: " .. lsp_status.value.message
    end
    local current_mode = vim.api.nvim_get_mode().mode
    local pretty_mode = modes[current_mode] or current_mode
    return " " .. pretty_mode .. " | " .. lsp_info .. " |%m %<%.50f %= %Y | %l:%c "
end

vim.opt.statusline = "%!luaeval('StatusLine()')"
