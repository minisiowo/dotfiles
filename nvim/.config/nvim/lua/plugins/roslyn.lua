return {
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            local function target_rank(target)
                local is_solution = target:match("%.slnx?$") ~= nil
                local _, depth = target:gsub("/", "")

                return {
                    is_solution and 0 or 1,
                    depth,
                    #target,
                }
            end

            vim.lsp.config("roslyn", {
                settings = {
                    ["csharp|background_analysis"] = {
                        dotnet_analyzer_diagnostics_scope = "fullSolution",
                        dotnet_compiler_diagnostics_scope = "fullSolution",
                    },
                    ["csharp|inlay_hints"] = {
                        csharp_enable_inlay_hints_for_implicit_object_creation = true,
                        csharp_enable_inlay_hints_for_implicit_variable_types = true,
                        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                        csharp_enable_inlay_hints_for_types = true,
                        dotnet_enable_inlay_hints_for_indexer_parameters = true,
                        dotnet_enable_inlay_hints_for_literal_parameters = true,
                        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                        dotnet_enable_inlay_hints_for_other_parameters = true,
                        dotnet_enable_inlay_hints_for_parameters = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                    },
                    ["csharp|symbol_search"] = {
                        dotnet_search_reference_assemblies = true,
                    },
                    ["csharp|completion"] = {
                        dotnet_show_name_completion_suggestions = true,
                        dotnet_show_completion_items_from_unimported_namespaces = true,
                        dotnet_provide_regex_completions = true,
                    },
                    ["csharp|code_lens"] = {
                        dotnet_enable_references_code_lens = true,
                        dotnet_enable_tests_code_lens = true,
                    },
                    ["csharp|formatting"] = {
                        dotnet_organize_imports_on_format = true,
                    },
                },
            })

            require("roslyn").setup({
                choose_target = function(targets)
                    table.sort(targets, function(left, right)
                        local left_rank = target_rank(left)
                        local right_rank = target_rank(right)

                        for i = 1, #left_rank do
                            if left_rank[i] ~= right_rank[i] then
                                return left_rank[i] < right_rank[i]
                            end
                        end

                        return left < right
                    end)

                    return targets[1]
                end,
            })
        end,
    },
}
