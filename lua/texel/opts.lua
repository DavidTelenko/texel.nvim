local M = {}
-- -- In case plugin will require some local files
-- local function create_plugin_dir()
--   local plugin_path = vim.fs.joinpath(vim.fn.stdpath 'data', 'texel')
--
--   if vim.fn.isdirectory(plugin_path) == 0 then
--     vim.fn.mkdir(plugin_path, 'p')
--   end
-- end

local function setup_highlights()
  local hl_groups = require('texel.helpers').sign_hl_groups
  vim.api.nvim_set_hl(0, hl_groups.thinking, { fg = '#b8bb26' })
end

--- @param opts? texel.Config
M.setup = function(opts)
  M.opts = {
    chat = {
      separators = {
        first = { '', '---', '' },
        last = { '---', '' },
      },
      notify = true,
      signs = {
        thinking = { '|', '/', '-', '\\' },
      },
    },
    tgpt = {
      code = nil,
      key = nil,
      max_length = nil,
      model = nil,
      preprompt = nil,
      provider = nil,
      quiet = true,
      shell = nil,
      url = nil,
      whole = nil,
    },
  }

  if opts then
    M.opts = vim.tbl_deep_extend('force', M.opts, opts)
  end

  setup_highlights()
end

M.setup()

return M
