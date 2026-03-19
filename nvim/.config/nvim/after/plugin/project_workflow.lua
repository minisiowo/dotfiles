local workflow = require("project_workflow")

vim.keymap.set("n", "<leader>lf", workflow.format_buffer, { desc = "Format buffer" })
vim.keymap.set("n", "<leader>ll", workflow.lint_current, { desc = "Run lint/check" })

vim.keymap.set("n", "<leader>tc", workflow.run_cargo_check, { desc = "Cargo check" })
vim.keymap.set("n", "<leader>tl", workflow.run_cargo_clippy, { desc = "Cargo clippy" })
vim.keymap.set("n", "<leader>tT", workflow.run_cargo_test, { desc = "Cargo test" })
vim.keymap.set("n", "<leader>td", workflow.run_tauri_dev, { desc = "Tauri dev" })
vim.keymap.set("n", "<leader>tb", workflow.run_tauri_build, { desc = "Tauri build" })
vim.keymap.set("n", "<leader>tv", workflow.run_frontend_dev, { desc = "Frontend dev" })
