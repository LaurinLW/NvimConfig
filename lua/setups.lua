-- null-ls setup is now handled in plugins/init.lua

vim.o.clipboard = "unnamedplus"

vim.api.nvim_create_augroup("AutoFormat", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre",
  {
    pattern = { "*.js", "*.ts", "*.html", "*.css", "*.lua", "*.graphql", "*.json", "*.md" },
    callback = function()
      vim.lsp.buf.format({ async = false })
    end
  })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "AutoFormat",
  pattern = { "*.py" },
  callback = function()
    vim.cmd("silent !black --preview --line-length 140 " .. vim.fn.expand("%:p"))
    vim.cmd("silent e!") -- Force reload the file to show changes
  end,
})
