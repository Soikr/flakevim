return {
  "aerial.nvim",
  before = function()
    LZN.trigger_load("nvim-treesitter")
    LZN.trigger_load("nvim-web-devicons")
  end,
  after = function()
    require("aerial").setup({
      show_guides = true,
    })
  end,
  keys = {
    { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "[A]erial toggle",    mode = "n" },
    { "{",         "<cmd>AerialPrev<CR>",    desc = "prev aerial symbol", mode = { "n", "v" } },
    { "}",         "<cmd>AerialNext<CR>",    desc = "next aerial symbol", mode = { "n", "v" } },
  },
}
