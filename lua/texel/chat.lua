local helpers = require 'texel.helpers'

local M = {}

M.ask = {}

---Prompt tgpt with text from current buffer and get the output pasted into the
---current buffer
---@param args? string[]
---@param opts? texel.ChatOptions
M.ask.buffer = function(args, opts)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.cmd 'norm G'

  if lines then
    M.ask.plain(table.concat(lines, '\n'), args, opts)
  end
end

---Prompt tgpt with current selection and get the output pasted into current
---buffer
---@param args? string[]
---@param opts? texel.ChatOptions
M.ask.selection = function(args, opts)
  local selection = helpers.current_visual_selection()
  if selection then
    M.ask.plain(selection, args, opts)
  end
end

---@param args? texel.TgptOptions
local make_args = function(args)
  return vim
    .iter(args)
    :map(function(key, value)
      if type(value) == 'boolean' then
        if not value then
          return
        end
        return '--' .. key
      end
      return '--' .. key .. '=' .. value
    end)
    :totable()
end

---@param args? texel.TgptOptions
---@param prompt string
local function make_command(prompt, args)
  local config = require('texel.opts').opts
  local command = { 'tgpt' }

  local merged_args = vim.tbl_extend('force', config.tgpt or {}, args or {})

  if merged_args then
    vim.list_extend(command, make_args(merged_args))
  end

  table.insert(command, prompt)
  return command
end

---Exposes api functionality of plugin, provide your own string in the prompt
---parameter and get the output pasted into current buffer
---@param prompt string
---@param args? string[]
---@param opts? texel.ChatOptions
M.ask.plain = function(prompt, args, opts)
  local config = require('texel.opts').opts

  local local_opts = opts and vim.tbl_extend('force', config.chat, opts)
    or config.chat

  vim.api.nvim_buf_set_lines(0, -1, -1, false, local_opts.separators.first)

  if local_opts.notify then
    helpers.notify 'Generating...'
  end

  vim.system(
    make_command(prompt, args),
    {
      text = true,
    },
    vim.schedule_wrap(function(out)
      if out.code ~= 0 then
        helpers.notify 'tgpt failed to process prompt'
      end

      if out.stdout then
        local output = vim.split(out.stdout:sub(2), '\n')
        vim.api.nvim_buf_set_lines(0, -1, -1, false, output)
        vim.api.nvim_buf_set_lines(0, -1, -1, false, local_opts.separators.last)

        if local_opts.notify then
          helpers.notify 'Done'
          vim.defer_fn(function()
            helpers.notify ''
          end, 1000)
        end
      end
    end)
  )
end

return M
