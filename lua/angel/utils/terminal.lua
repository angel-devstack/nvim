-- lua/angel/utils/terminal.lua
-- Terminal detection helpers for conditional plugin loading

local M = {}

-- Detect if running in WezTerm
-- Check for WEZTERM_PANE environment variable (most reliable WezTerm indicator)
function M.is_wezterm()
  return vim.env.WEZTERM_PANE ~= nil or vim.env.TERM_PROGRAM == "WezTerm"
end

-- Detect if running in iTerm
function M.is_iterm()
  return vim.env.TERM_PROGRAM == "iTerm.app"
end

-- Detect if running in Kitty (also supports image protocol like WezTerm)
function M.is_kitty()
  return vim.env.TERM == "xterm-kitty"
end

return M
