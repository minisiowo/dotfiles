local M = {}

M.setup = function ()
    local miniclue = require("mini.clue")

    require("mini.basics").setup({
        options = {
            extra_ui = true,
        },
    })

    -- Load matchit before defining its mappings; its normal startup script would
    -- otherwise overwrite the same mappings later without descriptions.
    vim.cmd.packadd("matchit")

    local function describe_external_keymaps()
        -- mini.basics, matchit and vim-tmux-navigator create useful mappings
        -- without descriptions. Re-declare their public mappings so MiniClue can
        -- explain them instead of displaying raw commands.
        vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", {
            desc = "Down by display line",
            expr = true,
        })
        vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", {
            desc = "Up by display line",
            expr = true,
        })

        local tmux_mappings = {
            ["<C-h>"] = { "<cmd>TmuxNavigateLeft<cr>", "Navigate to left pane" },
            ["<C-j>"] = { "<cmd>TmuxNavigateDown<cr>", "Navigate to lower pane" },
            ["<C-k>"] = { "<cmd>TmuxNavigateUp<cr>", "Navigate to upper pane" },
            ["<C-l>"] = { "<cmd>TmuxNavigateRight<cr>", "Navigate to right pane" },
            ["<C-\\>"] = { "<cmd>TmuxNavigatePrevious<cr>", "Navigate to previous pane" },
        }
        for lhs, mapping in pairs(tmux_mappings) do
            vim.keymap.set("n", lhs, mapping[1], { desc = mapping[2], silent = true })
        end

        if vim.env.TMUX and vim.env.TMUX ~= "" then
            local terminal_tmux_mappings = {
                ["<C-h>"] = { "TmuxNavigateLeft", "Navigate to left pane" },
                ["<C-j>"] = { "TmuxNavigateDown", "Navigate to lower pane" },
                ["<C-k>"] = { "TmuxNavigateUp", "Navigate to upper pane" },
                ["<C-l>"] = { "TmuxNavigateRight", "Navigate to right pane" },
            }
            for lhs, mapping in pairs(terminal_tmux_mappings) do
                local key = lhs
                local command = mapping[1]
                vim.keymap.set("t", lhs, function()
                    if vim.bo.filetype == "fzf" then
                        return key
                    end
                    return "<C-w><cmd>" .. command .. "<cr>"
                end, {
                    desc = mapping[2],
                    expr = true,
                    replace_keycodes = true,
                    silent = true,
                })
            end
        end

        local matchit_mappings = {
            n = {
                ["%"] = { "<Plug>(MatchitNormalForward)", "Next matching item" },
                ["g%"] = { "<Plug>(MatchitNormalBackward)", "Previous matching item" },
                ["[%"] = { "<Plug>(MatchitNormalMultiBackward)", "Previous outer matching item" },
                ["]%"] = { "<Plug>(MatchitNormalMultiForward)", "Next outer matching item" },
            },
            o = {
                ["%"] = { "<Plug>(MatchitOperationForward)", "To next matching item" },
                ["g%"] = { "<Plug>(MatchitOperationBackward)", "To previous matching item" },
                ["[%"] = { "<Plug>(MatchitOperationMultiBackward)", "To previous outer matching item" },
                ["]%"] = { "<Plug>(MatchitOperationMultiForward)", "To next outer matching item" },
            },
            x = {
                ["%"] = { "<Plug>(MatchitVisualForward)", "Select to next matching item" },
                ["g%"] = { "<Plug>(MatchitVisualBackward)", "Select to previous matching item" },
                ["[%"] = { "<Plug>(MatchitVisualMultiBackward)", "Select previous outer match" },
                ["]%"] = { "<Plug>(MatchitVisualMultiForward)", "Select next outer match" },
                ["a%"] = { "<Plug>(MatchitVisualTextObject)", "Around matching block" },
            },
        }
        for mode, mappings in pairs(matchit_mappings) do
            for lhs, mapping in pairs(mappings) do
                vim.keymap.set(mode, lhs, mapping[1], { desc = mapping[2], remap = true })
            end
        end
    end

    describe_external_keymaps()

    require("mini.pairs").setup()
    require("mini.git").setup()
    require("mini.pick").setup()

    -- MINI.PICK
    -- <Leader>ff - Wyszukiwanie plików, również symlinków (np. ~/.config/niri)
    vim.keymap.set("n", "<leader>ff", function()
        require("mini.pick").builtin.cli({
            command = { "rg", "-L", "--files", "--color=never" },
        }, {
            source = { name = "Files" },
        })
    end, { desc = "Find Files" })

    -- <Leader>fg - Wyszukiwanie tekstu, również w symlinkowanych plikach
    vim.keymap.set("n", "<leader>fg", function()
        local MiniPick = require("mini.pick")
        local cwd = vim.fn.getcwd()
        local sys = { kill = function() end }

        local match = function(_, _, query)
            sys:kill()

            local pattern = table.concat(query)
            if pattern == "" then
                sys = { kill = function() end }
                return MiniPick.set_picker_items({}, { do_match = false })
            end

            local case = vim.o.ignorecase and (vim.o.smartcase and "smart-case" or "ignore-case") or "case-sensitive"
            local command = {
                "rg",
                "-L",
                "--column",
                "--line-number",
                "--no-heading",
                "--field-match-separator",
                "\\x00",
                "--color=never",
                "--" .. case,
                "--",
                pattern,
            }

            sys = MiniPick.set_picker_items_from_cli(command, {
                set_items_opts = { do_match = false },
                spawn_opts = { cwd = cwd },
            })
        end

        MiniPick.start({
            source = {
                name = "Grep live (rg -L)",
                items = {},
                match = match,
                cwd = cwd,
            },
        })
    end, { desc = "Find/Grep Text" })

    -- <Leader>fb - Przeszukiwanie otwartych buforów
    vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<CR>", { desc = "Find Buffers" })

    -- <Leader>fh - Przeszukiwanie dokumentacji (Help tags)
    vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<CR>", { desc = "Find Help Tags" })

    require("mini.surround").setup()
    require("mini.icons").setup()
    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = { 'n', 'x' }, keys = '<Leader>' },

            -- `[` and `]` keys
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },

            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },

            -- `g` key
            { mode = { 'n', 'x' }, keys = 'g' },

            -- Marks
            { mode = { 'n', 'x' }, keys = "'" },
            { mode = { 'n', 'x' }, keys = '`' },

            -- Registers
            { mode = { 'n', 'x' }, keys = '"' },
            { mode = { 'i', 'c' }, keys = '<C-r>' },

            -- Window commands
            { mode = 'n', keys = '<C-w>' },

            -- `z` key
            { mode = { 'n', 'x' }, keys = 'z' },
        },

        clues = {
            { mode = 'n', keys = '<Leader>b', desc = '+buffers' },
            { mode = 'n', keys = '<Leader>d', desc = '+diagnostics' },
            { mode = 'n', keys = '<Leader>f', desc = '+find' },
            { mode = 'n', keys = '<Leader>r', desc = '+rename' },
            { mode = 'n', keys = '<Leader>s', desc = '+splits' },
            { mode = 'n', keys = '<Leader>v', desc = '+visual' },
            { mode = 'n', keys = '<Leader>e', desc = 'Explorer' },
            { mode = 'n', keys = '<Leader>o', desc = 'Save and source file' },
            { mode = 'n', keys = '<Leader>R', desc = 'Restart Neovim with session restore' },

            miniclue.gen_clues.square_brackets(),
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
        },
    })
end

return M
