local M = {}

local groups = {
    "Normal",
    "NormalFloat",
    "FloatBorder",
    "FloatTitle",
    "Pmenu",
    "Terminal",
    "EndOfBuffer",
    "FoldColumn",
    "Folded",
    "SignColumn",
    "LineNr",
    "CursorLineNr",
    "NormalNC",
    "MiniPickPrompt",
    "MiniPickPromptPrefix",
    "BlinkCmpMenu",
    "BlinkCmpMenuBorder",
    "BlinkCmpDocumentation",
    "BlinkCmpDocumentationBorder",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeVertSplit",
    "NeoTreeWinSeparator",
    "NeoTreeEndOfBuffer",
}

local function make_transparent(name)
    local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok and next(highlight) ~= nil then
        highlight.bg = nil
        vim.api.nvim_set_hl(0, name, highlight)
    end
end

function M.apply()
    for _, group in ipairs(groups) do
        make_transparent(group)
    end
end

function M.setup()
    local group = vim.api.nvim_create_augroup("OmarchyTransparency", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
            vim.schedule(M.apply)
        end,
    })
end

return M
