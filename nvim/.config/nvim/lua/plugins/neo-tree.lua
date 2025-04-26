return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
    opts = {
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                visible = true,
            },
        },
    },
	config = function(_, opts)
        require("neo-tree").setup(opts)
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
	  	vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
	end,
}
