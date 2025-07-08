-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Save with Ctrl+S
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })

-- Quit with Ctrl+Q
vim.keymap.set({ "n", "i", "v" }, "<C-q>", "<Esc>:q<CR>", { desc = "Quit" })

-- Undo with Ctrl+Z
vim.keymap.set({ "n", "i" }, "<C-z>", "<Esc>u", { desc = "Undo" })

-- Select all with Ctrl+A
vim.keymap.set({ "n", "i" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- Copy with Ctrl+C and keep selection
vim.keymap.set("v", "<C-c>", '"+ygv', { desc = "Copy to clipboard and keep selection" })

-- Paste with Ctrl+V
vim.keymap.set({ "n", "i" }, "<C-v>", '<Esc>"+p', { desc = "Paste from clipboard" })
vim.keymap.set("v", "<C-v>", '"+P', { desc = "Paste over selection" })

-- Cut with Ctrl+X
vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut to clipboard" })

-- Delete selection with backspace/delete (AGGRESSIVE OVERRIDE)
vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "User" }, {
  callback = function()
    vim.schedule(function()
      pcall(vim.keymap.set, "v", "<BS>", "c", { desc = "Delete selection", buffer = true, remap = true })
      pcall(vim.keymap.set, "v", "<Del>", "c", { desc = "Delete selection", buffer = true, remap = true })
    end)
  end,
})
