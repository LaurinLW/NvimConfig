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
}
