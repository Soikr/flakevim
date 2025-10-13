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
      local completion = null_ls.builtins.completion

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

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.diagnostic.config({
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

      -- Nix (nil) config

      vim.lsp.config("nil_ls", {
        capabilities = capabilities,
        cmd = { "nil" },
        settings = {
          ["nil"] = {
            nix = {
              binary = "nix",
              maxMemoryMB = nil,
              flake = {
                autoEvalInputs = false,
                autoArchive = false,
                nixpkgsInputName = nil,
              },
            },
            formatting = {
              command = { "nixfmt", "--quiet" },
            },
          },
        },
      })
      vim.lsp.enable("nil_ls")

      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            format = {
              enable = true,
            },
            runtime = {
              version = "LuaJIT",
            },
            telemetry = { enable = false },
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              disable = { "missing-fields" },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      vim.lsp.enable("lua_ls")

      vim.lsp.config("ccls", {
        capabilities = capabilities,
        cmd = { "ccls" },
      })

      vim.lsp.enable("ccls")

      vim.lsp.config("jsonls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("jsonls")
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
