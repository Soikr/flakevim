return {
  {
    "none-ls.nvim",
  },
  {
    "fidget.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("fidget").setup({})
    end,
  },
  {
    "nvim-lspconfig",
    lazy = false,
    before = function()
      LZN.trigger_load("none-ls")
      LZN.trigger_load("blink.cmp")
    end,
    after = function()
      vim.cmd.packadd("none-ls.nvim")
      local null_ls = require("null-ls")

      local code_actions = null_ls.builtins.code_actions
      local diagnostics = null_ls.builtins.diagnostics
      local formatting = null_ls.builtins.formatting

      local ls_sources = {
        formatting.stylua,
        diagnostics.statix,
        code_actions.statix,
        diagnostics.deadnix,
      }

      null_ls.setup({
        diagnostics_format = "[#{m}] #{s} (#{c})",
        debounce = 250,
        default_timeout = 5000,
        sources = ls_sources,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.diagnostic.config({
        float = { border = "single" },
        update_in_insert = true,
        virtual_text = false,
        virtual_lines = { enable = true, current_line = true },
        underline = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
          },
          numhl = {
            [vim.diagnostic.severity.WARN] = "WarningMsg",
          },
        },
      })

      local servers = {
        nil_ls = {
          auto_start = true,
          settings = {
            ["nil"] = {
              formatting = {
                command = { "alejandra", "--quiet" },
              },
              nix = {
                maxMemoryMB = nil,
                flake = {
                  autoEvalInputs = false,
                  autoArchive = false,
                  nixpkgsInputName = nil,
                },
              },
            },
          },
        },
        lua_ls = {
          auto_start = true,
          settings = {
            Lua = {
              format = {
                enable = true,
              },
              runtime = {
                version = "LuaJIT",
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
              },
              workspace = {
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              imports = {
                granularity = {
                  group = "module",
                },
              },
              cargo = {
                buildScripts = {
                  enable = true,
                },
              },
              files = {
                excludeDirs = { ".direnv" },
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
        sourcekit = {},
        pyright = {},
      }
      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        lspconfig[name].setup(server)
      end
    end,

    keys = {
      { "gD",         vim.lsp.buf.declaration,             desc = "Go to declaration" },
      { "gd",         vim.lsp.buf.definition,              desc = "Go to definition" },
      { "K",          vim.lsp.buf.hover,                   desc = "Hover documentation" },
      { "gi",         vim.lsp.buf.implementation,          desc = "Go to implementation" },
      { "<C-k>",      vim.lsp.buf.signature_help,          desc = "Signature help" },
      { "<leader>wa", vim.lsp.buf.add_workspace_folder,    desc = "Add workspace folder" },
      { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
      {
        "<leader>wl",
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        desc = "List workspace folders",
      },
      { "<leader>D",  vim.lsp.buf.type_definition, desc = "Type definition" },
      { "<leader>rn", vim.lsp.buf.rename,          desc = "Rename symbol" },
      { "<leader>ca", vim.lsp.buf.code_action,     desc = "Code action" },
      { "<leader>e",  vim.diagnostic.open_float,   desc = "Open diagnostic float" },
      { "gr",         vim.lsp.buf.references,      desc = "Go to references" },
      {
        "<leader>f",
        function()
          vim.lsp.buf.format({ async = true })
        end,
        desc = "Format buffer",
      },
    },
  },
  {
    "crates.nvim",
    event = "BufEnter Cargo.toml",
    before = function()
      LZN.trigger_load("nvim-lspconfig")
    end,
    after = function()
      require("crates").setup({
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      })
    end,
  },
}
