return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- LSPs básicos
      vim.lsp.config("lua_ls", {})
      vim.lsp.config("terraformls", {})
      vim.lsp.config("dockerls", {})
      vim.lsp.config("bashls", {})
      vim.lsp.config("pyright", {})

      -- YAML com schemas DevOps
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemas = {
              kubernetes = "*.yaml",
              ["https://json.schemastore.org/github-workflow.json"] =
                ".github/workflows/*",
              ["https://json.schemastore.org/github-action.json"] =
                ".github/action.{yml,yaml}",
            },
          },
        },
      })
    end,
  },
}

