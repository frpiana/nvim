return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		-- Con catppuccin attivo usa l'integrazione dedicata (copre anche le
		-- palette personalizzate via color_overrides, es. Tabby Matcha).
		-- Il modulo ha cambiato percorso nelle versioni recenti: si provano
		-- entrambi, prima il nuovo.
		local function catppuccin_highlights()
			if not (vim.g.colors_name or ""):find("catppuccin") then
				return nil
			end
			for _, mod in ipairs({
				"catppuccin.special.bufferline",
				"catppuccin.groups.integrations.bufferline",
			}) do
				local ok, integration = pcall(require, mod)
				if ok then
					local ok2, highlights = pcall(integration.get_theme or integration.get)
					if ok2 then
						return highlights
					end
				end
			end
		end

		local function setup()
			require("bufferline").setup({
				highlights = catppuccin_highlights(),
				options = {
					mode = "buffers", -- invece di "tabs"
					separator_style = "slant",
					show_buffer_close_icons = true,
					show_close_icon = false,
				},
			})
		end

		setup()

		-- Gli highlight vengono calcolati al setup: ricostruiscili a ogni
		-- cambio di colorscheme. vim.schedule li fa applicare DOPO l'intera
		-- catena dell'evento, così nessun altro li sovrascrive.
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("BufferlineTheme", { clear = true }),
			callback = function()
				vim.schedule(setup)
			end,
		})
	end,
}
