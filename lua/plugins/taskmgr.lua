return {
  dir = vim.fn.expand '~/Services/taskmgr.nvim',
  name = 'taskmgr.nvim',
  lazy = false,
  dependencies = { 'folke/which-key.nvim' },
  config = function()
    require('taskmgr').setup {
      -- Where `:Taskmgr open` puts the task file: 'current' | 'split' | 'vsplit'
      -- open_mode = 'vsplit',

      -- Additional create-task picker entries, merged with non-terminal task values
      -- Suggestions only; any typed value is accepted
      suggestions = {
        project = { 'taskmgr', 'dotfiles', 'herdr', 'pi', 'nvim' },
        type = { 'feat', 'fix', 'test', 'docs', 'chore', 'config', 'refactor' },
        scope = {},
      },

      -- Fallback values for blank classifications when a task is saved
      creation = {
        project = 'inbox',
        type = 'chore',
        scope = 'core',
      },

      workbench = {
        views = {
          default = {
            fallback_sort = {
              { field = 'priority', direction = 'asc' },
              { field = 'created_at', direction = 'desc' },
            },
            group = {
              field = 'project',
              direction = 'custom',
              custom = { project = { 'taskmgr', 'herdr', 'pi', 'nvim', 'dotfiles' } },
            },
            separate_tasks = false,
          },
          completed = {
            filters = { status = { 'completed' } },
            group = {
              field = 'project',
              direction = 'custom',
              custom = { project = { 'taskmgr', 'herdr', 'pi', 'nvim', 'dotfiles' } },
            },
            sort = {
              field = 'completed_at',
              direction = 'desc',
            },
            show_priority_badge = false,
          },
          task_list = {
            group = {
              field = 'project',
              direction = 'custom',
              custom = { project = { 'taskmgr', 'herdr', 'pi', 'nvim', 'dotfiles' } },
            },
            show_descriptions = false,
            separate_tasks = false,
          },
        },
      },
    }

    require('which-key').add {
      { '<leader>m', group = 'task [m]anager' },

      -- actions
      { '<leader>mm', '<Cmd>Taskmgr<CR>', desc = 'workbench' },
      { '<leader>mg', '<Cmd>Taskmgr jump<CR>', desc = 'jump [g]roup' },
      { '<leader>mc', '<Cmd>Taskmgr create<CR>', desc = '[c]reate task' },
      { '<leader>mo', '<Cmd>Taskmgr openvsplit<CR>', desc = '[o]pen (vsplit)' },
      { '<leader>mO', '<Cmd>Taskmgr open<CR>', desc = '[o]pen' },
      { '<leader>mr', '<Cmd>Taskmgr refresh<CR>', desc = '[r]efresh' },
      { '<leader>mR', '<Cmd>Taskmgr refresh!<CR>', desc = '[R]efresh (force)' },
      { '<leader>m/', '<Cmd>Taskmgr search<CR>', desc = 'search…' },

      -- task actions
      { '<leader>md', '<Cmd>Taskmgr duplicate<CR>', desc = '[d]uplicate' },
      { '<leader>my', '<Cmd>Taskmgr yanktask<CR>', desc = '[y]ank url' },
      { '<leader>ml', '<Cmd>Taskmgr jumplink<CR>', desc = 'jump [l]ink' },

      -- set task properties
      { '<leader>ms', group = '[s]et task…' },
      { '<leader>mss', '<Cmd>Taskmgr status<CR>', desc = 'set [s]tatus…' },
      { '<leader>msf', '<Cmd>Taskmgr favorite<CR>', desc = 'set [f]avorite' },
      { '<leader>msp', '<Cmd>Taskmgr priority<CR>', desc = 'set [p]riority' },

      -- views
      { '<leader>mv', group = '[v]iew…' },
      { '<leader>mvf', '<Cmd>Taskmgr filter favorites<CR>', desc = '[f]avorites' },
      { '<leader>mvc', '<Cmd>Taskmgr view completed<CR>', desc = '[c]ompleted' },
      { '<leader>mvt', '<Cmd>Taskmgr view task_list<CR>', desc = '[t]ask-list' },
      { '<leader>mvr', '<Cmd>Taskmgr reset<CR>', desc = '[r]eset view' },
      { '<leader>mvd', '<Cmd>Taskmgr toggle descriptions<CR>', desc = 'toggle [d]escriptions' },
      { '<leader>mvs', '<Cmd>Taskmgr toggle separator<CR>', desc = 'toggle [s]eparator' },

      -- advanced
      { '<leader>ma', group = '[a]dvanced…' },
      { '<leader>maf', '<Cmd>Taskmgr filter<CR>', desc = '[f]ilter…' },
      { '<leader>mag', '<Cmd>Taskmgr group<CR>', desc = '[g]roup…' },
      { '<leader>mas', '<Cmd>Taskmgr sort<CR>', desc = '[s]ort…' },
      { '<leader>mad', '<Cmd>Taskmgr duplicate full<CR>', desc = '[d]uplicate (full)' },
      { '<leader>max', '<Cmd>Taskmgr diagnostics<CR>', desc = 'diagnostics' },
    }

    -- define <CR> hotkey only in taskmgr workbench
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'taskmgr://workbench/*',
      callback = function(args)
        vim.keymap.set('n', '<CR>', '<Cmd>Taskmgr smart<CR>', {
          buffer = args.buf,
          desc = 'taskmgr smart action',
        })
      end,
    })
  end,
}
