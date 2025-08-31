-- in your plugins/init.lua file (or wherever you define plugins)
return {
	-- Your other plugins here
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false, -- 👈 Important: Load this plugin on startup
		require("nvim-treesitter.configs").setup({
			highlight = { enable = true },
			indent = { enable = true },
		}),
	},
}
