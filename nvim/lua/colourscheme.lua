-- Based on https://github.com/ellisonleao/gruvbox.nvim
vim.g.colors_name = "gruvbox"
vim.g.c_syntax_for_h = true

local colours = {
    bg0 = "#282828",
    bg1 = "#3c3836",
    bg2 = "#504945",
    bg3 = "#665c54",
    bg4 = "#7c6f64",
    fg1 = "#ebdbb2",
    fg4 = "#a89984",
    red = "#fb4934",
    aqua = "#8ec07c",
    blue = "#83a598",
    gray = "#928374",
    green = "#b8bb26",
    orange = "#fe8019",
    purple = "#d3869b",
    yellow = "#fabd2f",
    dark_green = "#4F5431",
    dark_red = "#722529",
}
local groups = {
    { "Boolean", { link = "Constant" } },
    { "Character", { link = "Constant" } },
    { "ColorColumn", { bg = colours.bg1 } },
    { "Comment", { fg = colours.gray } },
    { "Conditional", { fg = colours.red } },
    { "Constant", { fg = colours.purple } },
    { "CurSearch", { link = "IncSearch" } },
    { "CursorColumn", { link = "CursorLine" } },
    { "CursorLine", { bg = colours.bg1 } },
    { "CursorLineNr", { fg = colours.yellow } },
    { "Cursor", { reverse = true } },
    { "debugPC", { bg = colours.bg2 } },
    { "Define", { fg = colours.purple } },
    { "Delimiter", { fg = colours.orange } },
    { "DiagnosticError", { fg = colours.red } },
    { "DiagnosticFloatingError", { fg = colours.red } },
    { "DiagnosticFloatingHint", { fg = colours.aqua } },
    { "DiagnosticFloatingInfo", { fg = colours.blue } },
    { "DiagnosticFloatingWarn", { fg = colours.orange } },
    { "DiagnosticHint", { fg = colours.aqua } },
    { "DiagnosticInfo", { fg = colours.blue } },
    { "DiagnosticUnderlineError", { undercurl = true, sp = colours.red } },
    { "DiagnosticUnderlineHint", { undercurl = true, sp = colours.aqua } },
    { "DiagnosticUnderlineInfo", { undercurl = true, sp = colours.blue } },
    { "DiagnosticUnderlineWarn", { undercurl = true, sp = colours.yellow } },
    { "DiagnosticVirtualTextError", { fg = colours.red } },
    { "DiagnosticVirtualTextHint", { fg = colours.aqua } },
    { "DiagnosticVirtualTextInfo", { fg = colours.blue } },
    { "DiagnosticVirtualTextWarn", { fg = colours.yellow } },
    { "DiagnosticWarn", { fg = colours.yellow } },
    { "DiffAdd", { bg = colours.dark_green } },
    { "DiffChange", { bg = nil } },
    { "DiffDelete", { bg = colours.dark_red } },
    { "DiffText", { bg = colours.yellow, fg = colours.bg0 } },
    { "Directory", { fg = colours.blue } },
    { "EndOfBuffer", { link = "NonText" } },
    { "ErrorMsg", { fg = colours.bg0, bg = colours.red, bold = false } },
    { "Exception", { fg = colours.red } },
    { "FinderSeparator", { fg = colours.aqua } },
    { "Float", { link = "Constant" } },
    { "FoldColumn", { fg = colours.gray, bg = nil } },
    { "Folded", { fg = colours.gray, bg = colours.bg1, italic = false } },
    { "Function", { fg = colours.aqua } },
    { "Identifier", { fg = colours.fg1 } },
    { "Include", { fg = colours.purple } },
    { "IncSearch", { fg = colours.orange, bg = colours.bg0, reverse = true } },
    { "Keyword", { fg = colours.red } },
    { "Label", { link = "Keyword" } },
    { "LineNr", { fg = colours.bg4 } },
    { "LspCodeLens", { fg = colours.gray } },
    { "LspInlayHint", { link = "Comment" } },
    { "LspReferenceRead", { fg = colours.yellow } },
    { "LspReferenceText", { fg = colours.yellow } },
    { "LspReferenceWrite", { fg = colours.orange } },
    { "LspSignatureActiveParameter", { link = "Search" } },
    { "Macro", { fg = colours.purple } },
    { "MatchParen", { bg = colours.bg3 } },
    { "ModeMsg", { fg = colours.fg1 } },
    { "MoreMsg", { fg = colours.fg1 } },
    { "MsgArea", { fg = colours.fg1 } },
    { "netrwDir", { fg = colours.yellow } },
    { "netrwExe", { fg = colours.orange } },
    { "netrwSymLink", { fg = colours.purple } },
    { "netrwClassify", { fg = colours.yellow } },
    { "NonText", { fg = colours.bg2 } },
    { "Normal", { fg = colours.fg1 } },
    { "NormalFloat", { fg = colours.fg1, bg = colours.bg1 } },
    { "Number", { link = "Constant" } },
    { "Operator", { fg = colours.orange, italic = false } },
    { "Pmenu", { fg = colours.fg1, bg = colours.bg1 } },
    { "PmenuSbar", { bg = colours.bg1 } },
    { "PmenuSel", { fg = colours.yellow, bg = colours.bg1, reverse = true } },
    { "PreCondit", { fg = colours.purple } },
    { "PreProc", { fg = colours.purple } },
    { "Question", { fg = colours.orange } },
    { "QuickFixLine", { fg = colours.yellow } },
    { "Repeat", { link = "Keyword" } },
    { "Search", { fg = colours.yellow, bg = colours.bg0, reverse = true } },
    { "SignColumn", { bg = nil } },
    { "SpecialKey", { fg = colours.fg4 } },
    { "Special", { fg = colours.orange } },
    { "Statement", { fg = colours.red } },
    { "StatusLine", { fg = colours.yellow, bg = "#32302f", reverse = false } },
    { "StatusLineNC", { fg = colours.bg1, bg = colours.fg4, reverse = true } },
    { "StorageClass", { link = "Type" } },
    { "String", { fg = colours.green } },
    { "Structure", { link = "Type" } },
    { "Title", { fg = colours.green } },
    { "Typedef", { link = "Type" } },
    { "Type", { fg = colours.yellow } },
    { "Underlined", { fg = colours.blue, underline = true } },
    { "Visual", { bg = colours.bg3 } },
    { "VisualNOS", { link = "Visual" } },
    { "WarningMsg", { fg = colours.red } },
    { "WinBar", { fg = colours.fg4, bg = colours.bg0 } },
    { "WinBarNC", { fg = colours.fg3, bg = colours.bg1 } },
    { "WinSeparator", { fg = colours.bg3, bg = nil } },
    { "@attribute", { link = "PreProc" } },
    { "@boolean", { link = "Boolean" } },
    { "@character", { link = "Character" } },
    { "@character.special", { link = "SpecialChar" } },
    { "@comment.error", { link = "ErrorMsg" } },
    { "@comment", { link = "Comment" } },
    { "@comment.note", { link = "SpecialComment" } },
    { "@comment.warning", { link = "WarningMsg" } },
    { "@conditional", { link = "Conditional" } },
    { "@constant.builtin", { link = "Constant" } },
    { "@constant", { link = "Constant" } },
    { "@constructor", { link = "Function" } },
    { "@constructor.lua", { fg = colours.orange } },
    { "@diff.delta", { link = "diffChanged" } },
    { "@diff.minus", { link = "diffRemoved" } },
    { "@diff.plus", { link = "diffAdded" } },
    { "@function.builtin", { link = "Function" } },
    { "@function", { link = "Function" } },
    { "@function.macro", { link = "Macro" } },
    { "@keyword.conditional", { link = "Conditional" } },
    { "@keyword.debug", { link = "Debug" } },
    { "@keyword.directive.define", { link = "Define" } },
    { "@keyword.directive", { link = "PreProc" } },
    { "@keyword", { link = "Keyword" } },
    { "@label", { link = "Label" } },
    { "@markup.italic", { italic = true } },
    { "@markup", { fg = colours.fg1 } },
    { "@markup.list.checked", { fg = colours.green } },
    { "@markup.list", { link = "Delimiter" } },
    { "@markup.list.unchecked", { fg = colours.gray } },
    { "@markup.strikethrough", { strikethrough = true } },
    { "@markup.strong", { bold = true } },
    { "@markup.underline", { underline = true } },
    { "@method", { link = "Function" } },
    { "@module", { fg = colours.yellow } },
    { "@namespace", { fg = colours.yellow } },
    { "@number.float", { link = "Float" } },
    { "@number", { link = "Number" } },
    { "@operator", { link = "Operator" } },
    { "@property", { link = "Identifier" } },
    { "@punctuation", { link = "Delimiter" } },
    { "@string.escape", { link = "SpecialChar" } },
    { "@string", { link = "String" } },
    { "@string.regex", { link = "String" } },
    { "@string.regexp", { link = "String" } },
    { "@string.special", { link = "SpecialChar" } },
    { "@string.special.path", { link = "Underlined" } },
    { "@type.builtin", { link = "Type" } },
    { "@type.definition", { link = "Typedef" } },
    { "@type", { link = "Type" } },
    { "@type.qualifier", { link = "Type" } },
    { "@variable.builtin", { link = "Keyword" } },
    { "@variable", { link = "Identifier" } },
    { "@variable.member", { link = "Identifier" } },
    { "@variable.parameter.builtin", { link = "Identifier" } },
    { "@variable.parameter", { link = "Identifier" } },
}

for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group[1], group[2])
end
