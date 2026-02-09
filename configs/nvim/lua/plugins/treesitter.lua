-- Nvim Treesitter (https://github.com/nvim-treesitter/nvim-treesitter)
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    require('nvim-treesitter.configs').setup({
      modules = {},
      indent = { enable = true },
      highlight = { enable = true },
      auto_install = false,
      sync_install = false,
      ignore_install = {},
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
        'dockerfile',
        'javascript',
        'typescript'
      }
    })
  end
}

