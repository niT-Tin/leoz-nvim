# leoz-nvim

Personal Neovim configuration powered by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Daily Pictures

### DashBoard

![dashboard](./images/dashboard.png)

### Explorer

![explorer](./images/explorer.png)

### Markdown-render

![Markdown-render](./images/markdown-render.png)

### Neogit

![neogit](./images/neogit.png)

### Symbols List

![symbols](./images/symbols.png)

### Text Search

![test-search](./images/text-search.png)


### Toggle-Term

![toggle-term](./images/toggle-term.png)

### And More...

**Tree-sitter** — Syntax highlighting with auto-install for lua, go, rust, python, c/c++, js/ts, html/css, toml, yaml, json, markdown. Requires `cargo` or `npm` for the tree-sitter CLI (auto-installed on first launch).

**Rainbow Delimiters** — Each bracket pair gets a distinct color; deeply nested code becomes instantly readable.

**Inline Diagnostics** — tiny-inline-diagnostic shows errors/warnings right on the line where they occur, no virtual text clutter.

**DAP Debugging** — Full debug adapter protocol support via nvim-dap + nvim-dap-ui: breakpoints, step through, watch variables, REPL, all inside Neovim.

**EasyMotion** — Jump to any visible character in 2-3 keystrokes. `s` triggers single-window search, `<Leader>f` searches across all open windows.

**Code Folding** — nvim-ufo provides modern, performant fold with virtual text showing the folded content preview.

**Yank History** — yanky.nvim keeps a ring-buffer clipboard; `<Leader>p` opens a picker to browse and paste any previous yank.

**Todo Comments** — TODO, FIXME, HACK, NOTE, PERF, WARNING keywords are highlighted and searchable via `<Leader>tt`.

**Git Signs** — gitsigns shows added/modified/removed lines in the sign column, with inline blame and hunk staging.

**Color Preview** — nvim-colorizer highlights hex/rgb/hsl codes inline with their actual color.

**Cursor Word HL** — vim-illuminate highlights all occurrences of the word under cursor across the buffer.

**Rust Crates** — crates.nvim shows the latest version and out-of-date warnings inline in `Cargo.toml`.

## Keybindings

Leader key is `<Space>`.

| Key | Description |
|-----|-------------|
| `jk` | Escape (insert mode) |
| `<Leader>h` | Clear search highlight |
| `<Leader>e` | Toggle file explorer |
| `<Leader>E` | Reveal file in explorer |
| `<Leader>sf` | Find file |
| `<Leader>sb` | Find buffer |
| `<Leader>st` | Grep/search text |
| `<Leader>sd` | Find diagnostics |
| `<Leader>sp` | Pick colorscheme |
| `<Leader>sk` | Find keymap |
| `<Leader>si` | Insert icon |
| `<Leader>o` | Symbol outline (aerial) |
| `<Leader>ti` | Toggle LSP inlay hints |
| `<Leader>tt` | Todo quickfix list |
| `<Leader>gg` | Neogit |
| `<Leader>lg` | LazyGit |
| `<Leader>z` | Zen mode |
| `<Leader>p` | Yank history picker |
| `<Leader>Lc` | Edit nvim config |
| `s` | EasyMotion jump |
| `<Leader>f` | EasyMotion cross-window jump |
| `<M-r>` | Floating terminal |
| `<M-w>` | Bottom terminal |
| `<M-e>` | Right terminal |
| `<Leader>dt` | Toggle breakpoint |
| `<Leader>dc` | Start/continue debug |
| `<Leader>di` | Step into |
| `<Leader>do` | Step over |
| `<Leader>du` | Toggle DAP UI |

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

- Neovim >= 0.12
- Git, curl or wget
- LSP servers (installed via mason.nvim automatically)
- tree-sitter CLI (auto-installed via cargo/npm on first launch)

## Installation

```bash
git clone https://github.com/niT-Tin/leoz-nvim.git ~/.config/nvim
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
