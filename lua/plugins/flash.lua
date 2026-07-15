return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"s",
			function()
				require("flash").jump()
			end,
			mode = { "n", "x", "o" },
			desc = "Flash jump",
		},
		{
			-- solo n/o: in visual 'S' resta di nvim-surround (aggiungi surround)
			"S",
			function()
				require("flash").treesitter()
			end,
			mode = { "n", "o" },
			desc = "Flash treesitter (seleziona nodo)",
		},
		{
			"r",
			function()
				require("flash").remote()
			end,
			mode = "o",
			desc = "Remote flash (operatore a distanza)",
		},
		{
			"<C-s>",
			function()
				require("flash").toggle()
			end,
			mode = "c",
			desc = "Toggle flash durante la ricerca /",
		},
	},
}
