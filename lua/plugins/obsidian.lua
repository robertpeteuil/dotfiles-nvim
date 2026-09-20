-- obsidian.nvim
return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- use latest release, remove to use latest commit
  dependencies = {
    -- ensure telescope is loaded to prevent startup error
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    ---@module 'obsidian'
    ---@type obsidian.config
    require('obsidian').setup {
      note_id_func = require('obsidian.builtin').title_id,
      picker = {
        name = 'telescope.nvim',
      },
      legacy_commands = false,
      workspaces = {
        {
          name = 'personal',
          path = '~/Versioned/notes/current',
        },
      },
      open_notes_in = 'vsplit',
      link = {
        style = 'wiki',
        format = 'shortest',
        auto_update = true,
      },
      daily_notes = {
        enabled = true,
        folder = 'dev/daily',
        date_format = 'YYYY-MM-DD',
        -- template = '~/Versioned/notes/current/Resources/Templates/Daily Template.md',
        default_tags = { 'Daily' },
      },
      -- ---@class obsidian.config.CallbackConfig
      -- ---@field enter_note? fun(note: obsidian.Note)
      -- callbacks = {
      -- Runs when entering a note buffer.
      -- enter_note = function(note)
      -- add function to disable render-markdown.lua features in buggers containing obsidian notes
      --  disable bullets: https://github.com/meanderingprogrammer/render-markdown.nvim#list-bullets
      --  disable checkboxes: https://github.com/meanderingprogrammer/render-markdown.nvim#checkboxes
      -- end,
      -- },
    }
  end,
}
