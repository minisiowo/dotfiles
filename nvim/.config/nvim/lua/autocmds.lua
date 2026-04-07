-- for java jdtls setup
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'java',
--     callback = function(args)
--         require("jdtls.jdtls_setup").setup()
--     end
-- })

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
    command = "wincmd =",
})

vim.filetype.add({
    extension = {
        axaml = "xml",
    },
    filename = {
        ["compose.yaml"] = "yaml",
        ["compose.yml"] = "yaml",
        ["docker-compose.yaml"] = "yaml",
        ["docker-compose.yml"] = "yaml",
    },
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Auto save when leaving buffer, losing focus, or leaving insert mode
vim.api.nvim_create_autocmd({"FocusLost", "BufLeave"}, {
    group = vim.api.nvim_create_augroup("auto_save", {}),
    callback = function()
        -- Only save if:
        -- 1. Buffer is modified
        -- 2. Buffer is not read-only
        -- 3. Buffer has a filename (not a new unnamed buffer)
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
            vim.cmd("silent write")
        end
    end,
})
