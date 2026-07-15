return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local substitute = require("substitute")

    substitute.setup()

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    -- 'gs' invece di 's': 's' ora è il jump di flash.nvim
    -- (per sostituire fino a fine riga: gs$ — è un normale operatore+motion)
    vim.keymap.set("n", "gs", substitute.operator, { desc = "Substitute with motion" })
    vim.keymap.set("n", "gss", substitute.line, { desc = "Substitute line" })
    vim.keymap.set("x", "gs", substitute.visual, { desc = "Substitute in visual mode" })
  end,
}
