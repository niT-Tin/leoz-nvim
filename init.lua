local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- global things
require('leoz.utils')
-- opt options以及一些变量
require('leoz.optvars')
-- 映射
require('leoz.config.keymap')
-- plugins
local plugins = require('leoz.plugins')
-- autocmd
require('leoz.config.autocmds')
-- Load the plugin
local opts = {}
require("lazy").setup(plugins, opts)
-- theme
require('leoz.themes')
-- lsp server installed
-- ast_grep, clangd, bash-language-server, css-lsp, gopls, html-lsp, lua-language-server, luau-lsp, rust-analyzer, typescript-language-server
