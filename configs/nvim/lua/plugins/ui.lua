return {
  {
    -- tokyonight.nvim (https://github.com/folke/tokyonight.nvim)
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        styles = {
          comments = { italic = false },
        },
        on_highlights = function(hl, c)
          local float = c.bg_highlight
          local prompt = c.terminal_black
          -- Borderless Telescope: blend borders/titles into the backgrounds
          -- Floats use a lighter shade than the editor bg so they lift off it
          hl.TelescopeNormal = { bg = float, fg = c.fg_dark }
          hl.TelescopeBorder = { bg = float, fg = float }
          hl.TelescopePromptNormal = { bg = prompt }
          hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          hl.TelescopePromptTitle = { bg = float, fg = c.fg }
          hl.TelescopePreviewNormal = { bg = float }
          hl.TelescopePreviewBorder = { bg = float, fg = float }
          hl.TelescopePreviewTitle = { bg = float, fg = float }
          hl.TelescopeResultsNormal = { bg = float }
          hl.TelescopeResultsBorder = { bg = float, fg = float }
          hl.TelescopeResultsTitle = { bg = float, fg = float }

          hl.NormalFloat = { bg = float, fg = c.fg }
          hl.FloatBorder = { bg = float, fg = c.dark3 }
          hl.FloatTitle = { bg = float, fg = c.blue }
        end,
      })
      vim.cmd.colorscheme("tokyonight-moon")
    end,
  },
  {
    -- lualine.nvim (https://github.com/nvim-lualine/lualine.nvim)
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        icons_enabled = true,
        theme = "tokyonight",
        section_separators = {
          left = "",
          right = "",
        },
      },
    },
  },
  {
    -- indent-blankline.nvim (https://github.com/lukas-reineke/indent-blankline.nvim)
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      debounce = 100,
      indent = {
        char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    },
  },
}
