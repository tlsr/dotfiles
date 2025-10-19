return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  { "mfussenegger/nvim-jdtls" },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

     -- local lspconfig = require("lspconfig")
     -- lspconfig.ts_ls.setup({
     --   capabilities = capabilities
     -- })
     -- lspconfig.solargraph.setup({
     --   capabilities = capabilities
     -- })
     -- lspconfig.html.setup({
     --   capabilities = capabilities
     -- })
     -- lspconfig.lua_ls.setup({
     --   capabilities = capabilities
     -- })
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('solargraph')
      vim.lsp.enable('html')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('pyright')
      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        ensure_installed = { "pyright" }
      }
     -- require("lspconfig").pyright.setup {
     -- }
    end,
  },
}
