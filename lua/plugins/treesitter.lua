-- =============================================================================
-- Treesitter: syntax highlighting + indentation for all target languages
-- =============================================================================
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        -- Web / Angular stack
        'html',
        'css',
        'javascript',
        'typescript',
        'tsx',
        'graphql',
        'json',
        'jsonc',
        -- Python
        'python',
        -- C / C++
        'c',
        'cpp',
        -- Lua / Neovim config
        'lua',
        'luadoc',
        'vim',
        'vimdoc',
        -- Shell / tooling
        'bash',
        'yaml',
        'toml',
        'dockerfile',
        -- Docs
        'markdown',
        'markdown_inline',
        'regex',
        'diff',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Auto-close and auto-rename HTML/JSX/TSX/Angular tags
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      per_filetype = {
        -- Angular templates are detected as 'htmlangular'
        ['htmlangular'] = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      },
    },
  },
}
