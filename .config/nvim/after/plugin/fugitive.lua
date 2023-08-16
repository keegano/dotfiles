vim.keymap.set("n", "<leader>gg", vim.cmd.Git)
vim.keymap.set("n", "<leader>gb", ":Git blame -w -M<CR>")
vim.keymap.set("x", "<leader>gB", ":.GBrowse<CR>")
vim.keymap.set("n", "<leader>gd", vim.cmd.Gvdiffsplit)


