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

    local telescope = require('telescope')
    local telescope_builtin = require('telescope.builtin')
    local telescope_themes = require('telescope.themes')

    telescope.setup({
      pickers = {
        live_grep = {
          layout_strategy = 'vertical',
          layout_config = { prompt_position = 'top' },
          sorting_strategy = 'ascending',
          previewer = false,
        }
      }
    })


    pcall(telescope.load_extension, 'fzf')

    vim.api.nvim_create_autocmd('UIEnter', {
      once = true,
      callback = function()
        if vim.fn.argc() > 0 then return end

        local cwd = vim.fn.getcwd()

        local is_ok = os.execute('git -C ' .. vim.fn.shellescape(cwd) .. ' rev-parse --is-inside-work-tree > /dev/null 2>&1')
        local is_git_repo = is_ok == 0

        if is_git_repo then
          telescope_builtin.git_files({ previewer = false, show_untracked = true })
        else
          telescope_builtin.find_files({ previewer = false })
        end

      end
    })

    -- For more `:help telescope.builtin`
    vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = 'Search files' })
    vim.keymap.set('n', '<leader>sG', telescope_builtin.git_files, { desc = 'Search git files' })
    vim.keymap.set('n', '<leader>ss', telescope_builtin.builtin, { desc = 'Search Telescope pickers' })
    vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = 'Search current word' })
    vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = 'Search by grep' })
    vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = 'Search diagnostics' })
    vim.keymap.set('n', '<leader>sr', telescope_builtin.resume, { desc = 'Search resume' })
    vim.keymap.set('n', '<leader>s.', telescope_builtin.oldfiles, { desc = 'Search recent files ("." for repeat)' })

    vim.keymap.set('n', '<leader><leader>', function()
      telescope_builtin.buffers({ initial_mode = 'normal' })
    end, { desc = 'Find existing buffers' })


    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      telescope_builtin.current_buffer_fuzzy_find(telescope_themes).get_dropdown({
        winblend = 10,
        previewer = false,
      })
    end, { desc = 'Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      telescope_builtin.live_grep({
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      })
    end, { desc = 'Search in open files' })

  end
}
