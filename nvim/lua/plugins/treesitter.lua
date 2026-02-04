return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "bash",
        "yaml",
        "json",
        "dockerfile",
        "hcl",
        "terraform",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}

