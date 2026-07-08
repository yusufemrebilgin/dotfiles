vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("user-yank-group", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
