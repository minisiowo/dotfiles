return {
	{
		name = "omarchy-theme-hotreload",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 1000,
		config = function()
			local transparency_file = vim.fn.stdpath("config") .. "/after/plugin/transparency.lua"

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyReload",
				callback = function()
					-- Unload the adapter module to force re-reading the Omarchy file
					package.loaded["plugins.omarchy-theme"] = nil

					vim.schedule(function()
						local ok, theme_specs = pcall(require, "plugins.omarchy-theme")
						if not ok then
                            vim.notify("Failed to reload Omarchy theme: " .. tostring(theme_specs), vim.log.levels.ERROR)
							return
						end

                        -- The adapter returns a list of specs.
                        -- We need to find the theme plugin and the colorscheme name.
						local theme_plugin_name = nil
                        local colorscheme_name = nil

						for _, spec in ipairs(theme_specs) do
                            -- Find the colorscheme name from our custom "omarchy/theme-activator" spec
                            -- OR we can re-parse the Omarchy file, but the adapter already did the work.
                            -- Wait, the adapter returns a spec list.
                            -- One spec is the theme plugin (e.g. "bjarneo/aether.nvim")
                            -- One spec is the activator which applies the colorscheme.

                            -- Let's extract info.
							if spec[1] and not spec[1]:match("omarchy/theme%-activator") then
								theme_plugin_name = spec.name or spec[1]
							end

                            -- To find the colorscheme name, we can hackily look at the activator's config function
                            -- OR we can look at the raw Omarchy file again?
                            -- Simpler: The adapter filtered out LazyVim opts.
                            -- Let's just look at the adapter code I wrote. 
                            -- I didn't export the colorscheme name directly in the spec table except inside the function closure.
                            -- This makes it hard to extract here without parsing the file again.
                            -- Let's parse the file again here to be safe and clean.
						end

                        -- Helper to parse the original file to get the exact colorscheme name
                        local omarchy_file = os.getenv("HOME") .. "/.config/omarchy/current/theme/neovim.lua"
                        local chunk = loadfile(omarchy_file)
                        if chunk then
                            local raw_specs = chunk()
                            for _, spec in ipairs(raw_specs) do
                                if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
                                    colorscheme_name = spec.opts.colorscheme
                                    break
                                end
                            end
                        end

                        if not colorscheme_name then return end

						-- Clear all highlight groups before applying new theme
						vim.cmd("highlight clear")
						if vim.fn.exists("syntax_on") then
							vim.cmd("syntax reset")
						end

						-- Reset background to default
						vim.o.background = "dark"

						-- Unload theme plugin modules to force full reload
						if theme_plugin_name then
							local plugin = require("lazy.core.config").plugins[theme_plugin_name]
							if plugin then
								-- Unload all lua modules from the plugin directory
								local plugin_dir = plugin.dir .. "/lua"
								require("lazy.core.util").walkmods(plugin_dir, function(modname)
									package.loaded[modname] = nil
									package.preload[modname] = nil
								end)
							end
						end

                        -- Load the colorscheme plugin (lazy.nvim API)
                        require("lazy.core.loader").colorscheme(colorscheme_name)

                        vim.defer_fn(function()
                            -- Apply the colorscheme
                            pcall(vim.cmd.colorscheme, colorscheme_name)

                            -- Force redraw
                            vim.cmd("redraw!")

                            -- Reload transparency settings
                            if vim.fn.filereadable(transparency_file) == 1 then
                                vim.defer_fn(function()
                                    vim.cmd.source(transparency_file)

                                    -- Trigger UI updates
                                    vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
                                    vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })

                                    vim.cmd("redraw!")
                                end, 5)
                            end
                        end, 5)
					end)
				end,
			})
		end,
	},
}
