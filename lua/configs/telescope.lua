-- Telescope configuration to fix deprecated no_ignore option
-- Defer loading until telescope is available
vim.defer_fn(function()
  pcall(function()
    local telescope = require "telescope.builtin"

    -- Monkey patch the find_files function to remove no_ignore
    local original_find_files = telescope.find_files
    telescope.find_files = function(opts)
      opts = opts or {}
      -- Remove deprecated no_ignore option
      opts.no_ignore = nil
      -- Add hidden option if needed
      if opts.hidden == nil then
        opts.hidden = true
      end
      return original_find_files(opts)
    end
  end)
end, 100)