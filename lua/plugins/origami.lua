return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	opts = {
		keepFoldsAcrossSessions = false, -- metti true se hai nvim-ufo
		pauseFoldsOnSearch = true,
		foldtext = { -- <--- cambiato qui
			enabled = true,
			padding = 3,
			lineCount = {
				template = "   %d linee", -- %d sostituisce il numero di linee
				hlgroup = "Comment",
			},
		},
		foldKeymaps = {
			setup = true, -- modifica 'h' e 'l'
			hOnlyOpensOnFirstColumn = false,
		},
		autoFold = {
			enabled = false, -- richiede Neovim 0.11
		},
	},
	config = function(_, opts)
		require("origami").setup(opts)
		-- Debug: verifica se origami è stato caricato
		vim.api.nvim_create_user_command("OrigamiDebug", function()
			vim.notify("Origami è caricato: " .. tostring(package.loaded["origami"] ~= nil))
		end, {})
	end,
}
