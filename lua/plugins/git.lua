-- =============================================================================
-- Git: gitsigns (gutter signs, hunks, blame) + diffview (diff/merge UI)
-- =============================================================================
return {

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Git: ' .. desc })
        end

        -- Hunk navigation
        map(']h', function() gs.nav_hunk 'next' end, 'Next hunk')
        map('[h', function() gs.nav_hunk 'prev' end, 'Prev hunk')

        -- <leader>h opens a terminal, so hunk actions live on <leader>H.
        map('<leader>Hs', gs.stage_hunk,        'Stage hunk')
        map('<leader>Hr', gs.reset_hunk,        'Reset hunk')
        map('<leader>HS', gs.stage_buffer,      'Stage buffer')
        map('<leader>HR', gs.reset_buffer,      'Reset buffer')
        map('<leader>Hu', gs.undo_stage_hunk,   'Undo stage hunk')
        map('<leader>Hp', gs.preview_hunk,      'Preview hunk')
        map('<leader>Hd', gs.diffthis,          'Diff this')
        map('<leader>Hb', function() gs.blame_line { full = true } end, 'Blame line')
        map('<leader>tb', gs.toggle_current_line_blame, 'Toggle line blame')
      end,
    },
  },

  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>',         desc = '[G]it [D]iffview open' },
      { '<leader>gD', '<cmd>DiffviewClose<CR>',        desc = '[G]it [D]iffview close' },
      { '<leader>gh', '<cmd>DiffviewFileHistory<CR>',  desc = '[G]it file [H]istory' },
    },
    opts = {},
  },
}
