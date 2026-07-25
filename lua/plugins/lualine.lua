return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- adjust auto theme for transparent background
    local adjusted_auto = require 'lualine.themes.auto'
    adjusted_auto.normal.c.bg = 'None'

    -- custom display for mode with recording
    local function mode_with_recording(mode)
      local register = vim.fn.reg_recording()

      if register ~= '' then
        return 'RECORD @' .. register
      end

      return mode
    end

    require('lualine').setup {
      options = {
        theme = adjusted_auto,
        extensions = { 'neo-tree', 'lazy', 'fzf' },
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          { 'mode', fmt = mode_with_recording },
        },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          {
            'filename',
            path = 4,
            color = function()
              if vim.bo.modified then
                return { fg = '#9ece6a' }
              end

              local diff = require('lualine.components.diff.git_diff').get_sign_count()
              local has_diff = diff and (diff.added or 0) + (diff.modified or 0) + (diff.removed or 0) > 0

              return has_diff and { fg = '#ff9e64' } or {}
            end,
          },
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = { { 'filename', path = 4 } },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    }

    -- update lualine before/after recording
    local group = vim.api.nvim_create_augroup('LualineMacroRecording', { clear = true })

    vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
      group = group,
      callback = function() require('lualine').refresh() end,
    })
  end,
}
