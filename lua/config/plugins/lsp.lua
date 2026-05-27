local M = {}

function M.setup()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      local opts = { buffer = event.buf, silent = true }

      if client and vim.tbl_contains({ "vtsls", "eslint", "omnisharp" }, client.name) then
        client.server_capabilities.documentFormattingProvider = false
      end

      if client and client.name == "omnisharp" then
        client.server_capabilities.semanticTokensProvider = nil
      end

      vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP rename" }))
      vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP definition" }))
      vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP references" }))
      vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP hover" }))
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP implementation" }))
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "LSP type definition" }))
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP code action" }))
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      end
    end,
  })

  local js_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  }

  local servers = {
    pyright = {},
    bashls = {},
    jsonls = {},
    html = {},
    cssls = {},
    tailwindcss = {},
    emmet_ls = {
      filetypes = {
        "html",
        "css",
        "scss",
        "javascriptreact",
        "typescriptreact",
      },
    },
    eslint = {
      filetypes = js_filetypes,
      settings = {
        workingDirectory = { mode = "auto" },
        format = false,
      },
    },
    vtsls = {
      filetypes = js_filetypes,
      settings = {
        vtsls = {
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          preferences = {
            importModuleSpecifier = "non-relative",
            includePackageJsonAutoImports = "auto",
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
        javascript = {
          preferences = {
            importModuleSpecifier = "non-relative",
            includePackageJsonAutoImports = "auto",
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    },
    omnisharp = {
      cmd = {
        vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp",
      },
      on_init = function(client)
        client.server_capabilities.semanticTokensProvider = nil
      end,
      root_dir = function(fname)
        return util.root_pattern("*.sln", "*.csproj", "omnisharp.json")(fname)
          or util.root_pattern("Assets", "Packages", "ProjectSettings")(fname)
      end,
      settings = {
        FormattingOptions = {
          EnableEditorConfigSupport = true,
          OrganizeImports = true,
        },
        MsBuild = {
          LoadProjectsOnDemand = false,
        },
        RoslynExtensionsOptions = {
          EnableAnalyzersSupport = true,
          EnableImportCompletion = true,
          AnalyzeOpenDocumentsOnly = true,
        },
        Sdk = {
          IncludePrereleases = true,
        },
      },
    },
  }

  for server, config in pairs(servers) do
    local server_capabilities = capabilities

    if server == "omnisharp" then
      server_capabilities = vim.deepcopy(capabilities)
      if server_capabilities.textDocument then
        server_capabilities.textDocument.semanticTokens = nil
      end
    end

    lspconfig[server].setup(vim.tbl_deep_extend("force", {
      capabilities = server_capabilities,
    }, config))
  end

  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    },
  })
end

return M
