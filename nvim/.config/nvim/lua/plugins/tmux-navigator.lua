return {
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Tmux left" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Tmux down" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Tmux up" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Tmux right" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Tmux previous pane" },
        },
    },
}
