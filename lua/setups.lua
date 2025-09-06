local null_ls = require("null-ls")
local eslint = require("eslint")


null_ls.setup({ sources = { null_ls.builtins.formatting.prettier } })

eslint.setup({
  bin = 'eslint', -- or `eslint_d`
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = true,
      types = { "directive", "problem", "suggestion", "layout" },
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line", -- or `same_line`
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "type", -- or `save`
  },
})

vim.o.clipboard = "unnamedplus"

vim.api.nvim_create_augroup("AutoFormat", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre",
  {
    pattern = { "*.js", "*.ts", "*.html", "*.css", "*.lua", "*.graphql", "*.json", "*.md" },
    callback = function()
      vim.lsp.buf.format()
    end
  })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "AutoFormat",
  pattern = { "*.py" },
  callback = function()
    vim.cmd(":silent !black --preview --line-length 240 %")
  end,
})
