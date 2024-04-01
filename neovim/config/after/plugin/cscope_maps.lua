require'cscope_maps'.setup {
  -- maps related defaults
  disable_maps = false, -- "true" disables default keymaps
  skip_input_prompt = false, -- "true" doesn't ask for input
  prefix = "<leader>c", -- prefix to trigger maps

  -- cscope related defaults
  cscope = {
    -- location of cscope db file
    db_file = "cscope.out",
    -- cscope executable
    exec = "cscope", -- "cscope" or "gtags-cscope"
    -- choose your fav picker
    picker = "quickfix", -- "telescope", "fzf-lua" or "quickfix"
    -- "true" does not open picker for single result, just JUMP
    skip_picker_for_single_result = false, -- "false" or "true"
    -- these args are directly passed to "cscope -f <db_file> <args>"
    db_build_cmd_args = { "-bqkv", "-i cscope.files" },
    -- statusline indicator, default is cscope executable
    statusline_indicator = nil,
  }
}

vim.g.cscopequickfix = "s-,c-,d-,i-,t-,f-,e-" -- cscope-macros.vim quickfix settings

-- key mappings
vim.cmd([[
    autocmd FileType * nnoremap <buffer> <C-Up> :cope 15<CR>
    autocmd FileType * nnoremap <buffer> <C-Down> :ccl <CR>
    autocmd FileType * nnoremap <buffer> <C-Right> :cn<CR>
    autocmd FileType * nnoremap <buffer> <C-Left> :cp<CR>
]])

-- Check if cscope.out exists one level up and add it to cscope
-- if vim.fn.has("cscope") and vim.fn.filereadable("cscope.out") == 1 then
--     vim.api.nvim_command("cs add .. ..")
-- end

-- Check if tags file exists one level up and add it to tags
if vim.fn.filereadable("tags") == 1 then
    vim.o.tags = vim.o.tags .. ";../tags"
end

--[[
Default Keymaps from https://github.com/dhananjaylatkar/cscope_maps.nvim
========================================================================

<prefix> can be configured using prefix option. Default value for prefix is <leader>c.

<prefix>s	find all references to the token under cursor
<prefix>g	find global definition(s) of the token under cursor
<prefix>c	find all calls to the function name under cursor
<prefix>t	find all instances of the text under cursor
<prefix>e	egrep search for the word under cursor
<prefix>f	open the filename under cursor
<prefix>i	find files that include the filename under cursor
<prefix>d	find functions that function under cursor calls
<prefix>a	find places where this symbol is assigned a value
<prefix>b	build cscope database
Ctrl-]	do :Cstag <cword>
]]
