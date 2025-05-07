local M = {}

--- Returns contents of current visual selection
--- @return string?
M.current_visual_selection = function()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<Esc>', false, true, true),
    'nx',
    false
  )
  local b_line, b_col
  local e_line, e_col

  local mode = vim.fn.visualmode()

  b_line, b_col = unpack(vim.fn.getpos "'<", 2, 3)
  e_line, e_col = unpack(vim.fn.getpos "'>", 2, 3)

  if e_line < b_line or (e_line == b_line and e_col < b_col) then
    e_line, b_line = b_line, e_line
    e_col, b_col = b_col, e_col
  end

  local lines = vim.api.nvim_buf_get_lines(0, b_line - 1, e_line, 0)

  if #lines == 0 then
    return
  end

  if mode == '\22' then
    local b_offset = math.max(1, b_col) - 1
    for ix, line in ipairs(lines) do
      -- On a block, remove all presiding chars unless b_col is 0/negative
      lines[ix] = vim.fn.strcharpart(
        line,
        b_offset,
        math.min(e_col, vim.fn.strwidth(line))
      )
    end
  elseif mode == 'v' then
    local last = #lines
    local line_size = vim.fn.strwidth(lines[last])
    local max_width = math.min(e_col, line_size)
    if max_width < line_size then
      -- If the selected width is smaller then total line, trim the excess
      lines[last] = vim.fn.strcharpart(lines[last], 0, max_width)
    end

    if b_col > 1 then
      -- on a normal visual selection, if the start column is not 1, trim the beginning part
      lines[1] = vim.fn.strcharpart(lines[1], b_col - 1)
    end
  end
  return table.concat(lines, '\n')
end

M.notify = function(msg, level)
  if vim.in_fast_event() then
    vim.schedule(function()
      vim.notify(msg, level)
    end)
  else
    vim.notify(msg, level)
  end
end

return M
