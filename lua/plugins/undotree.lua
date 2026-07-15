return {
	"mbbill/undotree",
	cmd = "UndotreeToggle",
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle undo tree" },
	},
	init = function()
		vim.g.undotree_WindowLayout = 2 -- albero a sinistra, diff sotto
		vim.g.undotree_SetFocusWhenToggle = 1
	end,
}
