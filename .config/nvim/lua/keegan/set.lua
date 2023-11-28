 -- No fancy cursor, just highlight the cursor position
vim.opt.guicursor = ""

 -- Show line numbers on the left relative to cursor position
vim.opt.nu = true
vim.opt.relativenumber = true

 -- spaces > tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

 -- Don't wrap lines, I'd rather scroll right if necessary
vim.opt.wrap = false

 -- Don't generate swapfiles or backups
vim.opt.swapfile = false
vim.opt.backup = false
 -- Keep a persistent undo file so I can undo stuff even after I reopen vim
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

 -- Don't highlight most recent search matches. Search incrementally.
vim.opt.hlsearch = false
vim.opt.incsearch = true

 -- Moar colors
vim.opt.termguicolors = true

 -- Number of lines to keep above and below cursor when scrolling
vim.opt.scrolloff = 8
 -- Extra column to the left for debuggers and LSPs to insert markings
vim.opt.signcolumn = "yes"

-- Include '@' in potential filenames
vim.opt.isfname:append("@-@")

 -- If we had a swapfile, this is how many milliseconds it would use to update
vim.opt.updatetime = 50

 -- Highlight the 80 character wide column so we can easily see if we're too
 -- wide
vim.opt.colorcolumn = "80"

 -- Copy/paste across WSL
-- vim.g.clipboard = {
--     name = "WslClipboard",
--     copy = {
--         ["+"] = "clip.exe",
--         ["*"] = "clip.exe"
--     },
--     paste = {
--         ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--         ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
--     },
--     cache_enabled = 0,
-- }


