local M = {}

local plugins = require("omarchy.plugins")

local state_home = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
M.path = state_home .. "/omarchy/current/theme/neovim.lua"

local function read_theme_spec()
    local chunk, load_error = loadfile(M.path)
    if not chunk then
        return nil, ("cannot load %s: %s"):format(M.path, load_error)
    end

    local ok, spec = pcall(chunk)
    if not ok then
        return nil, ("cannot evaluate %s: %s"):format(M.path, spec)
    end
    if type(spec) ~= "table" then
        return nil, ("%s did not return a plugin specification"):format(M.path)
    end

    return spec
end

local function resolve(spec)
    local theme_plugin
    local colorscheme

    for _, item in ipairs(spec) do
        if type(item) == "table" then
            if item[1] == "LazyVim/LazyVim" then
                if type(item.opts) == "table" then
                    colorscheme = item.opts.colorscheme
                end
            elseif type(item[1]) == "string" and not theme_plugin then
                theme_plugin = item
            end
        end
    end

    if not theme_plugin then
        return nil, nil, "the Omarchy theme does not declare a theme plugin"
    end
    if type(colorscheme) ~= "string" then
        return nil, nil, "the Omarchy theme does not declare a colorscheme"
    end

    return theme_plugin, colorscheme
end

local function resolve_opts(plugin_spec)
    if type(plugin_spec.opts) == "table" then
        return vim.deepcopy(plugin_spec.opts), true
    end
    if type(plugin_spec.opts) == "function" then
        local ok, opts = pcall(plugin_spec.opts, plugin_spec, {})
        if not ok then
            return nil, false, opts
        end
        return opts or {}, true
    end
    return {}, false
end

local function configure_plugin(plugin_spec)
    local repository = plugin_spec[1]
    local module_name = plugins.modules[repository]
    if not module_name then
        return false, ("unsupported Omarchy Neovim theme plugin: %s"):format(repository)
    end

    local opts, has_opts, opts_error = resolve_opts(plugin_spec)
    if not opts then
        return false, opts_error
    end

    if type(plugin_spec.config) == "function" then
        local ok, config_error = pcall(plugin_spec.config, plugin_spec, opts)
        return ok, config_error
    end

    local ok, module = pcall(require, module_name)
    if not ok then
        -- Some colorscheme plugins expose only :colorscheme and no Lua module.
        if not has_opts then
            return true
        end
        return false, ("cannot load %s for %s: %s"):format(module_name, repository, module)
    end

    if type(module.setup) == "function" then
        local setup_ok, setup_error = pcall(module.setup, opts)
        if not setup_ok then
            return false, ("cannot configure %s: %s"):format(repository, setup_error)
        end
    end

    return true
end

function M.apply()
    local spec, read_error = read_theme_spec()
    if not spec then
        return false, read_error
    end

    local theme_plugin, colorscheme, resolve_error = resolve(spec)
    if not theme_plugin then
        return false, resolve_error
    end

    local configured, config_error = configure_plugin(theme_plugin)
    if not configured then
        return false, config_error
    end

    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end
    vim.o.background = "dark"

    local ok, colorscheme_error = pcall(vim.cmd.colorscheme, colorscheme)
    if not ok then
        return false, ("cannot apply colorscheme %s: %s"):format(colorscheme, colorscheme_error)
    end

    vim.cmd("redraw")
    return true
end

return M
