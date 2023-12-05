-- For more configs refer ludovicchabant/vim-gutentags

vim.g.gutentags_modules = {"cscope_maps"} -- This is required. Other config is optional. Specifies a list of modules to load for Gutentags.
vim.g.gutentags_cscope_build_inverted_index_maps = 1 -- Configures whether to build. The value 1 indicates that it should be enabled.
vim.g.gutentags_auto_add_cscope = 0 -- If set to 1, Gutentags will automatically add the generated code database to Vim by running :cs add
vim.g.gutentags_exclude_= {'.git', 'build', 'vendor', "package" } -- Exclude these folders while building the tags
-- vim.g.gutentags_cache_dir = vim.fn.expand("~/.gutentags") -- Sets the directory where Gutentags will store its cache and tag files
vim.g.gutentags_file_list_command = "fd -E '.*\\.(c|h|l|y|s|p|x|yang|ini|proto|sh|yaml|tf|tfvars)$'" -- Specifies the command to generate the list of files for tag generation. The fd command with filters for C and header files is used here.
vim.g.gutentags_file_list_ = { '*.py', '*.go', '*.c', '*.h', '*.tf', '*.ini', '*.proto', '*.xml', '*.yang', '*.sh', '*.yaml', '*.cpp', '*.hpp'}
vim.g.gutentags_trace = 1
-- vim.g.gutentags_debug = 1
