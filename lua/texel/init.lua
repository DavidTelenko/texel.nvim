local M = {}

M.chat = require 'texel.chat'

--- @param opts? texel.Config
M.setup = function(opts)
  require('texel.opts').setup(opts)
end

return M
