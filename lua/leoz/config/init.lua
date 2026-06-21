-- Configuration module aggregator
-- This file serves as a central entry point for all plugin configurations.
-- Each module is lazy-loaded on demand.

return {
  autocmds = "config.autocmds",
  keymap = "config.keymap",
  illuminate = "config.illuminate",
  ufo = "config.ufo",
  lualine = "config.lualine",
  bufferline = "config.bufferline",
  colorizer = "config.colorizer",
  todocomments = "config.todocomments",
  tokyonight = "config.tokyonight",
  gitsign = "config.gitsign",
  diagnostic = "config.diagnostic",
  nvimtreecontext = "config.nvimtreecontext",
}
