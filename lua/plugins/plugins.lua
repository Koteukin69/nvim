return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      require("config.dashboard").setup()
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = { theme = "tokyonight" },
      sections = {
        lualine_x = {
          require("config.keyboard_layout").component,
          "encoding",
          "fileformat",
          "filetype",
        },
      },
    },
    config = function(_, opts)
      require("config.keyboard_layout").setup()
      require("lualine").setup(opts)
    end,
  },

  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {},
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeOpen", "NvimTreeClose" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus file tree" },
    },
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "C", api.tree.change_root_to_node, {
          buffer = bufnr,
          desc = "CD",
          noremap = true,
          silent = true,
          nowait = true,
        })

        vim.keymap.set("n", "<Space>", api.node.open.edit, {
          buffer = bufnr,
          desc = "Open",
          noremap = true,
          silent = true,
          nowait = true,
        })
      end,
      view = { width = 35 },
      renderer = { group_empty = true },
      filters = {
        dotfiles = false,
        custom = require("config.ignore").nvim_tree,
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      if vim.fn.argc() == 0 then
        vim.schedule(function()
          require("nvim-tree.api").tree.open()
          vim.cmd("wincmd p")
        end)
      end
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "json", "yaml",
        "markdown", "markdown_inline", "python", "javascript",
        "typescript", "tsx", "html", "css", "c_sharp",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files({ previewer = false }) end, desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    },
    config = function()
      local previewers = require("telescope.previewers")
      local buffer_previewer_maker = previewers.buffer_previewer_maker

      require("telescope").setup({
        defaults = {
          buffer_previewer_maker = function(filepath, bufnr, opts)
            opts = opts or {}
            opts.preview = opts.preview or {}
            opts.preview.treesitter = false
            return buffer_previewer_maker(filepath, bufnr, opts)
          end,
        },
        pickers = {
          find_files = {
            previewer = false,
          },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon add" },
      { "<leader>h", function()
          local h = require("harpoon")
          h.ui:toggle_quick_menu(h:list())
        end, desc = "Harpoon menu" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
    },
    opts = {},
  },
  {
    "williamboman/mason.nvim",
    version = "v1.11.0",
    cmd = "Mason",
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "csharpier",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    version = "v1.32.0",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = false,
      ensure_installed = {
        "lua_ls",
        "pyright",
        "vtsls",
        "eslint",
        "html",
        "cssls",
        "emmet_ls",
        "tailwindcss",
        "omnisharp",
        "bashls",
        "jsonls",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    version = "v2.5.0",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
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
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        cs = { "csharpier" },
        lua = { "stylua" },
        python = { "ruff_format" },
      },
      format_on_save = function(bufnr)
        local disable_filetypes = {}
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return
        end

        return {
          timeout_ms = 2000,
          lsp_format = "fallback",
        }
      end,
    },
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "ruff" },
        sh = { "shellcheck" },
        markdown = { "markdownlint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, opts = {} },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, event = { "BufReadPost", "BufNewFile" }, opts = {} },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
      },
    },
    keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = "n" } },
    opts = {
      pre_hook = function(...)
        return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(...)
      end,
    },
  },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  { "folke/persistence.nvim", event = "BufReadPre", opts = {} },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
      { "<C-Space>", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
      { "<Nul>", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
    },
    opts = { direction = "float", open_mapping = [[<C-Space>]] },
  },
}