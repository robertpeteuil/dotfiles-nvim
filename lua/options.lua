-- [[ Setting options ]]

-- Make line numbers default
vim.o.number = true
-- relative line numbers
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- hide mode - in status line
vim.o.showmode = false

-- Keep Neovim registers separate from the system clipboard.
-- Yanks are mirrored to the system clipboard in autocommands.lua.
vim.o.clipboard = ''

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 700

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets whitespace character display
vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }  -- original
-- vim.opt.listchars = { tab = '· ', trail = '·', nbsp = '␣' }  -- gen 1 - dot
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' } -- gen 2 - none

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 12

-- Confirmation dialog
vim.o.confirm = true

-- Enable trusted project-local config files like `.nvim.lua`
--   new/edited files must be opened and trusted with `:trust`
vim.o.exrc = true

-- set indent = 2 spaces - guess-indent.nvim may override
-- vim.g.markdown_recommended_style = 0 -- disable default markdown ftplugin indendation
vim.o.tabstop = 2 -- A TAB character looks like 2 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting

-- hide ~ at end of buffer
vim.opt.fillchars:append { eob = ' ' }

-- set spellfile location
vim.opt.spellfile = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'

-- Prevent Git repository discovery above the notes directory
local notes_ceiling = vim.uv.fs_realpath(vim.fn.expand '~/Versioned/notes/current')
  or vim.fn.expand '~/Versioned/notes/current'

local existing_ceilings = vim.env.GIT_CEILING_DIRECTORIES

if existing_ceilings and existing_ceilings ~= '' then
  vim.env.GIT_CEILING_DIRECTORIES = notes_ceiling .. ':' .. existing_ceilings
else
  vim.env.GIT_CEILING_DIRECTORIES = notes_ceiling
end

-- auto-session options
--   20260606 - removed localoptions, winsize to eliminate issues related to pi terminal pane
--   20260619 - re-added localoptions, removed blank, tabpages, and winpos
vim.o.sessionoptions = 'buffers,curdir,folds,help,localoptions,terminal'

-- Set the default conceal level; filetype overrides are in autocommands.lua
vim.opt.conceallevel = 0

-- vim: ts=2 sts=2 sw=2 et
