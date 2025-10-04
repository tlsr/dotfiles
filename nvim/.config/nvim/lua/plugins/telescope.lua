-- new 
local M = {}

M.get_path_and_tail = function(filename)
  local utils = require('telescope.utils')
  local bufname_tail = utils.path_tail(filename)
  local path_without_tail = require('plenary.strings').truncate(filename, #filename - #bufname_tail, '')
  local path_to_display = utils.transform_path({
    path_display = { 'truncate' },
  }, path_without_tail)

  return bufname_tail, path_to_display
end
-- new
return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      { "nvim-lua/plenary.nvim"},
      {
        "nvim-telescope/telescope-live-grep-args.nvim" ,
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
      {
        "aaronhallaert/advanced-git-search.nvim",
      },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        pickers = {
          find_files = {
            hidden = true
          }
        },
      })
      --- //////// item stylish.
      opts = opts or {}
      local make_entry = require('telescope.make_entry')
      local entry_make = make_entry.gen_from_file(opts)
      opts.entry_maker = function(line)
        local entry = entry_make(line)
        local displayer = entry_display.create({
          separator = ' ',
          items = {
            { width = iconwidth },
            { width = nil },
            { remaining = true },
          },
        })
        entry.display = function(et)
          -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/make_entry.lua
          local tail_raw, path_to_display = M.get_path_and_tail(et.value)
          local tail = tail_raw .. ' '
          local icon, iconhl = utils.get_devicons(tail_raw)

          return displayer({
            { icon, iconhl },
            tail,
            { path_to_display, 'TelescopeResultsComment' },
          })
        end
        return entry
      end
      ---/// end item stylish:

      local builtin = require("telescope.builtin")
      function git_status_advanced()

        local function get_git_root()
          local dot_git_path = vim.fn.finddir(".git", ".;")
          local full_path = vim.fn.fnamemodify(dot_git_path, ":p")
          return full_path:sub(1,-6)
        end

        local opts = {
          cwd = get_git_root(),
        }

        builtin.git_status(opts)
      end

      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set(
        "n",
        "<leader>fg",
        "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
        { desc = "Live Grep" }
      )
      --vim.keymap.set("n", "<leader>fs", builtin.git_status, {})
      vim.keymap.set("n", "<leader>fs", git_status_advanced, {})
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
      vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Telescope find marks' })
      vim.keymap.set("n", "<leader>fi", "<cmd>AdvancedGitSearch<CR>", { desc = "AdvancedGitSearch" })
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function(args)
          vim.wo.wrap = true
        end,
      })
--      vim.keymap.set("n", "<leader>/", function()
--        -- You can pass additional configuration to telescope to change theme, layout, etc.
--        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
--          winblend = 10,
--          previewer = false,
--          layout_config = { width = 0.7 },
--        }))
--      end, { desc = "[/] Fuzzily search in current buffer" })
      --
      --

      -- https://github.com/nvim-telescope/telescope.nvim/issues/609
    --  local previewers = require('telescope.previewers')
    --  local delta_bcommits = previewers.new_termopen_previewer {
    --    get_command = function(entry)
    --      return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!', '--', entry.current_file }
    --    end
    --  }

    --  M.my_git_bcommits = function(opts)
    --    opts = opts or {}
    --    opts.previewer = {
    --      delta_bcommits,
    --      previewers.git_commit_message.new(opts),
    --      previewers.git_commit_diff_as_was.new(opts),
    --    }

    --    builtin.git_bcommits(opts)
    --  end

      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "[/] Fuzzily search in current buffer" })
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("advanced_git_search")
      --require('telescope').load_extension('attempt')
      require('telescope').load_extension 'attempt'
    end,
  },
}

