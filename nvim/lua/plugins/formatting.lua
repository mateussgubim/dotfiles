return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- Run before saving
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      lua = { "stylua" },
      python = { "isort", "black" },
    },
    -- This is where the magic happens:
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    },
  },
}
