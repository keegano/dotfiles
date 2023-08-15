vim.g.mapleader = " "
 -- "Project view" - open project directory
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

 -- Move selected lines up or down with J or K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

 -- Merge with following line but keep cursor position
vim.keymap.set("n", "J", "mzJ`z")
 -- Recenter cursor after jumping up/down a page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Center cursor when jumping to next/prev result of search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Remap Ctrl-C to be the same as escape
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

 -- Format buffer
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

 -- Next/prev error (shadowed by harpoon, may remap)
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

 -- find-and-replace-all word under cursor within the buffer
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

 -- jump to packer file
 -- Honestly I don't do this often enough to warrant a keybind
 -- vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/keegan/packer.lua<CR>");

 -- load current file as neovim config, I don't need this often
-- vim.keymap.set("n", "<leader><leader>", function()
--     vim.cmd("so")
-- end)
