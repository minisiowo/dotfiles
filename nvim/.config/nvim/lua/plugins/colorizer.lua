return {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        "*",
        css = { rgb_fn = true },
    },
}
