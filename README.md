# texel.nvim

Most simplistic way of interacting with LLM in neovim.

# The idea

This plugin is as simple wrapper around [tgpt](https://github.com/aandrew-me/tgpt) utility which gives us an ability to interact with LLM via simple command line unitlity.

# Setup (using lazy)

```lua
return {
  'DavidTelenko/texel.nvim',
  keys = {
    { '<leader>ab', desc = 'Ask with buffer', mode = { 'n' } },
    { '<leader>as', desc = 'Open scratch markdown tab', mode = { 'n' } },
    { '<leader>a', desc = 'Ask with selection', mode = { 'v' } },
  },
  --- @module "texel"
  --- @type texel.Config
  opts = {},
  config = function(_, opts)
    local texel = require 'texel'

    texel.setup(opts)

    vim.keymap.set('v', '<leader>a', function()
      texel.chat.ask.selection()
    end, { desc = 'Ask with selection' })

    vim.keymap.set('n', '<leader>ab', function()
      texel.chat.ask.buffer()
    end, { desc = 'Ask with buffer' })

    vim.keymap.set('n', '<leader>as', function()
      vim.cmd 'tabnew'
      vim.cmd 'set filetype=markdown'
    end, { desc = 'Open scratch markdown tab buffer' })
  end,
}
```

# Default options

```lua
require('texel').setup {
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
```

> [!NOTE]
> Please see tgpt help to understand what tgpt realted options do

> [!NOTE]
> If you're confused which type of a flag we're using check your lsp completion, or see [here](./lua/texel/types.lua)
