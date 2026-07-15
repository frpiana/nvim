return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		local keymap = vim.keymap.set

		keymap("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Harpoon: aggiungi file" })

		keymap("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: menu" })

		for i = 1, 4 do
			keymap("n", "<leader>" .. i, function()
				harpoon:list():select(i)
			end, { desc = "Harpoon: file " .. i })
		end
	end,
}
