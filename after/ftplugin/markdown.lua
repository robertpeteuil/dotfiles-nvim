-- markdown.lua

-- paste_markdown_link helper function
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

-- PASTE MARKDOWN LINK
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

  -- Leave Visual mode, then place the cursor at the end of the new link
  vim.api.nvim_input '<Esc>'
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(0) then
      vim.api.nvim_win_set_cursor(0, { start_row, start_col + #link - 2 })
    end
  end)
end

-- COMPLETE MARKDOWN TASK
local task_indicators = {
  [' '] = '✅',
  ['x'] = '✅',
  ['X'] = '✅',
  ['!'] = '⚪', -- alt: ⚠️
  ['>'] = '🟠',
  ['~'] = '⭕', -- alt: 🚫
}

local function complete_markdown_task()
  local line = vim.api.nvim_get_current_line()
  local task_status = line:match '^%s*%- %[([ xX~!>])%] '

  -- Match supported Obsidian task states: [ ], [x], [X], [~], [!], and [>]
  -- Supports top-level and indented tasks.
  if not task_status then
    vim.notify('Line not supported task', vim.log.levels.WARN)
    return
  end

  -- Convert only a completely unchecked task to [x].
  local completed = line:gsub('^(%s*)%- %[ %] ', '%1- [x] ', 1)

  completed = completed:gsub('%s+$', '')
  completed = completed .. ' ' .. task_indicators[task_status] .. ' ' .. os.date '%Y-%m-%d'

  vim.api.nvim_set_current_line(completed)
end

-- ARCHIVE MARKDOWN TASKS
--
-- todo_path: fullpath and filename of the global todo file
local todo_path = vim.fs.normalize(vim.fn.expand '~/Main/docs/TODO.md')
local completed_status = { x = true, X = true, ['~'] = true, ['>'] = true, ['!'] = true }

-- task_blocks: archive_markdown_tasks helper function
local function task_blocks(lines)
  local tasks, section = {}, nil

  for row, line in ipairs(lines) do
    local heading = line:match '^##%s+(.+)$'
    if heading then
      section = vim.trim(heading)
    end

    local status = line:match '^%- %[(.)%]%s'
    if status then
      local finish = row
      while finish < #lines and (lines[finish + 1] == '' or lines[finish + 1]:match '^%s') do
        finish = finish + 1
      end
      while finish > row and lines[finish] == '' do
        finish = finish - 1
      end

      tasks[#tasks+1] = {
        start = row,
        finish = finish,
        status = status,
        section = section,
      }
    end
  end

  return tasks
end

-- changelog_insertion: archive_markdown_tasks helper function
local function changelog_insertion(lines)
  for row, line in ipairs(lines) do
    if line:match '^%- %[(.)%]%s' then
      return row - 1
    end
  end

  local frontmatter_end = 0
  if lines[1] == '---' then
    for row = 2, #lines do
      if lines[row] == '---' then
        frontmatter_end = row
        break
      end
    end
  end

  for row = frontmatter_end + 1, #lines do
    if lines[row]:match '^#%s+' then
      local insertion = row
      while lines[insertion + 1] == '' do
        insertion = insertion + 1
      end
      return insertion
    end
  end

  return #lines
end

-- MAIN archive_markdown_tasks function
local function archive_markdown_tasks()
  local current_path = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  if (vim.uv.fs_realpath(current_path) or current_path) ~= (vim.uv.fs_realpath(todo_path) or todo_path) then
    vim.notify('non todo file', vim.log.levels.WARN)
    return
  end

  local mode = vim.api.nvim_get_mode().mode
  local visual = mode == 'v' or mode == 'V' or mode == '\22'
  local first = vim.api.nvim_win_get_cursor(0)[1]
  local last = first
  if visual then
    first, last = vim.fn.line 'v', vim.fn.line '.'
    if first > last then
      first, last = last, first
    end
  end

  local source_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local selected = {}
  for _, task in ipairs(task_blocks(source_lines)) do
    if task.start <= last and task.finish >= first then
      selected[#selected+1] = task
    end
  end

  if #selected == 0 then
    vim.notify('no task selected', vim.log.levels.WARN)
    return
  end

  -- changelog_dir: path of the changelog dir relative to todo_path
  local changelog_dir = vim.fs.joinpath(vim.fs.dirname(todo_path), 'changelog')
  local groups, group_order = {}, {}
  for _, task in ipairs(selected) do
    if not completed_status[task.status] then
      vim.notify('task not completed', vim.log.levels.WARN)
      return
    end
    if not task.section then
      vim.notify('task section not found', vim.log.levels.ERROR)
      return
    end

    local slug = task.section:gsub('%s+', '-')
    local path = vim.fs.joinpath(changelog_dir, 'CHANGELOG-' .. slug .. '.md')
    if not vim.uv.fs_stat(path) then
      vim.notify("changelog '" .. vim.fs.basename(path) .. "' not found", vim.log.levels.ERROR)
      return
    end

    if not groups[path] then
      groups[path] = { path = path, tasks = {} }
      group_order[#group_order+1] = groups[path]
    end
    groups[path].tasks[#groups[path].tasks+1] = task
  end

  local destinations = {}
  for _, group in ipairs(group_order) do
    local buffer = vim.fn.bufadd(group.path)
    vim.fn.bufload(buffer)
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    local insertion = {}

    for task_index = #group.tasks, 1, -1 do
      local task = group.tasks[task_index]
      vim.list_extend(insertion, vim.list_slice(source_lines, task.start, task.finish))
    end

    local insertion_row = changelog_insertion(lines)
    if insertion_row > 0 and lines[insertion_row] ~= '' then
      table.insert(insertion, 1, '')
    end
    vim.api.nvim_buf_set_lines(buffer, insertion_row, insertion_row, false, insertion)
    destinations[#destinations+1] = buffer
  end

  for _, buffer in ipairs(destinations) do
    local ok, err = pcall(vim.api.nvim_buf_call, buffer, function()
      vim.cmd 'silent write'
    end)
    if not ok then
      vim.notify(tostring(err), vim.log.levels.ERROR)
      return
    end
  end

  for index = #selected, 1, -1 do
    local task = selected[index]
    if index < #selected then
      pcall(function()
        vim.cmd 'undojoin'
      end)
    end
    vim.api.nvim_buf_set_lines(0, task.start - 1, task.finish, false, {})
  end

  if visual then
    vim.api.nvim_feedkeys(vim.keycode '<Esc>', 'nx', false)
  end
end

-- KEYMAPS

-- keymap: paste markdown link from URL
vim.keymap.set({ 'n', 'x' }, '<leader>pl', paste_markdown_link, {
  buffer = true,
  desc = 'paste markdown [l]ink from URL',
})

-- keymap: task complete
vim.keymap.set('n', '<leader>nc', complete_markdown_task, {
  buffer = true,
  desc = 'task [c]omplete',
})

-- keymap: task archive to changelog
vim.keymap.set({ 'n', 'x' }, '<leader>na', archive_markdown_tasks, {
  buffer = true,
  desc = '[a]rchive to changelog',
})

-- which-key notes group
require('which-key').add {
  {
    '<leader>n',
    group = '[n]otes',
    mode = { 'n', 'x' },
    buffer = true,
  },
}
