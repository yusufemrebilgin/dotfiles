--
-- Bag of plugins that are small, self-contained, or optional. These plugins typically
-- reuqire less than 10 lines of configuration and are primarly for utility, workflow
-- enhancements, or minor features.
--

return {
  {
    -- sleuth.vim (https://github.com/tpope/vim-sleuth)
    -- Automatically adjust 'shiftwidth' and 'expandtab' heuristically based on the current file
    'tpope/vim-sleuth'
  },
  {
    -- nvim-autopairs (https://github.com/windwp/nvim-autopairs)
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
  }
}
