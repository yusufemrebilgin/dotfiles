--
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.winborder = "solid"

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.updatetime = 250

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.colorcolumn = "120"

vim.opt.number = true
vim.opt.showmode = false
vim.opt.relativenumber = true
vim.opt.breakindent = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.termguicolors = true

vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy" }
