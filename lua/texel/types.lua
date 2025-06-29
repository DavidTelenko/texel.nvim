---@class texel.Paths
---@field scratch_file string
---@field chats_dir string

---@class texel.Separators
---@field first string[]
---@field last string[]

---@class texel.ChatOptions
---@field separators texel.Separators
---@field notify boolean

---@class texel.TgptOptions
---@field code? boolean
---@field key? string
---@field max_length? string
---@field model? string
---@field preprompt? string
---@field provider? string
---@field quiet? boolean
---@field shell? boolean
---@field url? string
---@field whole? boolean

---@class texel.Config
---@field chat texel.ChatOptions
---@field tgpt texel.TgptOptions
