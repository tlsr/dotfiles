-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g._ts_force_sync_parsing = true
--require('vim._extui').enable({
-- enable = true, -- Whether to enable or disable the UI.
-- msg = { -- Options related to the message module.
--   ---@type 'box'|'cmd' Type of window used to place messages, either in the
--   ---cmdline or in a separate message box window with ephemeral messages.
--   pos = 'cmd',
--   box = { -- Options related to the message box window.
--     timeout = 4000, -- Time a message is visible.
--   },
-- },
--})

-- Setup lazy.nvim
require("lazy").setup("plugins")
