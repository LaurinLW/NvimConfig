return {
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "html", "cssls", "angular-language-server", "graphql", "typescript-language-server", "pyright",
        -- Formatters and linters for none-ls
        "prettier", "eslint_d", "black"
      }
    },
  },

  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("none-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
        },
      })
    end,
  },

  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    config = function()
      require('diffview').setup({})
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
