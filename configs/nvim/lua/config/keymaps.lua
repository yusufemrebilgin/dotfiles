--
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", "<Cmd>q<CR>")
vim.keymap.set("n", "<leader>qq", "<Cmd>qa<CR>")

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>")
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>")
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>")

-- Line movement & motions
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set({ "n", "x", "o" }, "H", "^", { desc = "First non-blank character" })
vim.keymap.set({ "n", "x", "o" }, "L", "g_", { desc = "Last non-black character" })

-- Toggle wrap & wrapped line mapping
vim.keymap.set("n", "<leader>tw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end)

vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Search navigation
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Match (Centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous Match (Centered)" })
vim.keymap.set("n", "*", "*zzzv", { desc = "Search Word (Centered)" })
vim.keymap.set("n", "#", "#zzzv", { desc = "Search Word Backward (Centered)" })

-- Search and replace mapping from Primeagen
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { silent = false, desc = "Search and replace word under cursor" }
)
