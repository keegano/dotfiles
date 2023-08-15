local builtin = require('telescope.builtin')
 -- Telescope keybinds
 -- Find files based on filename
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
 -- Search git history
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
 -- Diagnostics
vim.keymap.set("n", "<leader>dd", builtin.diagnostics)
 -- Find files containing text (prompt in normal mode or selection in visual mode)
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
local function get_visual_selection()
    -- Yank visual selection into `v` register
    vim.cmd('noau normal! "vy"')
    return vim.fn.getreg('v')
end
vim.keymap.set('v', '<leader>ps', function()
    builtin.grep_string({ search = get_visual_selection() })
end)
 -- List all neovim commands
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
