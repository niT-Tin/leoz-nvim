local M = {}

M.setup = function()
  if #vim.api.nvim_list_uis() == 0 then
    return
  end

  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
    vim.notify("lualine not available", vim.log.levels.ERROR)
    return
  end

  -- Load and merge styles
  local style_mod = require("leoz.lualine.styles")
  local lualine_cfg = style_mod.get_style("leoz")

  lualine.setup(lualine_cfg)
end

return M
