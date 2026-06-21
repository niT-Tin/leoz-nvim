local M = {}
require('leoz.utils')

local servers = require('leoz.lsp.servers')

M.lsp_servers = servers.lsp_servers
M.skipped_servers = servers.skipped_servers
M.skipped_filetypes = servers.skipped_filetypes

M.lsp_config = {
  templates_dir = join_paths(vim.call("stdpath", "data"), "site", "after", "ftplugin"),
  diagnostics = {},
  document_highlight = false,
  code_lens_refresh = true,
  on_attach_callback = nil,
  on_init_callback = nil,
  automatic_configuration = {
    skipped_servers = M.skipped_servers,
    skipped_filetypes = M.skipped_filetypes,
  },
  buffer_mappings = {
    normal_mode = {
      ["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      ["<leader>lf"] = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format File" },
      ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover" },
      ["gd"] = { "<cmd>lua require('snacks').picker.lsp_definitions()<cr>", "Goto definition" },
      ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto Declaration" },
      ["gr"] = { "<cmd>lua require('snacks').picker.lsp_references()<cr>", nowait = true, desc = "Goto references" },
      ["gI"] = { "<cmd>lua require('snacks').picker.lsp_implementations()<cr>", "Goto Implementation" },
      ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "show signature help" },
      ["gl"] = {
        function()
          local float = vim.diagnostic.config().float

          if float then
            local config = type(float) == "table" and float or {}
            config.scope = "line"

            vim.diagnostic.open_float(config)
          end
        end,
        "Show line diagnostics",
      },
    },
    insert_mode = {},
    visual_mode = {},
  },
  buffer_options = {
    omnifunc = "v:lua.vim.lsp.omnifunc",
    formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})",
  },
  installer = {
    setup = {
      ensure_installed = {},
      automatic_installation = {
        exclude = {},
      },
    },
  },
  nlsp_settings = {
    setup = {
      config_home = join_paths(vim.call("stdpath", "config"), "lsp-settings"),
      append_default_schemas = true,
      ignored_servers = {},
      loader = "json",
    },
  },
  override = {},
  automatic_servers_installation = nil,
}

function M.setup_document_symbols(client, bufnr)
  -- dropbar.nvim 自动处理 LSP 符号
end

local function add_lsp_buffer_keybindings(bufnr)
  local mappings = {
    normal_mode = "n",
    insert_mode = "i",
    visual_mode = "v",
  }

  for mode_name, mode_char in pairs(mappings) do
    for key, remap in pairs(M.lsp_config.buffer_mappings[mode_name]) do
      local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
      vim.keymap.set(mode_char, key, remap[1], opts)
    end
  end
end

local function add_lsp_buffer_options(bufnr)
  for k, v in pairs(M.lsp_config.buffer_options) do
    vim.api.nvim_buf_set_option(bufnr, k, v)
  end
end

M.common_on_attach = function(client, bufnr)
  if M.lsp_config.document_highlight then
    M.setup_document_highlight(client, bufnr)
  end
  if M.lsp_config.code_lens_refresh then
    M.setup_codelens_refresh(client, bufnr)
  end
  if M.lsp_config.on_attach_callback then
    M.lsp_config.on_attach_callback(client, bufnr)
  end
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = bufnr })
  end
  add_lsp_buffer_keybindings(bufnr)
  add_lsp_buffer_options(bufnr)
  M.setup_document_symbols(client, bufnr)
end

function M.common_on_exit(_, _)
  if M.lsp_config.document_highlight then
    clear_augroup "lsp_document_highlight"
  end
  if M.lsp_config.code_lens_refresh then
    clear_augroup "lsp_code_lens_refresh"
  end
end

M.buf_try_add = function(server_name, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  require("lspconfig")[server_name].manager:try_add_wrapper(bufnr)
end

function M.setup_document_highlight(client, bufnr)
  local status_ok, highlight_supported = pcall(function()
    return client.supports_method "textDocument/documentHighlight"
  end)
  if not status_ok or not highlight_supported then
    return
  end
  local group = "lsp_document_highlight"
  local hl_events = { "CursorHold", "CursorHoldI" }

  local ok, hl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group,
    buffer = bufnr,
    event = hl_events,
  })

  if ok and #hl_autocmds > 0 then
    return
  end

  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(hl_events, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

function M.setup_codelens_refresh(client, bufnr)
  local status_ok, codelens_supported = pcall(function()
    return client.supports_method "textDocument/codeLens"
  end)
  if not status_ok or not codelens_supported then
    return
  end
  local group = "lsp_code_lens_refresh"
  local cl_events = { "BufEnter", "InsertLeave" }
  local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group,
    buffer = bufnr,
    event = cl_events,
  })

  if ok and #cl_autocmds > 0 then
    return
  end
  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(cl_events, {
    group = group,
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end,
  })
end

function M.common_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  return capabilities
end

return M
