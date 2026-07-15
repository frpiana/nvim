return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main", -- come nvim-treesitter: il branch master è congelato
	event = "VeryLazy",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true, -- salta in avanti al prossimo textobject (es. 'daf' funziona anche prima della funzione)
			},
			move = {
				set_jumps = true, -- i salti finiscono nella jumplist (<C-o> per tornare indietro)
			},
		})

		local select = require("nvim-treesitter-textobjects.select")
		local move = require("nvim-treesitter-textobjects.move")
		local map = vim.keymap.set

		-- textobject: a = intero, i = solo il corpo/contenuto
		local objects = {
			{ "f", "@function", "function" },
			{ "c", "@class", "class" },
			{ "a", "@parameter", "argomento" },
		}
		for _, obj in ipairs(objects) do
			local key, capture, name = obj[1], obj[2], obj[3]
			map({ "x", "o" }, "a" .. key, function()
				select.select_textobject(capture .. ".outer", "textobjects")
			end, { desc = "a " .. name })
			map({ "x", "o" }, "i" .. key, function()
				select.select_textobject(capture .. ".inner", "textobjects")
			end, { desc = "inner " .. name })
		end

		-- movimenti tra funzioni e classi
		map({ "n", "x", "o" }, "]f", function()
			move.goto_next_start("@function.outer", "textobjects")
		end, { desc = "Prossima funzione" })
		map({ "n", "x", "o" }, "[f", function()
			move.goto_previous_start("@function.outer", "textobjects")
		end, { desc = "Funzione precedente" })
		map({ "n", "x", "o" }, "]c", function()
			move.goto_next_start("@class.outer", "textobjects")
		end, { desc = "Prossima classe" })
		map({ "n", "x", "o" }, "[c", function()
			move.goto_previous_start("@class.outer", "textobjects")
		end, { desc = "Classe precedente" })
	end,
}
