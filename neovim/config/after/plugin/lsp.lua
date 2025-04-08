local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
--	'pyright',
    'pylsp',
    'golangci_lint_ls',
    'gopls',
    'clangd',
    'helm_ls',
    'terraformls',
    'tflint',
--    'jsonls',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
  ['<Enter>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
cmp_mappings['<C-n>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gD", function() vim.lsp.buf.definition() end, opts) -- Jumps to the definition of the symbol under the cursor.
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts) -- Displays hover information about the symbol under the cursor
  vim.keymap.set("n", "<leader>vs", function() vim.lsp.buf.workspace_symbol() end, opts) -- Lists all symbols in the current workspace in the quickfix window.
  -- To open the error in a separate small window. Need to run this command on the line where error/warning/hints are seen
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts) -- Show diagnostics in a floating window.
  -- To navigate in the above error window
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts) -- Move to the next diagnostic.
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts) -- Move to the previous diagnostic in the current buffer
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts) -- Selects a code action available at the current cursor position
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts) -- Lists all the references to the symbol under the cursor
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts) -- rename feature may not be supported by all the LSP servers. Check LSP server documentation.
  vim.keymap.set("i", "<leader>h", function() vim.lsp.buf.signature_help() end, opts) -- Displays signature information about the symbol under the cursor
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = false
--    virtual_text = {
--      prefix = " » ",
--      spacing = 2,
--    },
})
