-- blink.nvim (https://github.com/saghen/blink.nvim)
return {
  "saghen/blink.cmp",
  dependencies = {
    "saghen/blink.lib",
    -- optional: provides snippets for the snippet source
    "rafamadriz/friendly-snippets",
  },
  build = function()
    -- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
    -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
    require("blink.cmp").build():pwait()
  end,

  opts = {
    keymap = {
      preset = "super-tab",
      ["<CR>"] = { "accept", "fallback" },
      ["<C-x>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-q>"] = { "show_documentation", "hide_documentation", "fallback" },
      ["<C-p>"] = { "select_prev", "show_signature", "hide_signature", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-b>"] = {
        "scroll_documentation_up",
        function()
          return true
        end,
      },
      ["<C-f>"] = {
        "scroll_documentation_down",
        function()
          return true
        end,
      },
    },

    signature = {
      enabled = true,
      window = {
        border = "solid",
        max_width = 80,
        max_height = 10,
        winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
      },
    },

    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      menu = {
        scrollbar = true,
        draw = {
          padding = 1,
          gap = 1,
        },
      },
      documentation = {
        auto_show = false,
        window = {
          scrollbar = true,
          border = "solid",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        },
      },
    },

    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100
        }
      }
    },

    fuzzy = { implementation = "prefer_rust" },
  },
}
