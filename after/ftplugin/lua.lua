local function format_with_stylua(range)
  require('conform').format {
    async = true,
    formatters = { 'stylua' },
    lsp_format = 'never',
    range = range,
  }
end

local function visual_range()
  local mode = vim.api.nvim_get_mode().mode
  local start = vim.fn.getpos 'v'
  local finish = vim.fn.getpos '.'
  local start_row, start_col = start[2], start[3]
  local end_row, end_col = finish[2], finish[3]

  if start_row == end_row and end_col < start_col then
    start_col, end_col = end_col, start_col
  elseif end_row < start_row then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  if mode == 'V' then
    start_col = 1
    end_col = #(vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, true)[1])
  end

  return {
    start = { start_row, start_col - 1 },
    -- The end column is exclusive; include the character under the cursor.
    ['end'] = { end_row, end_col },
  }
end

vim.keymap.set('n', '<leader>Fs', format_with_stylua, {
  buffer = true,
  desc = '[s]tyLua buffer',
})

vim.keymap.set('x', '<leader>Fs', function()
  format_with_stylua(visual_range())
  vim.api.nvim_feedkeys(vim.keycode '<Esc>', 'n', false)
end, {
  buffer = true,
  desc = '[s]tyLua selection',
})

vim.keymap.set('n', '<leader>Ft', function() require('treesj').toggle() end, {
  buffer = true,
  desc = '[t]oggle syntax node',
})

require('which-key').add {
  {
    '<leader>F',
    group = '[F]ormat specific',
    mode = { 'n', 'x' },
    buffer = true,
  },
}
