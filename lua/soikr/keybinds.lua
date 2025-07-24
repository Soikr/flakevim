local function mkNoremap(mode, key, map, opts)
  local base_opts = { noremap = true, silent = true}

  opts = vim.tbl_extend("force", base_opts, opts or {})
  vim.keymap.set(mode, key, map, opts)
end

local function nnoremap(key, map, opts)
  mkNoremap("n", key, map, opts)
end

local function vnoremap(key, map, opts)
  mkNoremap("x", key, map, opts)
end

local function inoremap(key, map, opts)
  mkNoremap("i", key, map, opts)
end

local function onoremap(key, map, opts)
  mkNoremap("o", key, map, opts)
end

local function anoremap(key, map, opts)
  mkNoremap({ "n", "x", "o" }, key, map, opts)
end

function bufname(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    buffer = true,
    noremap = false,
    silent = true,
    desc = desc or ""
  })
end

inoremap("<Esc>", "<Esc>l")

nnoremap("p", "p`[v`]=")
nnoremap("P", "P`[v`]=")

nnoremap("U", "<C-r>")

nnoremap("!", "^")
vnoremap("!", "^")

nnoremap("<space><space>x", "<cmd>source %<CR>")
nnoremap("<space>x", ":.lua<CR>")
vnoremap("<space>x", ":lua<CR>")

nnoremap("bc", ":bdelete<CR>")
