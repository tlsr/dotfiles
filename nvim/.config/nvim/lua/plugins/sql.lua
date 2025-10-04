return {
  {
    "andev0x/sql-formatter.nvim",
    --ft = { "sql", "mysql", "plsql", "pgsql" },
    config = function()
     -- vim.g.sqlformat_command = "sqlformat"
     -- --vim.g.sqlformat_command = "sql-formatter"
     -- vim.g.sqlformat_options = "-r -k upper"
     -- vim.g.sqlformat_prog = "sqlformat"
      require("sql-formatter").setup({
        -- Core settings
        format_on_save = true,
        dialect = "postgresql",

        -- Indentation
        indent = "  ",
        tab_width = 2,
        use_tabs = false,

        -- Case formatting
        uppercase = true,
        identifier_case = "lower",
        function_case = "upper",
        datatype_case = "upper",

        -- Layout
        lines_between_queries = 2,
        max_column_length = 80,
        comma_start = false,
        operator_padding = true,

        -- File types
        filetypes = { "sql", "mysql", "plsql", "pgsql" },

        -- Key bindings
        keybindings = {
          format_buffer = "<leader>sf",
          format_selection = "<leader>ss",
          toggle_format_on_save = "<leader>st",
        },

        -- External formatter (choose one)
        external_formatter = {
          enabled = true,
         -- -- Use sql-formatter (Node.js):
         -- command = "sql-formatter",
         -- args = {},
          -- Or use sqlparse (Python):
          command = "sqlformat",
          args = { "--reindent", "--keywords", "upper", "--identifiers", "lower", "--strip-comments", "-" }
        },

        -- Notifications
        notify = {
          enabled = true,
          level = "info",
          timeout = 2000,
        },
      })
    end,
  },
}
