return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
      style = 'night',
      transparent = vim.g.transparent_enabled,
      styles = {
        comments = { italic = false }, -- Disable italics in comments
        keywords = { italic = false }, -- Disable italics in keywords
        sidebars = 'transparent',
        floats = 'transparent',
      },
      on_highlights = function(hl, c)
        -- ensure whichkey has transparent bg
        -- hl.WhichKeyNormal = { bg = 'NONE' }

        -- Global float border/background (kept transparent by default)
        -- hl.FloatBorder = { fg = '#27a1b9', bg = '#16161e' }
        -- hl.LspFloatWinNormal = { bg = '#16161e' }

        -- NeoTree modified symbol - match lualine modified
        --   default (yellow) works better than green in sidebar
        -- hl.NeoTreeModified = { fg = c.green }

        -- Telescope bg/border (override for transparency)
        hl.TelescopeNormal = { fg = '#c0caf5', bg = '#222228' }
        hl.TelescopeBorder = { fg = '#27a1b9', bg = '#222228' }
        hl.TelescopePromptBorder = { fg = '#ff9e64', bg = '#222228' }
        hl.TelescopePromptTitle = { fg = '#ff9e64', bg = '#222228' }

        -- LazyGit bg/border (override for transparency)
        hl.LazyGitFloat = { fg = '#c0caf5', bg = '#222228' }
        hl.LazyGitBorder = { fg = '#27a1b9', bg = '#222228' }

        -- Lazy bg/border (override for transparency)
        hl.LazyNormal = { fg = '#c0caf5', bg = '#222228' }
        hl.LazyBorder = { fg = '#27a1b9', bg = '#222228' } -- custom: applied via autocmd

        -- Mason bg/border (override for transparency)
        hl.MasonNormal = { fg = '#c0caf5', bg = '#222228' }
        hl.MasonBorder = { fg = '#27a1b9', bg = '#222228' } -- custom: applied via autocmd

        -- Window separator to medium grey, v1 was c.dark3
        hl.WinSeparator = { fg = '#565f89', bg = 'NONE' }
        hl.VertSplit = { fg = '#565f89', bg = 'NONE' } -- compatibility with old configs/plugins
      end,
    }

    -- Load colorscheme and specific style
    vim.cmd.colorscheme 'tokyonight-night'

    -- Set custom borders for plugins that lack Border HighlightGroups
    local plugin_float_borders = {
      lazy = 'FloatBorder:LazyBorder',
      mason = 'FloatBorder:MasonBorder',
    }

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('PersonalPluginFloatHighlights', { clear = true }),
      pattern = { 'lazy', 'mason' },
      callback = function(args)
        local border = plugin_float_borders[vim.bo[args.buf].filetype]

        -- Schedule so this runs after plugins set their own default winhighlight.
        vim.schedule(function()
          for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
            local winhighlight = vim.wo[win].winhighlight:gsub(',?FloatBorder:[^,]*', '')
            vim.wo[win].winhighlight = (winhighlight .. ',' .. border):gsub('^,', '')
          end
        end)
      end,
    })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
