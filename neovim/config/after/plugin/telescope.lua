-- Load Telescope
require('telescope').setup({
  defaults = {
    -- Default options for all pickers
    -- ...
    mappings = {
      i = {
        ["<S-d>"] = require('telescope.actions').delete_buffer,
        ["<Down>"] = require('telescope.actions').move_selection_next,
        ["<S-j>"] = require('telescope.actions').move_selection_next,
        ["<Up>"] = require('telescope.actions').move_selection_previous,
        ["<S-k>"] = require('telescope.actions').move_selection_previous,
      },
      n = {
        ["<S-d>"] = require('telescope.actions').delete_buffer,
        ["<Down>"] = require('telescope.actions').move_selection_next,
        ["<S-j>"] = require('telescope.actions').move_selection_next,
        ["<Up>"] = require('telescope.actions').move_selection_previous,
        ["<S-k>"] = require('telescope.actions').move_selection_previous,
      },
    },
  },
  pickers = {
    buffers = {
      -- Options for the buffers picker
      theme = "dropdown", -- Use the dropdown theme for the picker
      previewer = false, -- Disable buffer previews in the picker
      sort_mru = true -- Sorts all buffers after  most receent used
    },
    -- You can define options for other pickers here if needed
  },
})

-- Keybinding to trigger the buffers picker
vim.api.nvim_set_keymap('n', '<S-Up>', "<Cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true, silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<Leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})


