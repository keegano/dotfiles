local lsp = require("lsp-zero")

lsp.preset({})

lsp.ensure_installed({
  'tsserver',
  'rust_analyzer',
  'lua_ls',
  'bashls',
  'sqlls',
  'clangd',
  'texlab',
  'jdtls',
  'jedi_language_server',
  'html',
  'cssls'
})


local lspconf = require('lspconfig')

lspconf.sqlls.setup{}

lspconf.texlab.setup{}

lspconf.clangd.setup{
  cmd = {
      "clangd",
      "--query-driver=/opt/gcc-arm-none-eabi-9-2020-q2-update/bin/arm-none-eabi-gcc"
  }
}

lspconf.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

lspconf.jedi_language_server.setup{}
lspconf.bashls.setup{}
lspconf.html.setup{
    filetypes = {"html", "htmldjango"},
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
        css = true,
        javascript = true
    },
    provideFormatter = true
}

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm(cmp_select),
    ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

-- lsp.on_attach(function(client, bufnr)
--   lsp.default_keymaps({buffer = bufnr})
-- end)

-- lsp.nvim_workspace()
lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>wa", function() vim.lsp.buf.add_workspace_folder() end, opts)
  vim.keymap.set("n", "<leader>wr", function() vim.lsp.buf.remove_workspace_folder() end, opts)
  vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lspconf.csharp_ls.setup({
    root_dir = function(filename, _)
        local root
        root = lspconf.util.find_git_ancestor(filename)
        root = root or lspconf.util.root_pattern("*.sln")(filename)
        root = root or lspconf.util.root_pattern("*.csproj")(filename)
        return root
    end,
})

lsp.setup()

