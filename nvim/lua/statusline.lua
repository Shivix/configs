local function macro_recording()
    local recording_register = vim.fn.reg_recording()
    if recording_register == "" then
        return nil
    else
        return "Recording @" .. recording_register
    end
end

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

vim.lsp.handlers['$/progress'] = (function(_, progress, _)
    StatusLineArgs = progress
    vim.api.nvim_command('redrawstatus!')
end)

function StatusLine()
    local warnings = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local lsp_info = " | W:" .. #warnings .. " E:" .. #errors
    if StatusLineArgs then
        local value = StatusLineArgs.value
        if value.message and value.kind ~= "end" then
            lsp_info = " | progress: " .. value.message
        end
    end
    local current_mode = vim.api.nvim_get_mode().mode
    local pretty_mode = modes[current_mode] or current_mode
    local macro = macro_recording()
    if macro ~= nil then
        return " " .. pretty_mode .. " | " .. macro
    end
    return " "
        .. pretty_mode
        .. lsp_info
        .. " |%m %.40F %= %Y | %l:%c "
end

vim.opt.statusline = "%!luaeval('StatusLine()')"
