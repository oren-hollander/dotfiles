local map = vim.keymap.set

map("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })

map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "Live grep" })

map("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Find buffers" })

map("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, { desc = "Help tags" })

map("n", "<leader>dd", function()
  vim.diagnostic.setloclist()
end, { desc = "Diagnostics list" })

map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

-- tmux navigator in insert mode
map("i", "<C-h>", "<C-\\><C-n><cmd>TmuxNavigateLeft<CR>", { desc = "Tmux navigate left" })
map("i", "<C-j>", "<C-\\><C-n><cmd>TmuxNavigateDown<CR>", { desc = "Tmux navigate down" })
map("i", "<C-k>", "<C-\\><C-n><cmd>TmuxNavigateUp<CR>", { desc = "Tmux navigate up" })
map("i", "<C-l>", "<C-\\><C-n><cmd>TmuxNavigateRight<CR>", { desc = "Tmux navigate right" })
