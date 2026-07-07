-- Neo-tree.nvim (https://github.com/nvim-neo-tree/neo-tree.nvim)
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>Neotree toggle left<cr>" },
    { "<C-e>", "<cmd>Neotree toggle float<cr>" },
  },
  config = function()
    require("neo-tree").setup({

      close_if_last_window = true,
      popup_border_style = "NC",
      clipboard = {
        sync = "none",
      },
      enable_git_status = true,
      enable_diagnostics = true,

      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
        },
        git_status = {
          symbols = {
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
          },
        },
      },

      window = {
        position = "left",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<cr>"] = "open",
          ["q"] = "close_window",
          ["l"] = "open",
          ["h"] = "close_node",
          ["<esc>"] = "cancel",
        },
      },

      filesystem = {
        filtered_items = {
          visible = true,
          children_inherit_highlights = true,
          hide_dotfiles = true,
          hide_gitignored = true,
          show_hidden_count = false,
          never_show = {
            ".git",
          },
        },
        hijack_netrw_behavior = "open_current",
        window = {
          mappings = {
            ["y"] = function(state)
              local node = state.tree:get_node()
              if node ~= nil then
                local name = node.name
                vim.fn.setreg("+", name)
                vim.notify("'" .. name .. "' copied to clipboard")
              end
            end,
            ["Y"] = function(state)
              local node = state.tree:get_node()
              if node ~= nil then
                local path = node:get_id()
                vim.fn.setreg("+", path)
                vim.notify("'" .. path .. "' copied to clipboard")
              end
            end,
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            ["#"] = "none",
            ["f"] = "none",
            ["<c-x>"] = "none",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
            ["o"] = {
              "show_help",
              nowait = false,
              config = { title = "Order by", prefix_key = "o" },
            },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["og"] = { "order_by_git_status", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },
    })
  end,
}
