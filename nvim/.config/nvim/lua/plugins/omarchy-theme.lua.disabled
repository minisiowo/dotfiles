-- Adapter to load Omarchy theme without LazyVim dependency
local omarchy_theme_path = os.getenv("HOME") .. "/.config/omarchy/current/theme/neovim.lua"

if vim.fn.filereadable(omarchy_theme_path) == 0 then
  vim.notify("Omarchy theme file not found: " .. omarchy_theme_path, vim.log.levels.WARN)
  return {}
end

-- Load the Omarchy config file
local chunk = loadfile(omarchy_theme_path)
if not chunk then
    vim.notify("Failed to load Omarchy theme file", vim.log.levels.ERROR)
    return {}
end

local success, specs = pcall(chunk)
if not success then
    vim.notify("Error executing Omarchy theme file: " .. tostring(specs), vim.log.levels.ERROR)
    return {}
end

local final_specs = {}
local colorscheme_name = nil

for _, spec in ipairs(specs) do
    -- Check if it is the LazyVim config block
    if spec[1] == "LazyVim/LazyVim" then
        if spec.opts and spec.opts.colorscheme then
            colorscheme_name = spec.opts.colorscheme
        end
    else
        -- It's a theme plugin, keep it
        table.insert(final_specs, spec)
    end
end

-- Add a spec to apply the colorscheme
if colorscheme_name then
    table.insert(final_specs, {
        name = "omarchy-theme-activator", -- Fake name to handle activation
        dir = vim.fn.stdpath("config"), -- Use local config dir to prevent git clone
        lazy = false, -- Make sure it runs on startup
        priority = 900, -- Run after the theme plugin (usually 1000)
        config = function()
            -- Apply the colorscheme safely
            -- We use a pcall just in case the theme plugin isn't fully ready or name is wrong
            local ok, err = pcall(vim.cmd.colorscheme, colorscheme_name)
            if not ok then
                vim.notify("Failed to apply Omarchy colorscheme '" .. colorscheme_name .. "': " .. err, vim.log.levels.WARN)
            end
        end
    })
end

return final_specs
