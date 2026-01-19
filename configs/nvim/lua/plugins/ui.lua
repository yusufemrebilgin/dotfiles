return {
  {
    -- tokyonight.nvim (https://github.com/folke/tokyonight.nvim)
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        styles = {
          comments = { italic = false }
        }
      })
      vim.cmd.colorscheme 'tokyonight-moon'
    end
  },
  {
    -- lualine.nvim (https://github.com/nvim-lualine/lualine.nvim)
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { theme = 'tokyonight' }
  }
}
