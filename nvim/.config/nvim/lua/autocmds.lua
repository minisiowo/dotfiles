-- for java jdtls setup
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function(args)
        require("jdtls.jdtls_setup").setup()
    end
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
    command = "wincmd =",
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})
