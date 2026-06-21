local utils = require('leoz.utils')

vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>e', '', { noremap = true, silent = true, callback = function()
  local buf = vim.fn.expand("%:p:h")
  require('snacks').explorer.open({ cwd = vim.fn.isdirectory(buf) == 1 and buf or nil })
end, desc = '开启/关闭文件树' })
vim.api.nvim_set_keymap('n', '<Leader>E', '', { noremap = true, silent = true, callback = function() require('snacks').explorer.reveal() end, desc = '定位当前文件' })
vim.api.nvim_set_keymap('n', 's', '<Plug>(easymotion-bd-f)', { noremap = true, silent = true, desc = '快速跳转' })
vim.api.nvim_set_keymap('n', '<Leader>f', '<Plug>(easymotion-overwin-f)', { noremap = true, silent = true, desc = '跨窗口跳转' })
vim.api.nvim_set_keymap('n', '<Leader>h', ':noh<CR>', { noremap = true, silent = true, desc = '清除高亮' })
vim.api.nvim_set_keymap('n', '<Leader>Lc', "<cmd>edit " .. utils.get_config_dir() .. "/init.lua<CR>",
  { noremap = true, silent = true, desc = '编辑配置文件' })
-- Terminal: env 区分不同位置的终端实例
vim.keymap.set({ 'n', 't' }, '<M-r>', function()
  require('snacks').terminal.toggle(vim.o.shell, { interactive = true, env = { SNACKS_POS = "float" } })
end, { desc = '浮动终端' })
vim.keymap.set({ 'n', 't' }, '<M-w>', function()
  require('snacks').terminal.toggle(nil, { win = { position = "bottom", height = 0.3 }, interactive = true, env = { SNACKS_POS = "bottom" } })
end, { desc = '水平终端' })
vim.keymap.set({ 'n', 't' }, '<M-e>', function()
  require('snacks').terminal.toggle(nil, { win = { position = "right", width = 0.4 }, interactive = true, env = { SNACKS_POS = "right" } })
end, { desc = '垂直终端' })

vim.api.nvim_set_keymap('n', '<Leader>lg', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('snacks').lazygit()
  end,
  desc = '打开lazygit'
})
vim.api.nvim_set_keymap('n', '<Leader>z', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('snacks').zen.zen()
  end,
  desc = '开启/关闭Zen模式'
})
vim.api.nvim_set_keymap('n', '<Leader>st', '',
  { noremap = true, silent = true, callback = function() require('snacks').picker.grep() end, desc = '查找文本' })
vim.api.nvim_set_keymap('n', '<Leader>sf', '', {
  noremap = true,
  silent = true,
  callback = function()
    require("snacks").picker.files {
      hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat ".git" or {}, "type") == "directory",
    }
  end,
  desc = '查找文件'
})
vim.api.nvim_set_keymap('n', '<Leader>sb', '',
  { noremap = true, silent = true, callback = function() require("snacks").picker.buffers() end, desc = '查找缓冲区' })
vim.api.nvim_set_keymap('n', '<Leader>sp', '',
  { noremap = true, silent = true, callback = function() require('snacks').picker.colorschemes() end, desc = '查找配色方案' })
vim.api.nvim_set_keymap('n', '<Leader>sd', '',
  { noremap = true, silent = true, callback = function() require('snacks').picker.diagnostics() end, desc = '查找诊断信息' })
vim.api.nvim_set_keymap('n', '<Leader>sk', '',
  { noremap = true, silent = true, callback = function() require('snacks').picker.keymaps() end, desc = '查找快捷键' })
vim.api.nvim_set_keymap('n', '<Leader>si', '<cmd>IconPickerInsert<CR>', { noremap = true, silent = true, desc = '插入图标' })
vim.api.nvim_set_keymap('n', '<Leader>o', '<cmd>AerialOpen float<CR>', {
  noremap = true,
  silent = true,
  callback = function()
    local aerial_avail, aerial = pcall(require, "aerial")
    if aerial_avail and aerial.snacks_picker then
      aerial.snacks_picker()
    else
      require("snacks").picker.lsp_symbols()
    end
  end,
  desc = '打开符号列表'
})
vim.api.nvim_set_keymap('n', '<Leader>ti', '<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>',
  { noremap = true, silent = true, desc = '切换inlay_hint提示' })
vim.api.nvim_set_keymap('n', '<Leader>tt', '<cmd>TodoQuickFix<CR>', { noremap = true, silent = true })

-- DAP keymaps
vim.api.nvim_set_keymap('n', '<Leader>dt', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').toggle_breakpoint()
  end,
  desc = '切换调试'
})
vim.api.nvim_set_keymap('n', '<Leader>dc', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').continue()
  end,
  desc = '开始/继续调试'
})
vim.api.nvim_set_keymap('n', '<Leader>di', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').step_into()
  end,
  desc = 'Step Into'
})
vim.api.nvim_set_keymap('n', '<Leader>do', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').step_over()
  end,
  desc = 'Step Over'
})
vim.api.nvim_set_keymap('n', '<Leader>du', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dapui').toggle()
  end,
  desc = 'Toggle DAP UI'
})
vim.api.nvim_set_keymap('n', '<Leader>dr', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap.ui.widgets').hover()
  end,
  desc = 'Debug Hover'
})
vim.api.nvim_set_keymap('n', '<Leader>ds', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').repl.open()
  end,
  desc = 'Open DAP REPL'
})
vim.api.nvim_set_keymap('n', '<Leader>dE', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dapui').eval()
  end,
  desc = 'Evaluate Expression'
})
vim.api.nvim_set_keymap('n', '<Leader>dC', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').clear_breakpoints()
  end,
  desc = 'Clear Breakpoints'
})
vim.api.nvim_set_keymap('n', '<Leader>dq', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').close()
  end,
  desc = 'Close Session'
})
vim.api.nvim_set_keymap('n', '<Leader>dQ', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').terminate()
  end,
  desc = 'Terminate Session'
})
vim.api.nvim_set_keymap('n', '<Leader>dp', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').pause()
  end,
  desc = 'Pause Session'
})
vim.api.nvim_set_keymap('n', '<Leader>dS', '', {
  noremap = true,
  silent = true,
  callback = function()
    require('dap').run_to_cursor()
  end,
  desc = 'Run to Cursor'
})
