return {
    "norcalli/nvim-colorizer.lua",
    config = function()
        require("colorizer").setup({
            "*",   -- włącz colorizer dla wszystkich typów plików
            css = { rgb_fn = true },  -- obsługa funkcji CSS: rgb(), rgba()
        })
    end,
}
