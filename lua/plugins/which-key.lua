return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- nomi dei gruppi di keymap (mostrati nel popup di which-key)
    spec = {
      { "<leader>c", group = "code action" },
      { "<leader>e", group = "explorer (nvim-tree)" },
      { "<leader>f", group = "find (telescope)" },
      { "<leader>h", group = "git hunk (gitsigns)" },
      { "<leader>i", group = "REPL (iron)" },
      { "<leader>m", group = "format (conform)" },
      { "<leader>r", group = "rename/restart LSP" },
      { "<leader>s", group = "split" },
      { "<leader>t", group = "tab" },
      { "<leader>w", group = "session" },
      { "<leader>x", group = "diagnostics (trouble)" },
    },
  },
}
