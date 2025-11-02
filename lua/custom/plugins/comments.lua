return {
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "BufEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
}
