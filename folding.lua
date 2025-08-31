-- Configurazione base per il folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- se usi treesitter
-- oppure
-- vim.opt.foldmethod = "indent" -- alternativa più semplice

-- Assicurati che i fold non siano tutti chiusi all'apertura
vim.opt.foldenable = true
vim.opt.foldlevel = 99
