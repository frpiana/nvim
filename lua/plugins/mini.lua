-- mini.nvim è già installato come dipendenza di render-markdown:
-- qui attiviamo i moduli che usiamo (costo zero in più).
-- mini.ai NON è attivato: i textobject li fornisce nvim-treesitter-textobjects.
return {
	"echasnovski/mini.nvim",
	version = false,
	event = "VeryLazy",
	config = function()
		-- sposta righe/selezioni con Alt+hjkl (in Ghostty serve macos-option-as-alt = true)
		require("mini.move").setup()

		-- argomenti/liste: una riga <-> multiriga con <leader>j
		-- (il default gS è occupato da nvim-surround in visual mode)
		require("mini.splitjoin").setup({
			mappings = { toggle = "<leader>j" },
		})
	end,
}
