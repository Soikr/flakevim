return {
  { "telescope-file-browser.nvim" },
  {
    "telescope.nvim",
    cmd = "Telescope",
    after = function()
      local telescope = require("telescope")
      local fb_actions = telescope.extensions.file_browser.actions


      telescope.setup {
        defaults = {
          mappings = {
            ["i"] = {
              ["<Esc>"] = "close",
            },
          },
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                ["<C-a>"] = fb_actions.create,
                ["<C-r>"] = fb_actions.rename,
                ["<C-c>"] = fb_actions.move,
              },
            },
          },
        },
      }
      telescope.load_extension("file_browser")
    end,
    keys = {
      {
        "<leader>tg",
        function()
          require("telescope.builtin").live_grep()
        end,
      },
      {
        "<C-e>",
        function()
          require("telescope").extensions.file_browser.file_browser({
            cwd = vim.fn.expand("%:p:h"),
          })
        end,
      },
    },
  },
}
