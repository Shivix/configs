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

function StatusLine()
    local current_mode = vim.api.nvim_get_mode().mode
    local pretty_mode = modes[current_mode] or current_mode
    local warnings = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    return " "
        .. pretty_mode
        .. " | W:"
        .. #warnings
        .. " E:"
        .. #errors
        .. " |%m %.40F %= %Y | %l:%c "
end

vim.opt.statusline = "%!luaeval('StatusLine()')"
