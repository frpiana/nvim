-- Comando per eseguire il file Python corrente in un terminale toggleterm
-- (verticale, riutilizzabile: <C-\> per nasconderlo/rivederlo)

vim.api.nvim_create_user_command("PP", function()
  vim.cmd("silent! write")
  print(string.format("File %s eseguito:", vim.fn.expand("%:t")))
  vim.cmd('TermExec direction=vertical cmd="python3 ' .. vim.fn.shellescape(vim.fn.expand("%:p")) .. '"')
end, { desc = "Run Python in vertical toggleterm" })
