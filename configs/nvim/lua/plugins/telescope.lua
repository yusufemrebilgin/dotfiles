-- Telescope (https://github.com/nvim-telescope/telescope.nvim)
return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',

  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      -- C port of fzf implementation
      -- telescope-fzf-native.nvim (https://github.com/nvim-telescope/telescope-fzf-native.nvim)
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install',
      -- If condition is false this dependency plugin will not be included in the spec
      cond = function()
        return vim.fn.executable('cmake') == 1
      end
    }
  },

  config = function()

    require('telescope').setup({
      pickers = {
        live_grep = {
          layout_strategy = 'vertical',
          layout_config = { prompt_position = 'top' },
          sorting_strategy = 'ascending',
          previewer = false,
        }
      }
    })

    pcall(require('telescope').load_extension, 'fzf')
    -- For more `:help telescope.builtin`
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search Files' })
    vim.keymap.set('n', '<leader>sG', builtin.git_files, { desc = 'Search Git Files' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Search Select Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current Word' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by Grep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search Diagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Search Resume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })

    vim.keymap.set('n', '<leader><leader>', function()
      builtin.buffers({ initial_mode = 'normal' })
    end, { desc = '[ ] Find existing buffers' })


    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = 'Search [/] in Open Files' })

  end
}
