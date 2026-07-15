return {
	"akinsho/toggleterm.nvim",
	version = "*",
	event = "VeryLazy",
	opts = {
		open_mapping = [[<C-\>]], -- toggle da normal E da terminal mode
		direction = "float",
		float_opts = { border = "curved" },
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
	},
}
