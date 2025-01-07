-- local wk = require "which-key"
-- local dap = require "dap"
-- local ts = require "telescope"
-- local tb = require "telescope.builtin"

-- Strong left/right
vim.keymap.set("n", "H", "0")
vim.keymap.set("n", "L", "$")
vim.keymap.set("v", "H", "0")
vim.keymap.set("v", "L", "$")

-- Move between windows easier in normal mode
vim.keymap.set("n", "<leader>w", "<c-w>")

-- Swap last two buffers
vim.keymap.set("n", "<leader><leader>", "<cmd>buffer#<cr>")

-- Change
vim.keymap.set("n", "<c-d>", "*<c-o>cgn")

