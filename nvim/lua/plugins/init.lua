-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins.themes.no-clown-fiesta" },
  { import = "plugins.treesitter" },
  { import = "plugins.mason" },
  { import = "plugins.lsp" },
  { import = "plugins.telescope" },
  { import = "plugins.git" },
  { import = "plugins.neotree" },
  { import = "plugins.lualine" },
  { import = "plugins.cmp" },
})
