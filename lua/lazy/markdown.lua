return {
  "render-markdown.nvim",
  before = function()
    LZN.trigger_load("nvim-treesitter")
    LZN.trigger_load("nvim-web-devicons")
  end,
  after = function()
    require("render-markdown").setup({
      completions = { blink = { enabled = true } },
    })
  end,
}
