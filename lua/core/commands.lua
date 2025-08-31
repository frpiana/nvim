# Comando per compilare in python direttamente

vim.api.nvim_create_user_command("PP", function(opts)
  vim.cmd("silent! write")
  print(string.format("File %s eseguito:", vim.fn.expand("%:t")))
  vim.cmd("vsplit")
  vim.cmd("terminal python3 " .. vim.fn.expand("%"))
end, { desc = "Run Python in split terminal with header" })
