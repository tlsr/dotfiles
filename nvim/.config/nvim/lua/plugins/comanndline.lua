return {
    'VonHeikemen/fine-cmdline.nvim',
    requires = {
        {'MunifTanjim/nui.nvim'}
    },
	config = function(_, opts)
        vim.keymap.set('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})
	end,
}
