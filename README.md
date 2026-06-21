# leoz-nvim

Personal Neovim configuration powered by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Structure

```
init.lua               # Entry point, bootstraps lazy.nvim
lua/leoz/
  plugins/init.lua     # Plugin specs
  config/              # Per-plugin configuration
  lsp/                 # LSP server setup (gopls, rust-analyzer, lua-ls, clangd, etc.)
  lualine/             # Status line components and styles
  themes.lua           # Theme switching
  icons.lua            # Icon definitions
  utils/               # Shared utilities
  optvars/             # vim.opt settings
```

## Prerequisites

- Neovim >= 0.10
- Git, curl or wget
- LSP servers (installed via mason.nvim automatically)
- tree-sitter CLI (auto-installed via cargo/npm on first launch)

## Installation

```bash
git clone https://github.com/leozh/leoz-nvim.git ~/.config/nvim
nvim
```

## Plugins

| Category | Highlights |
|----------|-----------|
| Completion | blink.cmp + blink-copilot |
| AI | Copilot.lua, CopilotChat.nvim |
| LSP | nvim-lspconfig, mason.nvim, crates.nvim |
| Treesitter | nvim-treesitter, nvim-treesitter-context |
| UI | bufferline, lualine, noice, snacks, tokyonight |
| Navigation | aerial, nvim-ufo, vim-easymotion |
| Git | gitsigns, neogit |
| DAP | nvim-dap, nvim-dap-ui |
| Languages | vim-go, rustaceanvim |
| Editing | nvim-autopairs, mini.nvim, hardtime, yanky |
