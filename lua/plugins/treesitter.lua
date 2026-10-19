return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local langs = {
        'html', 'css', 'javascript', 'typescript', 'tsx', 'graphql', 'json',
        'python', 'c', 'cpp', 'lua', 'luadoc', 'vim', 'vimdoc',
        'bash', 'yaml', 'toml', 'dockerfile', 'markdown', 'markdown_inline', 'regex', 'diff',
      }
      require('nvim-treesitter').install(langs):wait(300000)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
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
        ['htmlangular'] = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      },
    },
  },
}
