local plugins = {
  -- AI
  -- { "github/copilot.vim" },
  {
    "zbirenbaum/copilot.lua",
    requires = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,  -- 交给 blink-copilot，关闭 inline ghost text
          auto_trigger = false,
          keymap = {
            accept = false,
          }
        },
        panel = { enabled = false },
      })
      vim.keymap.set("i", "<Tab>", function()
        if vim.snippet.active({ direction = 1 }) then
          vim.snippet.jump(1)
          return
        end
        local ok_ls, ls = pcall(require, "luasnip")
        if ok_ls and ls.jumpable(1) then
          ls.jump(1)
          return
        end
        return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
      end, { expr = true, desc = "snippet jump / tab" })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
  },

  -- LSP and CMP
  {
    "saghen/blink.cmp",
    version = "v1.*",
    dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets", "fang2hou/blink-copilot" },
    opts = function()
      local icons = require("leoz.icons").icons
      return {
        keymap = {
          preset = "none",
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide", "fallback" },
          -- ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          -- ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<CR>"] = { "accept", "fallback" },
          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },
        appearance = {
          kind_icons = icons.kind,
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "copilot" },
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-copilot",
              score_offset = 100,
              async = true,
              opts = {
                max_completions = 3,
                max_attempts = 4,
                debounce = 200,
                kind_icon = " ",
              },
            },
          },
        },
        cmdline = {
          sources = { "cmdline" },
        },
        completion = {
          menu = {
            border = "rounded",
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = { border = "rounded" },
          },
          ghost_text = { enabled = true },
        },
        signature = {
          enabled = true,
          window = { border = "rounded" },
        },
      }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    build = "make install_jsregexp",
  },
  { "neovim/nvim-lspconfig" },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = false,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  -- Record
  { "wakatime/vim-wakatime" },

  -- Functional
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  { "tpope/vim-repeat" },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      disabled_keys = {
        ["<Up>"] = false,
        ["<Down>"] = false,
        ["<Left>"] = false,
        ["<Right>"] = false,
      },
    },
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.comment").setup({})
      require("mini.align").setup({})
      require("mini.surround").setup({
        mappings = {
          add = "ys",
          delete = "ds",
          replace = "cs",
        },
      })
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "User FileOpened",
    config = function()
      require("leoz.config.illuminate").setup()
    end,
  },

  {
    "stevearc/aerial.nvim",
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require("ufo").setup({
        fold_virt_text_handler = require("leoz.config.ufo").handler,
      })
    end,
  },


  -- Telescope (仅保留给 telescope-emoji 使用)
  { "nvim-telescope/telescope.nvim",            lazy = true,    cmd = "Telescope" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("leoz.config.lualine").setup()
    end,
  },

  -- Visual
  { "nvim-tree/nvim-web-devicons" },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("leoz.config.bufferline").setup()
    end,
    event = "User FileOpened",
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("leoz.config.colorizer").config()
    end,
  },
  {
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    lazy = false,
    priority = 900,
    config = function()
      local highlight = { "RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
        "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet", "RainbowDelimiterCyan" }
      require("rainbow-delimiters.setup").setup({ highlight = highlight })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = function()
      -- 异步检测并安装 tree-sitter CLI（不阻塞启动）
      vim.schedule(function()
        if vim.fn.executable("tree-sitter") == 0 then
          local cargo_ok = vim.fn.executable("cargo") == 1
          local npm_ok = vim.fn.executable("npm") == 1
          if cargo_ok then
            vim.notify("tree-sitter CLI not found, installing via cargo...", vim.log.levels.INFO)
            vim.fn.jobstart({ "cargo", "install", "tree-sitter-cli" }, {
              stdout_buffered = true,
              on_exit = function(_, code)
                if code == 0 then
                  vim.notify("tree-sitter CLI installed, run :TSInstallSync to sync parsers", vim.log.levels.INFO)
                else
                  vim.notify("tree-sitter CLI install failed, run manually: cargo install tree-sitter-cli",
                    vim.log.levels.WARN)
                end
              end,
            })
          elseif npm_ok then
            vim.notify("tree-sitter CLI not found, installing via npm...", vim.log.levels.INFO)
            vim.fn.jobstart({ "npm", "install", "-g", "tree-sitter-cli" }, {
              stdout_buffered = true,
              on_exit = function(_, code)
                if code == 0 then
                  vim.notify("tree-sitter CLI installed, run :TSInstallSync to sync parsers", vim.log.levels.INFO)
                else
                  vim.notify("tree-sitter CLI install failed, run manually: npm install -g tree-sitter-cli",
                    vim.log.levels.WARN)
                end
              end,
            })
          else
            vim.notify("tree-sitter CLI missing, install cargo or npm first, then: cargo install tree-sitter-cli",
              vim.log.levels.WARN)
          end
        end
      end)
    end,
    config = function()
      require("nvim-treesitter").setup({
        highlight = { enable = true },
        indent = { enable = true },
        -- 新机器自动安装常用解析器（需要 tree-sitter CLI: cargo install tree-sitter-cli）
        auto_install = true,
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "go", "rust", "bash", "c", "cpp",
          "python", "javascript", "typescript", "html", "css",
          "json", "yaml", "toml", "markdown", "markdown_inline",
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup(require("leoz.config.todocomments").opt)
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    opts = {
      preset = "obsidian",
      heading = {
        position = "overlay",
        sign = true,
      },
      code = {
        sign = true,
        style = "full",
        border = "thin",
        position = "center",
        inline = true,
        inline_pad = 1,
        conceal_delimiters = true,
      },
      anti_conceal = {
        enabled = true,
      },
      render_modes = { "n", "c", "t" },
      completions = {
        lsp = { enabled = true },
      },
      latex = {
        enabled = true,
      },
      max_file_size = 10.0,
    },
  },

  -- Cursor
  { "mg979/vim-visual-multi" },
  { "easymotion/vim-easymotion" },


  -- Languages
  { "fatih/vim-go" },
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local ok, gitsign_cfg = pcall(require, "leoz.config.gitsign")
      if ok then
        require("gitsigns").setup(gitsign_cfg.gitsign_conf)
      end
    end,
  },
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "esmuellert/codediff.nvim",
      "m00qek/baleia.nvim",
      "folke/snacks.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
    },
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        graph_style = "kitty",
        log_date_format = "%Y-%m-%d %H:%M",
      })
    end
  },

  -- Themes
  { "sainnhe/everforest" },
  {
    "folke/tokyonight.nvim",
    config = function()
      require("leoz.config.tokyonight").setup()
    end,
  },
  { "catppuccin/nvim",           name = "catppuccin" },
  { "navarasu/onedark.nvim" },
  { "kepano/flexoki" },
  { "savq/melange-nvim" },
  -- { "ribru17/bamboo.nvim" },
  { "NTBBloodbath/doom-one.nvim" },
  {
    "sainnhe/sonokai",
    config = function()
      vim.g.sonokai_enable_italic = true
      vim.g.sonokai_better_performance = true
      vim.g.sonokai_style = "shusia"
    end,
  },
  {
    "hyperb1iss/silkcircuit",
    lazy = false,
    priority = 1000,
  },
  { "rebelot/kanagawa.nvim" },

  -- Emoji
  {
    "ziontee113/icon-picker.nvim",
    config = function()
      require("icon-picker").setup({
        disable_legacy_commands = true,
      })
    end,
  },
  {
    "xiyaowong/telescope-emoji.nvim",
    config = function()
      require("telescope").load_extension("emoji")
    end,
  },

  -- TOC
  { "mzlogin/vim-markdown-toc" },

  -- Snacks
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dashboard = { enabled = true },
      explorer = {
        replace_netrw = true,
      },
      indent = {
        indent = {
          char = "│",
        },
        scope = {
          enabled = true,
          char = "│",
          underline = true,
          hl = {
            "SnacksIndent1", "SnacksIndent2", "SnacksIndent3",
            "SnacksIndent4", "SnacksIndent5", "SnacksIndent6",
            "SnacksIndent7", "SnacksIndent8",
          },
        },
      },
      input = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            tree = true,
            hidden = false,
            layout = { preset = "sidebar" },
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = {
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = { open = false },
      },
      words = { enabled = true },
      styles = {
        input = {
          row = 3,
          relative = 'cursor',
        }
      }
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      views = {
        cmdline_popup = {
          position = { row = "85%", col = "50%" },
          size = { width = 60, height = "auto" },
          border = { style = "rounded", padding = { 0, 1 } },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup(require("leoz.config.nvimtreecontext"))
    end
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup(require("leoz.config.diagnostic"))
      vim.diagnostic.config({ virtual_text = false })
    end
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    config = function()
      require("crates").setup()
    end,
  },
  {
    "gbprod/yanky.nvim",
    opts = {
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 500,
      }
    },
    dependencies = { "folke/snacks.nvim" },
    keys = {
      {
        "<leader>p",
        function()
          Snacks.picker.yanky()
        end,
        mode = { "n", "x" },
        desc = "Open Yank History",
      },
    }
  },
  -- DAP
  {
    "mfussenegger/nvim-dap",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function(plugin, opts)
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
      dapui.setup(opts)
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value:gsub("%s+", " ")
          else
            return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
          end
        end,
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })
    end
  }
}

return plugins
