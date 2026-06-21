local M = {}
local fcs = require('leoz.lsp.lspfuncs')


--@param server_name string
--@return table
local function setup_hint(server_name)
  if server_name == "lua_ls" then
    return {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        hint = {
          enable = true,
        },
      },
    }
  elseif server_name == "gopls" then
    return {
      gopls = {
        ["ui.inlayhint.hints"] = {
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          parameterNames = true,
          assignVariablesTypes = true,
          functionTypeParameters = true,
          rangeVariableTypes = true
        }
      }
    }
  elseif server_name == "rust_analyzer" then
    return {
      rust_analyzer = {
        hint = {
          enable = true
        }
      }
    }
  elseif server_name == "pylsp" then
    return {
      pylsp = {
        hint = {
          enable = true
        }
      }
    }
  elseif server_name == "clangd" then
    return {
      clangd = {
        InlayHints = {
          Designators = true,
          Enabled = true,
          ParameterNames = true,
          DeducedTypes = true,
        },
      },
    }
  elseif server_name == "ts_ls" or server_name == "tsserver" then
    return {
      tsserver = {
        inlayHints = {
          parameterNames = true,
          variableTypes = true,
          propertyDeclarationTypes = true,
          functionLikeReturnTypes = true,
          enumMemberValues = true,
          includeInlayEnumMemberValueHints = true,
        },
      }
    }
  else
    return {}
  end
end

M.lsp_setup = function()
  for _, lsp_name in pairs(fcs.lsp_servers) do
    local settings = {}
    if lsp_name == "gopls" or lsp_name == "lua_ls" or lsp_name == "pylsp" or lsp_name == "ts_ls" or lsp_name == "jsonls" or lsp_name == "clangd" or lsp_name == "zls" then
      settings = vim.tbl_deep_extend("force", settings, setup_hint(lsp_name))
      vim.lsp.config(lsp_name, {
        on_attach = fcs.common_on_attach,
        settings = settings,
        capabilities = fcs.common_capabilities(),
        on_exit = fcs.common_on_exit,
      })
      vim.lsp.enable(lsp_name)
    end
  end
  -- local mason_lspconfig = require('mason-lspconfig')
  -- mason.setup()
  -- mason_lspconfig.setup()
  -- mason_lspconfig.setup_handlers({
  --   function(server_name)
  --     -- TODO: 优化这一部分逻辑
  --     -- 因为rust_analyzer和rustacevim.mason有冲突，这里不setup rust_analyzer
  --     -- if server_name == "rust_analyzer" then
  --     --   return
  --     -- end
  --     local settings = {}
  --     settings = setup_hint(server_name)
  --     lspconfig[server_name].setup({
  --       settings = settings,
  --       on_attach = fcs.common_on_attach,
  --       capabilities = fcs.common_capabilities(),
  --       on_exit = fcs.common_on_exit,
  --     })
  --     fcs.buf_try_add(server_name)
  --   end
  -- })
  -- vim.lsp.config['gopls'].settings = setup_hint('gopls')
  -- vim.lsp.config['lua_ls'].settings = setup_hint('lua_ls')
  local function set_handler_opts_if_not_set(name, handler, opts)
    if debug.getinfo(vim.lsp.handlers[name], "S").source:find(vim.env.VIMRUNTIME, 1, true) then
      vim.lsp.handlers[name] = vim.lsp.with(handler, opts)
    end
  end

  set_handler_opts_if_not_set("textDocument/hover", vim.lsp.handlers.hover, { border = "rounded" })
  set_handler_opts_if_not_set("textDocument/signatureHelp", vim.lsp.handlers.signature_help, { border = "rounded" })
  -- Enable rounded borders in :LspInfo window.
  require("lspconfig.ui.windows").default_options.border = "rounded"
end

return M
