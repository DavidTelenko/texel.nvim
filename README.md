# texel.nvim

Most simplistic way of interacting with LLM in neovim.

# The idea

This plugin is a simple wrapper around [tgpt](https://github.com/aandrew-me/tgpt) CLI utility. In the most basic sence we achieve interaction with CLI application by using neovim's buffers, this gives us full power of neovim motions alongside full functionality of CLI application.

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

# Future improvements and goals

- [ ] Implemenent functioanlity of a tgpt in lua natively.
- [ ] Stream results line-wise or word-wise instead of the whole response.
