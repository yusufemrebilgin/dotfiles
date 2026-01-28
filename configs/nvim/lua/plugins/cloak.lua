-- Cloak (https://github.com/laytan/cloak.nvim)
return {
  'laytan/cloak.nvim',
  config = function()
    require('cloak').setup({
      enabled = true,
      cloak_character = '*',
      -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
      highlight_group = 'Comment',
      -- Applies the length of the replacement characters for all matched
      -- patterns, defaults to the length of the matched pattern.
      cloak_length = 4,
      -- Re-enable cloak when a matched buffer leaves the window.
      cloak_on_leave = true,
      patterns = {
        {
          -- Match any file starting with '.env'.
          -- This can be a table to match multiple file patterns.
          file_pattern = '.env*',
          -- Match an equals sign and any character after it.
          -- This can also be a table of patterns to cloak,
          -- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
          cloak_pattern = '=.+'
        }
      }
    })
  end
}
