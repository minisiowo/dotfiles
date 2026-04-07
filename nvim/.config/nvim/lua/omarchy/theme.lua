local M = {}

M.theme_file = os.getenv("HOME") .. "/.config/omarchy/current/theme/neovim.lua"

local function normalize_plugin_name(spec)
    if type(spec.name) == "string" and spec.name ~= "" then
        return spec.name
    end

    if type(spec[1]) == "string" and spec[1] ~= "" then
        return spec[1]:match(".*/(.*)$") or spec[1]
    end
end

function M.parse()
    if vim.fn.filereadable(M.theme_file) == 0 then
        return nil, "Omarchy theme file not found: " .. M.theme_file
    end

    local chunk, load_err = loadfile(M.theme_file)
    if not chunk then
        return nil, "Failed to load Omarchy theme file: " .. tostring(load_err)
    end

    local ok, specs = pcall(chunk)
    if not ok then
        return nil, "Error executing Omarchy theme file: " .. tostring(specs)
    end

    if type(specs) ~= "table" then
        return nil, "Omarchy theme file did not return a spec list"
    end

    local theme_specs = {}
    local colorscheme_name
    local plugin_name

    for _, spec in ipairs(specs) do
        if spec[1] == "LazyVim/LazyVim" then
            if spec.opts and spec.opts.colorscheme then
                colorscheme_name = spec.opts.colorscheme
            end
        else
            table.insert(theme_specs, spec)
            plugin_name = plugin_name or normalize_plugin_name(spec)
        end
    end

    return {
        plugin_name = plugin_name,
        colorscheme_name = colorscheme_name,
        theme_specs = theme_specs,
    }
end

return M
