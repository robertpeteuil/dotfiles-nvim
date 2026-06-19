return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { '<leader>gl', '<cmd>LazyGit<cr>', desc = '[l]azygit' },
  },
  config = function()
    -- Adjust this value to change the maximum lazygit floating window width.
    local max_width = 180

    local function clamp_lazygit_window(win)
      if not vim.api.nvim_win_is_valid(win) then
        return
      end

      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype ~= 'lazygit' then
        return
      end

      local config = vim.api.nvim_win_get_config(win)
      if config.relative == '' then
        return
      end

      local width = math.min(config.width, max_width, vim.o.columns)
      if width == config.width then
        return
      end

      config.width = width
      config.col = math.floor((vim.o.columns - width) / 2)
      vim.api.nvim_win_set_config(win, config)
    end

    local function clamp_lazygit_windows()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        clamp_lazygit_window(win)
      end
    end

    local window = require 'lazygit.window'
    local open_floating_window = window.open_floating_window

    window.open_floating_window = function(...)
      local win, buf = open_floating_window(...)
      clamp_lazygit_window(win)
      return win, buf
    end

    vim.api.nvim_create_autocmd('VimResized', {
      group = vim.api.nvim_create_augroup('UserLazyGitMaxWidth', { clear = true }),
      callback = function()
        -- lazygit.nvim also resizes the popup after 20ms; run after it.
        vim.defer_fn(clamp_lazygit_windows, 50)
      end,
    })
  end,
}
