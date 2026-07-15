return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	-- foldlevel alti = file aperto senza fold chiusi (raccomandato da origami)
	init = function()
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
	end,
	opts = {
		-- origami fornisce i fold via LSP, con Treesitter come fallback (default: on)
		pauseFoldsOnSearch = true,
		foldtext = {
			enabled = true,
			padding = { width = 3 },
			lineCount = {
				template = "   %d linee", -- %d = numero di linee piegate
				hlgroup = "Comment",
			},
		},
		foldKeymaps = {
			setup = true, -- rimappa h / l / ^ / $
			closeOnlyOnFirstColumn = false, -- ex hOnlyOpensOnFirstColumn
		},
		autoFold = {
			enabled = false, -- non piegare automaticamente commenti/import all'apertura
		},
	},
}
