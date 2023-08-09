vim.cmd('packadd vim-airline')

vim.g['airline_powerline_fonts'] = 1
-- Set vim-airline theme - You can also change with :AirlineTheme <theme name>
-- vim.g.airline_theme='light'
-- vim.g['airline_theme'] = 'gruvbox'
vim.g['airline_theme'] = 'solarized'

-- Set encoding to UTF-8. This required for Powerline symbols to showing up in airline.
vim.cmd('set encoding=utf-8')

-- To disable detection of trailing white space displayed on the airline statusbar
vim.g['airline#extensions#whitespace#enabled'] = 0
-- enable/disable nerdtree's statusline integration
vim.g['.airline#extensions#nerdtree#status'] = 1
-- Set the section truncate widths for airline
vim.g['airline#extensions#default#section#truncate#width'] = {
    a = 20,
    b = 100,
    c = 20,
    gutter = 100,
    x = 20,
    y = 100,
    z = 20,
    warning = 100,
    error = 100,
}

-- TABLINE:
vim.g['airline#extensions#tabline#enabled'] = 0           -- enable airline tabline
vim.g['.airline#extensions#tabline#show_close_button']= 0 -- remove 'X' at the end of the tabline
vim.g['.airline#extensions#tabline#tabs_label'] = ''      -- can put text here like BUFFERS to denote buffers (I clear it so nothing is shown)
vim.g['.airline#extensions#tabline#buffers_label']= ''    -- can put text here like TABS to denote tabs (I clear it so nothing is shown)
vim.g['.airline#extensions#tabline#fnamemod'] = ':t'       -- disable file paths in the tab
vim.g['.airline#extensions#tabline#show_tab_count'] = 0    -- dont show tab numbers on the right
vim.g['.airline#extensions#tabline#show_buffers'] = 0      -- dont show buffers in the tabline
vim.g['.airline#extensions#tabline#tab_min_count'] = 2     -- minimum of 2 tabs needed to display the tabline
vim.g['.airline#extensions#tabline#show_splits'] = 0       -- disables the buffer name that displays on the right of the tabline
vim.g['.airline#extensions#tabline#show_tab_nr'] = 0       -- disable tab numbers
vim.g['.airline#extensions#tabline#show_tab_type'] = 0     -- disables the weird ornage arrow on the tabline


-- TAGBAR - To show buffers as tabs in the top
vim.g['.airline#extensions#tagbar#enabled'] = 1
vim.g['.airline#extensions#tagbar#flags'] = 'f'

-- unicode symbols
vim.g.airline_left_sep = '»'
vim.g.airline_left_sep = '▶'
vim.g.airline_right_sep = '«'
vim.g.airline_right_sep = '◀'
vim.g.airline_symbols.colnr = ' ㏇:'
vim.g.airline_symbols.colnr = ' ℅:'
vim.g.airline_symbols.crypt = '🔒'
vim.g.airline_symbols.linenr = '☰'
vim.g.airline_symbols.linenr = ' ␊:'
vim.g.airline_symbols.linenr = ' ␤:'
vim.g.airline_symbols.linenr = '¶'
vim.g.airline_symbols.maxlinenr = ''
vim.g.airline_symbols.maxlinenr = '㏑'
vim.g.airline_symbols.branch = '⎇'
vim.g.airline_symbols.paste = 'ρ'
vim.g.airline_symbols.paste = 'Þ'
vim.g.airline_symbols.paste = '∥'
vim.g.airline_symbols.spell = 'Ꞩ'
vim.g.airline_symbols.notexists = 'Ɇ'
vim.g.airline_symbols.notexists = '∄'
vim.g.airline_symbols.whitespace = 'Ξ'

-- powerline symbols
vim.g.airline_left_sep = ''
vim.g.airline_left_alt_sep = ''
vim.g.airline_right_sep = ''
vim.g.airline_right_alt_sep = ''
vim.g.airline_symbols.branch = ''
vim.g.airline_symbols.colnr = ' ℅:'
vim.g.airline_symbols.readonly = ''
vim.g.airline_symbols.linenr = ' :'
vim.g.airline_symbols.maxlinenr = '☰ '
vim.g.airline_symbols.dirty='⚡'

-- Function to patch airline theme palette
local function AirlineThemePatch(palette)
    if vim.g['airline_theme'] == 'solarized' then
        -- Greenish
        palette.normal.airline_a = { '#1c1c1c', '#5fff00', 234, 82 }
        palette.normal.airline_z = { '#1c1c1c', '#5fff00', 234, 82 }

        -- Blue
        palette.visual.airline_a = { '#ffffff', '#0087ff', 255, 33 }
        palette.visual.airline_z = { '#ffffff', '#0087ff', 255, 33 }

        -- Violetish
        palette.insert.airline_a = { '#3a3a3a', '#af00ff', 237, 129 }
        palette.insert.airline_z = { '#3a3a3a', '#af00ff', 237, 129 }

        -- Reddish
        palette.replace.airline_a = { '#ffffff', '#ff005f', 255, 197 }
        palette.replace.airline_z = { '#ffffff', '#ff005f', 255, 197 }
    end
end

vim.g['airline_theme_patch_func'] = AirlineThemePatch

-- Custom highlight groups for different sections
vim.cmd('highlight StatusLine guifg=white guibg=blue')
vim.cmd('highlight StatusLineNC guifg=white guibg=darkgrey')
vim.cmd('highlight airline_a guifg=green guibg=black')
vim.cmd('highlight airline_b guifg=yellow guibg=black')
vim.cmd('highlight airline_c guifg=blue guibg=black')
vim.cmd('highlight airline_x guifg=white guibg=black')
vim.cmd('highlight airline_y guifg=red guibg=black')
vim.cmd('highlight airline_z guifg=white guibg=black')

