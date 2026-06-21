local M = {}

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.syntax = 'on'
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.guicursor = "n:blinkon1,n-v-c:block,i-ci-ve:ver25,i:blinkon1,r-cr:hor20,o:hor50"
-- 'guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
--   \,sm:block-blinkwait175-blinkoff150-blinkon175
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.tags = "./tags;,.tags;"
-- folding
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- 左侧状态列由 snacks.statuscolumn 管理
vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- 决定光标停留在一个位置不动时出发`CursorHold`和`CursorHoldI`事件的时间
-- 默认是4000ms，太慢了(breadcrumb需要实时更新)，改为100ms
vim.o.updatetime = 100
vim.g.mapleader = " "
-- 让neovim可以访问系统剪切板
vim.o.clipboard = "unnamedplus"
vim.o.writebackup = false
vim.o.numberwidth = 4
vim.o.pumheight = 10
-- 写入文件时的编码
vim.o.fileencoding = "utf-8"
vim.opt.swapfile = false
-- rustaceanvim 使用自定义on_attach(设置breadcrumb)
vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      require('leoz.lsp.lspfuncs').common_on_attach(client, bufnr)
    end,
  }
}

-- debug icons
local icons = require("leoz.icons").icons
local with_padding = require("leoz.icons").icon_with_padding
vim.fn.sign_define("DapBreakpoint", { text = icons.diagnostics.Debug, texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = icons.diagnostics.BoldQuestion, texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpointRejected", { text = icons.diagnostics.BoldInformation, texthl = "DiagnosticError" })
vim.fn.sign_define("DapStopped", { text = icons.ui.BoldArrowRight, texthl = "DiagnosticWarn", linehl = "Visual", numhl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = icons.diagnostics.Trace, texthl = "DiagnosticHint" })

M.useicons = true

-- snacks.indent 彩虹色 hl groups
local indent_colors = {
  "#E06C75", "#E5C07B", "#61AFEF", "#D19A66",
  "#98C379", "#C678DD", "#56B6C2", "#E06C75",
}
for i = 1, 8 do
  vim.api.nvim_set_hl(0, "SnacksIndent" .. i, { fg = indent_colors[i] })
end

return M
