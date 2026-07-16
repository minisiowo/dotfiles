local M = {}

M.setup = function ()
    local miniclue = require("mini.clue")

    require("mini.basics").setup({
        options = {
            extra_ui = true,
        },
    })

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
