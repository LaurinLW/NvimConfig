require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Find and replace mappings
map("n", "<leader>fra", ":%s/", { desc = "Find and replace all in file" })

-- Telescope mappings
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find old files" })
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })

-- LSP mappings
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Go to type definition" })

-- Buffer management
map("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })

-- Git mappings
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Telescope git_blame_line<cr>", { desc = "Git blame" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git diff" })

-- Terminal mappings
map("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Toggle terminal" })

-- Search and replace
map("n", "<leader>sr", "<cmd>Telescope live_grep<cr>", { desc = "Search and replace in project" })
map("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Search word under cursor" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate right window" })
