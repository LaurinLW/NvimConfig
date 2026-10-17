-- =============================================================================
-- init.lua — kickstart-based Neovim config
-- =============================================================================

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Disable unused built-in providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- =============================================================================
-- OPTIONS
-- =============================================================================
vim.o.number = true
vim.o.relativenumber = false
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 400
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.smartindent = true
vim.o.numberwidth = 2
vim.o.laststatus = 3
vim.o.list = false
vim.o.inccommand = 'split'
vim.o.fillchars = 'eob: ,vert:│'
vim.opt.listchars = { trail = '·', nbsp = '␣' }
vim.opt.whichwrap:append '<>[]hl'

-- Schedule clipboard so it doesn't slow startup
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- =============================================================================
-- KEYMAPS
-- =============================================================================

-- Convenience
vim.keymap.set('n', ';', ':', { desc = 'Enter command mode' })
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Escape insert mode' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })

-- Find & replace
vim.keymap.set('n', '<leader>fra', ':%s/', { desc = '[F]ind [R]eplace [A]ll in file' })

-- Buffer navigation
vim.keymap.set('n', '<leader>bn', '<cmd>bn<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<cmd>bp<CR>', { desc = '[B]uffer [P]rev' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<Tab>', '<cmd>bn<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>bp<CR>', { desc = 'Prev buffer' })

-- Close window and wipe buffer if it's the last window showing it
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local wins = vim.fn.win_findbuf(buf)
    if #wins <= 1 then
      vim.cmd("bwipeout")
    end
  end,
})

-- Terminal
vim.keymap.set('n', '<leader>tt', '<cmd>terminal<CR>', { desc = 'Open [T]erminal' })
vim.keymap.set('n', '<leader>h', '<cmd>split | terminal<CR>', { desc = 'Terminal [H]orizontal split' })
vim.keymap.set('n', '<leader>v', '<cmd>vsplit | terminal<CR>', { desc = 'Terminal [V]ertical split' })
vim.keymap.set('t', '<C-x>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostics
vim.keymap.set('n', '<leader>ds', vim.diagnostic.setloclist, { desc = '[D]iagnostic [S]etloclist' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic location list' })

-- LSP keymaps (set globally so they work even before LspAttach in some edge cases,
-- but the buffer-local ones in lsp.lua take precedence)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = '[G]oto [R]eferences' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Type [D]efinition' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame symbol' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>fm', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]or[m]at buffer' })

-- =============================================================================
-- AUTOCMDS
-- =============================================================================

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('hl-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- =============================================================================
-- DIAGNOSTIC CONFIG
-- =============================================================================
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  -- 0.12 dropped the jump.float flag. Open the float after a jump instead.
  jump = {
    on_jump = function(diagnostic)
      if diagnostic then
        vim.diagnostic.open_float()
      end
    end,
  },
}

-- =============================================================================
-- LAZY.NVIM BOOTSTRAP
-- =============================================================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- PLUGINS
-- =============================================================================
require('lazy').setup({
  { import = 'plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂',
      init = '⚙', keys = '🗝', plugin = '🔌', runtime = '💻',
      require = '🌙', source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
  change_detection = { notify = false },
})
