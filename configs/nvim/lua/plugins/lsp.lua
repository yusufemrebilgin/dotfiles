--
-- LSP Configuration
--

local function on_lsp_detach(args)
  vim.lsp.buf.clear_references()
  vim.api.nvim_clear_autocmds({
    group = "user-lsp-highlight",
    buffer = args.buf,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach-group", { clear = true }),
  callback = function(event)
    -- Helper function to easily define LSP related items
    -- it sets mode, buffer and description each time
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, {
        buffer = event.buf,
        desc = "LSP: " .. desc,
      })
    end

    -- Rename the variable under your cursor.
    map("grn", vim.lsp.buf.rename, "Rename")
    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map("gra", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map("grD", vim.lsp.buf.declaration, "Goto Declaration")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/documentHighlight", event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
        callback = on_lsp_detach,
      })
    end

    if client and client:supports_method("textDocument/inlayHint", event.buf) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "Toggle Inlay Hints")
    end
  end,
})

-- Neovim's native LSP API auto-loads any "lsp/<name>.lua" file on the
-- runtime path as a config named "<name>" (see :h lsp-config). Rather
-- than hardcoding that list again for vim.lsp.enable(), we read the
-- filenames directly off disk. So, adding a server is just adding a
-- file, nothing else to remember to update.

local function load_configured_servers()
  local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
  local servers = {}

  for filename, filetype in vim.fs.dir(lsp_dir) do
    if filetype == "file" and filename:match("%.lua$") then
      local name = filename:gsub("%.lua$", "")
      local filepath = vim.fs.joinpath(lsp_dir, filename)
      vim.lsp.config(name, dofile(filepath))
      table.insert(servers, name)
    end
  end

  return servers
end

vim.lsp.config("*", {
  root_markers = {
    ".git",
  },
})

local lsp_servers = load_configured_servers()

vim.lsp.enable(lsp_servers)

--
-- Diagnostic Configuration
--

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●",
    severity_sort = true,
  },
  virtual_lines = false,
  underline = true,
  severity_sort = true,
  update_in_insert = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "●",
      [vim.diagnostic.severity.INFO] = "●",
      [vim.diagnostic.severity.HINT] = "●",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

vim.keymap.set("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })

--

return {
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      automatic_enable = false,
      ensure_installed = lsp_servers,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        poll_rate = 0,
        suppress_on_insert = false,
        display = {
          render_limit = 3,
          done_ttl = 2,
        },
      },
      notification = {
        window = {
          winblend = 10,
        },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
