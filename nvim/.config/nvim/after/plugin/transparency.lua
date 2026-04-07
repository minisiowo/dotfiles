local groups = {
    core = {
        "Normal",
        "NormalNC",
        "NormalDark",
        "NormalFloat",
        "FloatBorder",
        "FloatTitle",
        "FloatFooter",
        "Pmenu",
        "Terminal",
        "EndOfBuffer",
        "WinSeparator",
        "CursorLine",
    },
    status = {
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        "FoldColumn",
        "Folded",
        "SignColumn",
        "StatusColumn",
        "LineNr",
        "CursorLineNr",
        "CursorLineFold",
        "CursorLineSign",
    },
    picker = {
        "WhichKeyFloat",
        "TelescopeBorder",
        "TelescopeNormal",
        "TelescopePromptBorder",
        "TelescopePromptTitle",
        "SnacksNormal",
        "SnacksNormalNC",
        "SnacksWinSeparator",
        "SnacksTitle",
        "SnacksFooter",
        "SnacksPicker",
        "SnacksPickerInputNormal",
        "SnacksPickerInputBorder",
        "SnacksPickerInputTitle",
        "SnacksPickerListNormal",
        "SnacksPickerListBorder",
        "SnacksPickerListTitle",
        "SnacksPickerListCursorLine",
        "SnacksPickerPreviewNormal",
        "SnacksPickerPreviewBorder",
        "SnacksPickerPreviewTitle",
        "SnacksPickerBoxNormal",
        "SnacksPickerBoxBorder",
        "SnacksPickerBoxTitle",
        "SnacksPickerBorder",
        "SnacksPickerTitle",
        "SnacksPickerFooter",
    },
    notify = {
        "NotifyINFOBody",
        "NotifyERRORBody",
        "NotifyWARNBody",
        "NotifyTRACEBody",
        "NotifyDEBUGBody",
        "NotifyINFOTitle",
        "NotifyERRORTitle",
        "NotifyWARNTitle",
        "NotifyTRACETitle",
        "NotifyDEBUGTitle",
        "NotifyINFOBorder",
        "NotifyERRORBorder",
        "NotifyWARNBorder",
        "NotifyTRACEBorder",
        "NotifyDEBUGBorder",
    },
    vcs = {
        "GitSignsAdd",
        "GitSignsChange",
        "GitSignsDelete",
        "GitSignsChangedelete",
        "GitSignsTopdelete",
        "GitSignsUntracked",
    },
}

local transparent_groups = {}
for _, section in pairs(groups) do
    vim.list_extend(transparent_groups, section)
end

local function set_transparent(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if not ok then
        return
    end

    hl.bg = "none"
    hl.ctermbg = "none"
    vim.api.nvim_set_hl(0, name, hl)
end

local function apply_transparency()
    for _, name in ipairs(transparent_groups) do
        set_transparent(name)
    end

    for _, name in ipairs(vim.fn.getcompletion("lualine", "highlight")) do
        set_transparent(name)
    end
end

local group = vim.api.nvim_create_augroup("custom_transparency", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = apply_transparency,
})

apply_transparency()
