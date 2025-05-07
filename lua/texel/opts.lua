--- @type texel.Config
local M = {
  chat = {
    separators = {
      first = { '', '---', '' },
      last = { '---', '' },
    },
    notify = true,
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

-- -- In case plugin will require some local files
-- local function create_plugin_dir()
--   local plugin_path = vim.fs.joinpath(vim.fn.stdpath 'data', 'texel')
--
--   if vim.fn.isdirectory(plugin_path) == 0 then
--     vim.fn.mkdir(plugin_path, 'p')
--   end
-- end

--- @param opts? texel.Config
M.setup = function(opts)
  if opts then
    --- @type texel.Config
    M = vim.tbl_extend('force', M, opts)
  end
end

return M
