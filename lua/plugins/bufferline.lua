return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		-- Con catppuccin attivo usa l'integrazione dedicata (copre anche le
		-- palette personalizzate via color_overrides, es. Tabby Matcha)
		local function catppuccin_highlights()
			if not (vim.g.colors_name or ""):find("catppuccin") then
				return nil
			end
			local ok, integration = pcall(require, "catppuccin.groups.integrations.bufferline")
			if not ok then
				return nil
			end
			local ok2, highlights = pcall(integration.get_theme or integration.get)
			if ok2 then
				return highlights
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
		-- cambio di colorscheme, così la barra segue lo script `theme`
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("BufferlineTheme", { clear = true }),
			callback = setup,
		})
	end,
}
