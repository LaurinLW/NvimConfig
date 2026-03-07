-- =============================================================================
-- UI plugins: colorscheme, file explorer, buffer bar, statusline,
--             indent guides, autopairs, which-key, todo-comments
-- =============================================================================
return {

  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'night',
        styles = { comments = { italic = false } },
        on_highlights = function(hl, c)
          -- Make the split/window separator line visible with a blue accent
          hl.WinSeparator = { fg = c.blue, bg = c.bg }
          -- nvim-tree uses its own separator group — override it to match
          hl.NvimTreeWinSeparator = { fg = c.blue, bg = c.bg }
          -- Dim inactive windows so the focused split stands out
          hl.NormalNC = { bg = c.bg_dark }
        end,
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- disable netrw at the very start
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require('nvim-tree').setup {
        view = { width = 35 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        update_focused_file = { enable = true },
      }

      vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', { desc = 'Focus file [E]xplorer' })
    end,
  },

  -- Buffer/tab bar
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        mode = 'buffers',
        separator_style = 'slant',
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            highlight = 'Directory',
            separator = true,
          },
        },
      },
    },
  },

  -- Statusline
  {
    'nvim-mini/mini.nvim',
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- Auto-close brackets/quotes
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  -- Keybinding popup
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>f',   group = '[F]ind' },
        { '<leader>s',   group = '[S]earch' },
        { '<leader>g',   group = '[G]it' },
        { '<leader>b',   group = '[B]uffer' },
        { '<leader>d',   group = '[D]ebug' },
        { '<leader>r',   group = '[R]ename / [R]eplace' },
        { '<leader>c',   group = '[C]ode' },
        { '<leader>t',   group = '[T]erminal / [T]oggle' },
        { 'g',           group = '[G]oto' },
      },
    },
  },

  -- Highlight TODO/FIXME/HACK/NOTE in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
}
