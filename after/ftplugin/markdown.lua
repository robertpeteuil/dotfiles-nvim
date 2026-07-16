local function clipboard_url()
  local url = vim.trim(vim.fn.getreg '+')

  if url == '' then
    vim.notify('Clipboard is empty', vim.log.levels.WARN)
    return nil
  end

  if url:find '[\r\n]' then
    vim.notify('Clipboard URL must be a single line', vim.log.levels.WARN)
    return nil
  end

  if not url:match '^%a[%w+.-]*:' then
    vim.notify('Clipboard does not contain a URL', vim.log.levels.WARN)
    return nil
  end

  return url
end

local function paste_markdown_link()
  local url = clipboard_url()
  if not url then
    return
  end

  local mode = vim.fn.mode()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  if mode == 'n' then
    local link = '[](' .. url .. ')'
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { link })
    vim.api.nvim_win_set_cursor(0, { row, col + 1 })
    return
  end

  if mode ~= 'v' then
    vim.notify('Select text characterwise on a single line', vim.log.levels.WARN)
    return
  end

  local anchor = vim.fn.getpos 'v'
  local cursor = vim.fn.getpos '.'
  local start_row, start_col = anchor[2], anchor[3]
  local end_row, end_col = cursor[2], cursor[3]

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  if start_row ~= end_row then
    vim.notify('Markdown link text must be on a single line', vim.log.levels.WARN)
    return
  end

  local label = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})[1]
  local link = '[' .. label .. '](' .. url .. ')'
  vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, { link })

  -- Leave Visual mode, then place the cursor at the end of the new link.
  vim.api.nvim_input '<Esc>'
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(0) then
      vim.api.nvim_win_set_cursor(0, { start_row, start_col + #link - 2 })
    end
  end)
end

vim.keymap.set({ 'n', 'x' }, '<leader>pl', paste_markdown_link, {
  buffer = true,
  desc = 'paste URL as Markdown [l]ink',
})

local function complete_markdown_task()
  local line = vim.api.nvim_get_current_line()

  -- Match incomplete Obsidian task states: [ ], [~], [!], and [>].
  -- Supports top-level and indented tasks.
  local completed, replacements = line:gsub('^(%s*)%- %[[ ~!>]%] ', '%1- [x] ', 1)

  if replacements == 0 then
    vim.notify('Line not incomplete task', vim.log.levels.WARN)
    return
  end

  completed = completed:gsub('%s+$', '')
  completed = completed .. ' ✅ ' .. os.date '%Y-%m-%d'

  vim.api.nvim_set_current_line(completed)
end

vim.keymap.set('n', '<leader>tc', complete_markdown_task, {
  buffer = true,
  desc = 'toggle task [c]omplete',
})
