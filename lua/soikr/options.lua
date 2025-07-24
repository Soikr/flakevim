vim.loader.enable()

local o = vim.o

o.backup = false
o.writebackup = false
o.undofile = true

o.mouse = "nva"
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

o.switchbuf = "useopen,usetab,newtab"

o.number = true
o.relativenumber = true
o.signcolumn = 'number'

o.cursorline = true
o.cursorlineopt = "both"

o.smoothscroll = true

o.expandtab = true
o.tabstop = 2
o.shiftwidth = 0

o.shiftround = true

o.breakindent = true

o.autoindent = true
o.cindent = true
o.smartindent = false

o.wrap = false

o.ignorecase = true
o.smartcase = true

o.showmode = false

o.laststatus = 3

o.formatoptions = "tcqjro/"

o.numberwidth = 1
o.textwidth = 80
