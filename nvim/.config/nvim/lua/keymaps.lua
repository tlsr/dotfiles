-- space bar leader key
vim.g.mapleader = " "
local map = vim.keymap.set

map("n", "<c-k>", ":wincmd k<CR>", { silent = true })
map("n", "<c-j>", ":wincmd j<CR>", { silent = true })
map("n", "<c-h>", ":wincmd h<CR>", { silent = true })
map("n", "<c-l>", ":wincmd l<CR>", { silent = true })
-- yank to clipboard
map({"n", "v"}, "<leader>y", [["+y]])
-- yank line to clipboard
map("n", "<leader>Y", [["+Y]])

-- paste from clipboard
--map({"n", "v"}, "<leader>p", [["+P]])A
-- greatest remap ever
-- replace
map("x", "<leader>p", [["_dP]])
-- paste from clipboard
map("n", "<leader>P", [["+p]])

-- lsp 

map("n", "K", vim.lsp.buf.hover, {})
map("n", "<leader>gd", vim.lsp.buf.definition, {})
map('n', '<leader>gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "<leader>gds", vim.lsp.buf.document_symbol, {})
map("n", "<leader>gws", vim.lsp.buf.workspace_symbol, {})
map("n", "<leader>ca", vim.lsp.buf.code_action, {})
map("n", "<leader>cl", vim.lsp.codelens.run, {})
map("n", "<leader>cp", vim.lsp.buf.signature_help, {})
map("n", "<leader>rn", vim.lsp.buf.rename, {})
map("n", "<leader>wd", vim.diagnostic.setqflist, {})
map("n", "[d", vim.diagnostic.goto_prev, {})
map("n", "]d", vim.diagnostic.goto_next, {})
map("n", "<leader>ws", function() require("metals").hover_worksheet() end, {})
map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List workspace folders" })
map('n', '<space>D', vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map('v', "<space>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
    { noremap=true, silent=true, buffer=bufnr, desc = "Code actions" })
map('n', '<space>f', function() vim.lsp.buf.format { async = true } end, { desc = "Format file" })



local builtin = require("telescope.builtin")
map('n', '<leader>gi', builtin.lsp_implementations, { desc = 'Telescope Find Implementations' })
map('n', '<leader>gr', builtin.lsp_references, { desc = 'Telescope Find Implementations' })
map('n', '<leader>d', builtin.diagnostics, { desc = 'Telescope Find Implementations' })
map('n', '<leader>fw', builtin.current_buffer_fuzzy_find, { desc = 'Telescope current buffer fuzzy find' })
map('n', '<leader>de', function() builtin.diagnostics({severity = "Error"}) end, { desc = 'Telescope Find Errors'})
map('n', '<leader>lm', function() builtin.lsp_document_symbols({symbols = "method"}) end, { desc = 'Telescope LSP Document Methods'})


local gitsigns = require("gitsigns")
map('n', '<leader>hs', gitsigns.stage_hunk, {})
map('n', '<leader>hr', gitsigns.reset_hunk, {})
map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {})
map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {})
map('n', '<leader>hS', gitsigns.stage_buffer, {})
map('n', '<leader>hu', gitsigns.undo_stage_hunk, {})
map('n', '<leader>hR', gitsigns.reset_buffer, {})
map('n', '<leader>hp', gitsigns.preview_hunk, {})
map('n', '<leader>hj', gitsigns.nav_hunk, {})
map('n', '<leader>hB', function() gitsigns.blame_line{full=true} end, {})
map('n', '<leader>hb', gitsigns.blame, {})
map('n', '<leader>tb', gitsigns.toggle_current_line_blame, {})
map('n', '<leader>hd', gitsigns.diffthis, {})
map('n', '<leader>hD', function() gitsigns.diffthis('~') end, {})
map('n', '<leader>td', gitsigns.toggle_deleted, {})
-- from java.lua
-- Java extensions provided by jdtls

local jdtls = require("jdtls")
map('n', "<C-o>", jdtls.organize_imports, { desc = "Organize imports" })
map('n', "<space>ev", jdtls.extract_variable, { desc = "Extract variable" })
map('n', "<space>ec", jdtls.extract_constant, { desc = "Extract constant" })
map('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { noremap=true, silent=true, buffer=bufnr, desc = "Extract method" })

-- nvim-dap
local dap = require("dap")
local dapui = require("dapui")
map('n', "<leader>bb", dap.toggle_breakpoint, { desc = "Set breakpoint" })
map('n', "<leader>bc", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Set conditional breakpoint" })
map('n', "<leader>bl", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "Set log point" })
map('n', '<leader>br', dap.clear_breakpoints, { desc = "Clear breakpoints" })
map('n', '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>', { desc = "List breakpoints" })

map('n', "<leader>dc", dap.continue, { desc = "Continue" })
map('n', "<leader>c",  dap.run_to_cursor, { desc = "Continue" })
map('n', "<leader>dj", dap.step_over, { desc = "Step over" })
map('n', "<leader>dk", dap.step_into, { desc = "Step into" })
map('n', "<leader>do", dap.step_out, { desc = "Step out" })
map('n', '<leader>dd', dap.disconnect, { desc = "Disconnect" })
map('n', '<leader>dt', dap.terminate, { desc = "Terminate" })
map('n', "<leader>dr", dap.repl.toggle, { desc = "Open REPL" })
map('n', "<leader>dl", dap.run_last, { desc = "Run last" })
map('n', '<leader>di', function() require"dap.ui.widgets".hover() end, { desc = "Variables" })
map('n', '<leader>d?', function() local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes) end, { desc = "Scopes" })
map('n', '<leader>df', '<cmd>Telescope dap frames<cr>', { desc = "List frames" })
map('n', '<leader>dh', '<cmd>Telescope dap commands<cr>', { desc = "List commands" })
map('n', "<leader>dx", dapui.close, { desc = "Close DAP UI" })

map('n', "<leader>vc", jdtls.test_class, { desc = "Test class (DAP)" })
map('n', "<leader>vm", jdtls.test_nearest_method, { desc = "Test method (DAP)" })


local attempt = require('attempt')
local telescope = require('telescope').extensions.attempt

map('n', '<leader>an', attempt.new_select)        -- new attempt, selecting extension
map('n', '<leader>ai', attempt.new_input_ext)     -- new attempt, inputing extension
map('n', '<leader>ar', attempt.run)               -- run attempt
map('n', '<leader>ad', attempt.delete_buf)        -- delete attempt from current buffer
map('n', '<leader>ac', attempt.rename_buf)        -- rename attempt from current buffer
--map('n', '<leader>al', 'Telescope attempt')       -- search through attempts
map('n', '<leader>al', attempt.open_select)

-- tmux
map('n', '<c-h>', '<cmd>TmuxNavigateLeft<cr>', { silent = true })
map('n', '<c-j>', '<cmd>TmuxNavigateDown<cr>', { silent = true })
map('n', '<c-k>', '<cmd>TmuxNavigateUp<cr>', { silent = true })
map('n', '<c-l>', '<cmd>TmuxNavigateRight<cr>', { silent = true })
map('n', '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>', { silent = true })

-- harpoon
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

--vim.keymap.set("n", "<C-U>", function() harpoon:list():select(1) end)
--vim.keymap.set("n", "<C-I>", function() harpoon:list():select(2) end)
--vim.keymap.set("n", "<C-O>", function() harpoon:list():select(3) end)
--vim.keymap.set("n", "<C-P>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
