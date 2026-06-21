local M = {}

M.definitions = {
  {
    { "BufRead", "BufWinEnter", "BufNewFile" },
    {
      group = "_file_opened",
      nested = true,
      callback = function(args)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
        if not (vim.fn.expand "%" == "" or buftype == "nofile") then
          vim.api.nvim_del_augroup_by_name "_file_opened"
          vim.api.nvim_exec_autocmds("User", { pattern = "FileOpened" })
          require("leoz.lsp").lsp_setup()
        end
      end,
    },
  },
  {
    "ColorScheme",
    {
      group = "_leoz_colorscheme",
      callback = function()
        -- dropbar.nvim 自动管理 winbar
        local statusline_hl = vim.api.nvim_get_hl_by_name("StatusLine", true)
        local cursorline_hl = vim.api.nvim_get_hl_by_name("CursorLine", true)
        local normal_hl = vim.api.nvim_get_hl_by_name("Normal", true)
        vim.api.nvim_set_hl(0, "RainbowDelimiterRed",    { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterBlue",   { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterGreen",  { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterCyan",   { fg = "#56B6C2" })
        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
        vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
        vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })
        vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
        vim.api.nvim_set_hl(0, "SLCopilot", { fg = "#6CC644", bg = statusline_hl.background })
        vim.api.nvim_set_hl(0, "SLGitIcon", { fg = "#E8AB53", bg = cursorline_hl.background })
        vim.api.nvim_set_hl(0, "SLBranchName", { fg = normal_hl.foreground, bg = cursorline_hl.background })
        vim.api.nvim_set_hl(0, "SLSeparator", { fg = cursorline_hl.background, bg = statusline_hl.background })
      end,
    },
  },
}

define_autocmds(M.definitions)

return M
