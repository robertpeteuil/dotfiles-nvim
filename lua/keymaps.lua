-- [[ Keymaps ]]
--
--    additional keymaps
--      plugin defs in plugins/
--      filetype defs in after/ftplugin/

-- ######## Misc -------------------------------------------

-- remap ZZ to confirm quit
vim.keymap.set('n', 'ZZ', '<Cmd>confirm qall<CR>', { desc = 'Quit all, prompting to save changes', silent = true })

-- clear highlights on search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- diagnostic current line (float)
vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', { desc = '[d]iagnotic (float)', silent = true })

-- ######## Buffer Related ---------------------------------

-- write without autocommands
vim.keymap.set('n', '<leader>bw', '<cmd>noautocmd write<CR>', { desc = 'buffer [w]rite no autocmd', silent = true })

-- close current buffer and switch to last buffer
--    note: <cmd> specification breaks functionality
vim.keymap.set('n', '<leader>bd', ':<C-U>bprevious <bar> bdelete #<CR>==', { desc = 'buffer [d]elete', silent = true })

-- pretty view JSONL (only available in JSONL buffers
--   <leader>bj keymap mapped in `nvim/lua/autocommands.lua:57:1`

-- ######## Editing ----------------------------------------

-- delete char without replacing unnamed register
vim.keymap.set('n', 'x', function()
  return vim.v.register == '"' and '"_x' or 'x'
end, { expr = true, desc = 'Delete char without replacing paste register' })

-- indent / unindent without leaving visual mode
vim.keymap.set('x', '>', '>gv')
vim.keymap.set('x', '<', '<gv')

-- meta shift h/j/k/l - text movement keys
-- text indent / unindent
vim.keymap.set('n', '<M-H>', '<<', { desc = 'Unindent current line', silent = true })
vim.keymap.set('n', '<M-L>', '>>', { desc = 'Indent current line', silent = true })
vim.keymap.set('x', '<M-H>', '<gv', { desc = 'Unindent selection', silent = true })
vim.keymap.set('x', '<M-L>', '>gv', { desc = 'Indent selection', silent = true })
-- text up / down
vim.keymap.set('n', '<M-J>', '<cmd>m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<M-K>', '<cmd>m .-2<CR>==', { silent = true })
vim.keymap.set('x', '<M-J>', ":move '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('x', '<M-K>', ":move '<-2<CR>gv=gv", { silent = true })

-- ######## Yank -------------------------------------------

-- yank date into register d
vim.keymap.set('n', '<leader>yd', function()
  vim.fn.setreg('d', os.date '%Y-%m-%d', 'c')
end, { desc = 'yank [d]ate to register d', silent = true })

-- yank file reference (relative path + line + column) to clipboard
vim.keymap.set({ 'n', 'x' }, '<leader>yp', function()
  local ref = vim.fn.expand '%:.' .. ':' .. vim.fn.line '.' .. ':' .. vim.fn.col '.'
  vim.fn.setreg('+', ref)
  vim.notify('Copied: ' .. ref)
end, { desc = 'yank file name:[p]os', silent = true })

-- yank relative path of current buffer to clipboard
vim.keymap.set({ 'n', 'x' }, '<leader>yf', '<cmd>let @+ = expand("%:.")<CR>', { desc = 'yank relative [f]ile-path', silent = true })

-- yank full path of current buffer to clipboard
vim.keymap.set({ 'n', 'x' }, '<leader>yF', '<cmd>let @+ = expand("%:p")<CR>==', { desc = 'yank [F]ull-path', silent = true })

-- ######## Paste ------------------------------------------

-- paste from system clipboard or yank-specific register
vim.keymap.set({ 'n', 'x' }, '<leader>pp', [["+p]], { desc = '[p]aste system clipboard', silent = true })
vim.keymap.set({ 'n', 'x' }, '<leader>py', [["0p]], { desc = 'paste [y]ank register', silent = true })

-- paste clipboard URL as a Markdown link (only available in Markdown buffers)
--   <leader>pl keymap defined in `after/ftplugin/markdown.lua`

-- ######## Search -----------------------------------------

-- search TODOs with telescope
vim.keymap.set('n', '<leader>sT', '<cmd>TodoTelescope<CR>', { desc = 'search [T]ODO comments', silent = true })

-- ######## Toggles ----------------------------------------

-- toggle spelling
vim.keymap.set('n', '<leader>ts', '<cmd>setlocal spell! spelllang=en_us<CR>', { desc = 'toggle [s]pelling', silent = true })

-- toggle transparency
--   requires 'xiyaowong/transparent.nvim' (loaded in "lua/lazy-plugins.lue")
vim.keymap.set('n', '<leader>tt', '<cmd>TransparentToggle<CR>==', { desc = 'toggle [t]ransparency', silent = true })

-- toggle markdown rendering
vim.keymap.set('n', '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', { desc = 'toggle [m]arkdown render', silent = true })

-- toggle boolean value
vim.keymap.set('n', '<leader>tv', function()
  local toggles = {
    ['true'] = 'false',
    ['always'] = 'never',
    ['yes'] = 'no',
    ['1'] = '0',
    ['on'] = 'off',
    ['&&'] = '||',
    ['+'] = '-',
    ['<'] = '>',
    ['<='] = '>=',
    ['let'] = 'const',
  }

  local cword = vim.fn.expand '<cword>'
  local newWord
  for word, opposite in pairs(toggles) do
    if cword == word then
      newWord = opposite
    end
    if cword == opposite then
      newWord = word
    end
  end
  if newWord then
    local prevCursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd.normal { '"_ciw' .. newWord, bang = true }
    vim.api.nvim_win_set_cursor(0, prevCursor)
  end
end, { desc = 'toggle boolean [v]alue', silent = true })

-- ######## Terminal ---------------------------------------

-- exit terminal mode in builtin terminal
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-n>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = 'Exit terminal mode' })

-- toggle terminal width
local term_wide = false
local term_original_width = nil
local EXTRA_COLS = 40

local function find_term_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'terminal' then
      return win
    end
  end
end

local function toggle_terminal_width()
  local term_win = find_term_win()
  if not term_win then
    return
  end

  if not term_wide then
    term_original_width = vim.api.nvim_win_get_width(term_win)
    vim.api.nvim_win_call(term_win, function() vim.cmd(EXTRA_COLS .. 'wincmd >') end)
    term_wide = true
  else
    if term_original_width then
      vim.api.nvim_win_set_width(term_win, term_original_width)
    end
    term_wide = false
  end
end

vim.keymap.set('n', '<leader>tw', toggle_terminal_width, { desc = 'toggle [t]erminal width' })
-- note: terminal-mode hotkey is Ctrl-/ but defined as <C-_>
vim.keymap.set('t', '<C-_>', toggle_terminal_width, { desc = 'toggle [t]erminal width' })

-- vim: ts=2 sts=2 sw=2 et
