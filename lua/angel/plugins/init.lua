-- lua/angel/plugins/init.lua
-- Main plugin loader - imports all plugin categories

return {
  -- Core functionality
  { import = "angel.plugins.lsp" },          -- LSP servers and configuration
  { import = "angel.plugins.dap" },          -- Debug adapters
  { import = "angel.plugins.completion" },   -- Auto-completion
  { import = "angel.plugins.testing" },      -- Test runners
  
  -- Code quality
  { import = "angel.plugins.formatting" },   -- Formatters and linters
  { import = "angel.plugins.syntax" },       -- Treesitter and parsing
  
  -- UI and navigation
  { import = "angel.plugins.ui" },           -- Interface plugins
  
  -- Editing enhancements
  { import = "angel.plugins.editing" },      -- Editing utilities
  
  -- Language-specific
  { import = "angel.plugins.ruby" },         -- Ruby and Rails
  
  -- Version control
  { import = "angel.plugins.git" },          -- Git integrations
  
  -- Development tools
  { import = "angel.plugins.tools" },        -- REST, LLM, Obsidian, etc
  
  -- Utilities
  { import = "angel.plugins.misc" },         -- Session, sort, etc
}
