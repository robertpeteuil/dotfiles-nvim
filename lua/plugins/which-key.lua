-- which-key.nvim
return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    -- delay between pressing key and opening which-key (ms)
    -- independent of vim.o.timeoutlen
    delay = 0,
    layout = {
      width = { min = 20, max = 30 },
    },
    icons = {
      mappings = vim.g.have_nerd_font,
      -- use which-key.nvim defined Nerd Font icons or define a string table
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },
    -- Document existing key chains
    spec = {
      { '<leader>S', group = '[S]ession' },
      { '<leader>s', group = '[s]earch' },
      { '<leader>t', group = '[t]oggle' },
      { '<leader>g', group = '[g]it', mode = { 'n', 'v' } },
      { '<leader>b', group = '[b]uffer' },
      { '<leader>y', group = '[y]ank' },
      { '<leader>x', group = 'Trouble' },
      { '<leader>a', group = 'AI', icon = '', mode = { 'n', 'x' } },
      { '<leader>an', group = 'Next Edit Suggestions', icon = '⭾' },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
      { '<leader>?', ':WhichKey<cr>', desc = 'keymaps (whichkey)' },
    },
  },
  -- custom wrapper to adjust column widths for 'marks' and 'registers'
  config = function(_, opts)
    require('which-key').setup(opts)

    local wk_config = require 'which-key.config'
    local view = require 'which-key.view'
    local plugins = require 'which-key.plugins'
    local original_show = view.show
    local original_cols = plugins.cols
    local default_max = wk_config.layout.width.max

    local wide_plugins = {
      marks = true,
      registers = true,
    }
    local custom_ratio_plugins = {
      registers = true,
    }

    -- Widen columns for selected plugins
    ---@diagnostic disable-next-line: duplicate-set-field
    view.show = function(...)
      local state = require('which-key.state').state
      local plugin = state and state.node and state.node.plugin

      wk_config.layout.width.max = wide_plugins[plugin] and 50 or default_max

      return original_show(...)
    end

    -- Adjust column content/description ratios for selected plugins
    ---@diagnostic disable-next-line: duplicate-set-field
    plugins.cols = function(name)
      local cols = original_cols(name)

      if custom_ratio_plugins[name] then
        for _, col in ipairs(cols) do
          if col.key == 'value' then
            col.width = 0.65
            break
          end
        end
      end

      return cols
    end
  end,
}
-- vim: ts=2 sts=2 sw=2 et
