return {
  {
    "tpope/vim-commentary",
    event = "VeryLazy",
    config = function()
      -- Set up keymaps after plugin loads
      vim.keymap.set("n", "<C-/>", ":Commentary<CR>", { desc = "Toggle comment" })
      vim.keymap.set("n", "<C-_>", ":Commentary<CR>", { desc = "Toggle comment" })
      vim.keymap.set("i", "<C-/>", "<C-o>:Commentary<CR>", { desc = "Toggle comment" })
      vim.keymap.set("i", "<C-_>", "<C-o>:Commentary<CR>", { desc = "Toggle comment" })
      vim.keymap.set("v", "<C-/>", ":Commentary<CR>gv", { desc = "Toggle comment" })
      vim.keymap.set("v", "<C-_>", ":Commentary<CR>gv", { desc = "Toggle comment" })
    end,
  },
}
