-- Nvim Treesitter (https://github.com/nvim-treesitter/nvim-treesitter)
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    require('nvim-treesitter.configs').setup({
      indent = { enable = true },
      highlight = { enable = true },
      auto_install = true,
      ensure_installed = {
        'bash',
        'go',
        'diff',
        'lua',
        'vim',
        'vimdoc',
        'markdown',
        'markdown_inline',
        'query',
        'yaml',
        'dockerfile'
      }
    })
  end
}

