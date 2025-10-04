local function format_sql_visual()
  vim.cmd("'<,'>! pg_format --spaces 2 --function-case 2")
end

local function format_sql_buffer()
  vim.cmd("%! pg_format --spaces 2 --function-case 2")
end

vim.keymap.set('v', '<leader>f', function()
  vim.cmd('normal! \\<ESC>')
  format_sql_visual()
end, { 
  buffer = true,
  desc = "Format SQL selection with pg_format"
})

vim.keymap.set('n', '<leader>f', format_sql_buffer, { 
  buffer = true,
  desc = "Format entire SQL buffer with pg_format"
})

