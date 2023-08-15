local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

 -- Harpoon usage: Mark open files with <space>a, view list of marked files with C-e,
 -- instantly nav to first four items with C-j,k,l,;
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-j>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-;>", function() ui.nav_file(4) end)
