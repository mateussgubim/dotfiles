return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "vtsls",
          "eslint",
          "lua_ls",
          "terraformls",
          "dockerls",
          "bashls",
          "pyright",
          "yamlls",
        },
      })

      vim.lsp.config("lua_ls", {})
      vim.lsp.config("terraformls", {})
      vim.lsp.config("dockerls", {})
      vim.lsp.config("bashls", {})
      vim.lsp.config("pyright", {})

      vim.lsp.config("vtsls", {
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              variableTypes = { enabled = true },
            },
          },
        },
      })

      vim.lsp.config("eslint", {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemas = {
              kubernetes = "*.yaml",
              ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
              ["https://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
            },
          },
        },
      })
    end,
  },
}
