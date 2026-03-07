-- =============================================================================
-- Debugging: nvim-dap + dap-ui + virtual text + adapters for
--            TypeScript/JavaScript, Python, C/C++
-- =============================================================================
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- UI panels (variables, stack, watch, breakpoints, console)
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
      },
      -- Inline variable values next to code (like VSCode inline values)
      'theHamsta/nvim-dap-virtual-text',
      -- Auto-install debug adapters via Mason
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = { 'mason-org/mason.nvim' },
      },
      -- Python adapter
      'mfussenegger/nvim-dap-python',
    },

    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- -----------------------------------------------------------------------
      -- Signs: Nerd Font icons with VSCode-style colors
      -- -----------------------------------------------------------------------
      vim.fn.sign_define('DapBreakpoint', {
        text = '●',
        texthl = 'DiagnosticError',
      })
      vim.fn.sign_define('DapBreakpointCondition', {
        text = '◆',
        texthl = 'DiagnosticWarn',
      })
      vim.fn.sign_define('DapLogPoint', {
        text = '◈',
        texthl = 'DiagnosticInfo',
      })
      vim.fn.sign_define('DapStopped', {
        text = '→',
        texthl = 'DiagnosticOk',
        linehl = 'DiffAdd',   -- green line highlight on current debug line
        numhl = 'DiagnosticOk',
      })
      vim.fn.sign_define('DapBreakpointRejected', {
        text = '○',
        texthl = 'DiagnosticError',
      })

      -- -----------------------------------------------------------------------
      -- Adapters: mason-nvim-dap auto-installs and configures
      -- -----------------------------------------------------------------------
      require('mason-nvim-dap').setup {
        -- Ensures these adapters are always installed
        ensure_installed = { 'python', 'js-debug-adapter', 'codelldb' },
        -- Empty handlers table = use mason-nvim-dap's built-in default
        -- handler for every adapter in ensure_installed (auto-configures them)
        handlers = {},
      }

      -- -----------------------------------------------------------------------
      -- Python: point at Mason's debugpy installation
      -- -----------------------------------------------------------------------
      local mason_packages = vim.fn.stdpath 'data' .. '/mason/packages'
      require('dap-python').setup(mason_packages .. '/debugpy/venv/bin/python')

      -- -----------------------------------------------------------------------
      -- C/C++: codelldb is handled by mason-nvim-dap default handler,
      -- but we also wire it up for 'c' so configs are shared with 'cpp'
      -- -----------------------------------------------------------------------
      dap.configurations.c = dap.configurations.cpp or {}

      -- -----------------------------------------------------------------------
      -- UI: setup panels and wire auto-open/close to session lifecycle
      -- -----------------------------------------------------------------------
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
        controls = {
          icons = {
            pause      = '⏸',
            play       = '▶',
            step_into  = '⬇',
            step_over  = '⤵',
            step_out   = '⬆',
            step_back  = '⤴',
            run_last   = '↺',
            terminate  = '□',
            disconnect = '⏏',
          },
        },
        layouts = {
          {
            -- Left sidebar: scopes, breakpoints, stacks, watches
            elements = {
              { id = 'scopes',      size = 0.40 },
              { id = 'breakpoints', size = 0.20 },
              { id = 'stacks',      size = 0.25 },
              { id = 'watches',     size = 0.15 },
            },
            size = 40,
            position = 'left',
          },
          {
            -- Bottom tray: repl + console
            elements = {
              { id = 'repl',    size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 12,
            position = 'bottom',
          },
        },
      }

      -- Auto-open UI when a session starts, auto-close when it ends
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- -----------------------------------------------------------------------
      -- Panel titles via winbar (one per dapui filetype)
      -- -----------------------------------------------------------------------
      local panel_titles = {
        dapui_scopes      = '  Scopes',
        dapui_breakpoints = '  Breakpoints',
        dapui_stacks      = '  Call Stack',
        dapui_watches     = '  Watch',
        dapui_console     = '  Console',
        dap_repl          = '  REPL',
      }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = vim.tbl_keys(panel_titles),
        callback = function(ev)
          local title = panel_titles[vim.bo[ev.buf].filetype]
          if title then
            vim.wo.winbar = title
          end
        end,
      })

      -- -----------------------------------------------------------------------
      -- Inline virtual text (VSCode-style inline values)
      -- -----------------------------------------------------------------------
      require('nvim-dap-virtual-text').setup {
        highlight_changed_variables = true,  -- changed vars shown in warning color
        show_stop_reason = true,             -- show exception message inline
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
      }

      -- -----------------------------------------------------------------------
      -- Keymaps: matching VSCode defaults
      -- -----------------------------------------------------------------------
      -- F5  = Continue / Start
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Continue / Start' })
      -- Shift+F5 = Stop
      vim.keymap.set('n', '<S-F5>', dap.terminate, { desc = 'Debug: Stop' })
      -- F9  = Toggle breakpoint
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      -- F10 = Step over
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
      -- F11 = Step into
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
      -- Shift+F11 = Step out
      vim.keymap.set('n', '<S-F11>', dap.step_out, { desc = 'Debug: Step Out' })

      -- <leader>d* group for less frequent actions
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug: Toggle [B]reakpoint' })
      vim.keymap.set('n', '<leader>dB', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = '[D]ebug: Conditional [B]reakpoint' })
      vim.keymap.set('n', '<leader>dl', function()
        dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
      end, { desc = '[D]ebug: [L]og Point' })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = '[D]ebug: Open [R]EPL' })
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = '[D]ebug: Toggle [U]I' })
      -- Evaluate expression under cursor (or visual selection)
      vim.keymap.set('n', '<leader>de', dapui.eval, { desc = '[D]ebug: [E]valuate Expression' })
      vim.keymap.set('v', '<leader>de', dapui.eval, { desc = '[D]ebug: [E]valuate Selection' })
    end,
  },
}
