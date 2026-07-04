local M = {}

---Returns current visual selection by temporarily copying it to register `v`
---@return string
M.visual_selection = function()
  local saved_reg = vim.fn.getreg 'v'
  vim.cmd [[noa silent norm! "vy]]
  local selection = vim.fn.getreg 'v'
  vim.fn.setreg('v', saved_reg)
  return selection
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

M.sign_hl_groups = {
  thinking = 'TexelSignThinking',
}

M.ns = vim.api.nvim_create_namespace 'TexelSigns'

--- @param bufnr number Buffer handle (0 for current buffer)
--- @param lnum number 0-indexed line number
--- @param kind "thinking"
--- @return function stop function — call it to cancel the animation early
function M.animate_sign(bufnr, lnum, kind)
  local config = require('texel.opts').opts
  local interval = 120
  local frames = config.chat.signs and config.chat.signs[kind] or nil
  local id = nil -- extmark id, created on first tick

  if not frames then
    return function() end
  end

  if #frames == 1 then
    id = vim.api.nvim_buf_set_extmark(bufnr, M.ns, lnum, 0, {
      sign_text = frames[1],
      sign_hl_group = M.sign_hl_groups[kind],
      priority = 6,
    })

    return function()
      vim.api.nvim_buf_del_extmark(bufnr, M.ns, id)
    end
  end

  bufnr = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf()
    or bufnr

  -- sign_text in the gutter only has room for ~2 display cells, so keep
  -- frames short (1-2 chars). Emoji/wide glyphs can overflow the column.
  local frame_idx = 0
  local loop_count = 0

  local timer = vim.loop.new_timer()

  if not timer then
    error 'Timer was not initilazed!'
  end

  timer:start(0, interval, function()
    frame_idx = (frame_idx % #frames) + 1
    if frame_idx == 1 then
      loop_count = loop_count + 1
    end

    -- vim.schedule needed because timer callbacks run outside the main
    -- event loop and can't call most nvim_* API functions directly.
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        timer:stop()
        timer:close()
        return
      end

      id = vim.api.nvim_buf_set_extmark(bufnr, M.ns, lnum, 0, {
        id = id, -- reuse same id => updates in place instead of duplicating
        sign_text = frames[frame_idx],
        sign_hl_group = M.sign_hl_groups[kind],
        priority = 6,
      })
    end)
  end)

  return function()
    if not timer:is_closing() then
      timer:stop()
      timer:close()
      if id ~= nil then
        vim.api.nvim_buf_del_extmark(bufnr, M.ns, id)
      end
    end
  end
end

return M
