return {
  'stevearc/quicker.nvim',
  ft = 'qf',
  keys = {
    -- direct leader hotkey toggle
    {
      '<leader>q',
      function()
        require('quicker').toggle { focus = true }
      end,
      desc = 'toggle [q]uickfix',
    },
    -- original leader group based hotkeys
    -- {
    --   '<leader>qq',
    --   function()
    --     require('quicker').toggle { focus = true }
    --   end,
    --   desc = 'toggle [q]uickfix',
    -- },
    -- {
    --   '<leader>ql',
    --   function()
    --     require('quicker').toggle { loclist = true, focus = true }
    --   end,
    --   desc = 'toggle [l]ocation list',
    -- },
    -- {
    --   '<leader>qe',
    --   function()
    --     require('quicker').toggle_expand {
    --       before = 2,
    --       after = 2,
    --       add_to_existing = true,
    --     }
    --   end,
    --   desc = 'toggle quickfix [e]xpanded context',
    -- },
    -- {
    --   '<leader>qr',
    --   function()
    --     require('quicker').refresh()
    --   end,
    --   desc = '[r]efresh quickfix from source',
    -- },
  },
  ---@module 'quicker'
  ---@type quicker.SetupOptions
  opts = {
    keys = {
      {
        '>',
        function()
          require('quicker').expand {
            before = 2,
            after = 2,
            add_to_existing = true,
          }
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
      {
        'r',
        function()
          require('quicker').refresh()
        end,
        desc = 'Refresh quickfix from source',
      },
      {
        'q',
        function()
          local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
          require('quicker').close { loclist = wininfo and wininfo.loclist == 1 }
        end,
        desc = 'Close quickfix/location list',
      },
    },
  },
}
