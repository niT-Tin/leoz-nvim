local M = {}

M.setup = function()
  M.config()
  local status_ok, tokyonight = pcall(require, "tokyonight")
  if not status_ok then
    return
  end
  tokyonight.setup(M.cfg)
end

M.config = function ()
  M.cfg = {
        on_highlights = function(hl, c)
          hl.IndentBlanklineContextChar = {
            fg = c.dark5,
          }
          hl.TSConstructor = {
            fg = c.blue1,
          }
          hl.TSTagDelimiter = {
            fg = c.dark5,
          }
        end,
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = {
          "qf",
          "vista_kind",
          "terminal",
          "packer",
          "spectre_panel",
          "NeogitStatus",
          "help",
        },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        use_background = true,
      }
end

return M
