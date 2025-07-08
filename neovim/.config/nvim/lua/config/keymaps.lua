-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Save with Ctrl+S
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<C-o>:w<CR>", { desc = "Save file" })
vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })

-- Quit with Ctrl+Q
vim.keymap.set("n", "<C-q>", ":q<CR>", { desc = "Quit" })
vim.keymap.set("i", "<C-q>", "<Esc>:q<CR>", { desc = "Quit" })
vim.keymap.set("v", "<C-q>", "<Esc>:q<CR>", { desc = "Quit" })

-- Undo with Ctrl+Z
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo" })

-- Redo with Ctrl+Shift+Z
vim.keymap.set("n", "<C-S-z>", "<C-r>", { desc = "Redo" })
vim.keymap.set("i", "<C-S-z>", "<C-o><C-r>", { desc = "Redo" })

-- Select all with Ctrl+A
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- Copy with Ctrl+C and keep selection
vim.keymap.set("v", "<C-c>", '"+ygv', { desc = "Copy to clipboard and keep selection" })

-- Paste with Ctrl+V
vim.keymap.set("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })
vim.keymap.set("v", "<C-v>", '"+P', { desc = "Paste over selection" })

-- Cut with Ctrl+X
vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut to clipboard" })

-- Alternative: Use Ctrl+; for commenting

-- Toggle file explorer with Ctrl+B (LazyVim uses neo-tree)
vim.keymap.set("n", "<C-b>", ":Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- Indent with Tab in visual mode
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })

-- Unindent with Shift+Tab in visual mode and insert mode
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Unindent current line" })

-- Select text with Shift+Arrow keys
vim.keymap.set("n", "<S-Up>", "vk", { desc = "Select line up" })
vim.keymap.set("n", "<S-Down>", "vj", { desc = "Select line down" })
vim.keymap.set("n", "<S-Left>", "vh", { desc = "Select character left" })
vim.keymap.set("n", "<S-Right>", "vl", { desc = "Select character right" })

vim.keymap.set("i", "<S-Up>", "<Esc>vk", { desc = "Select line up" })
vim.keymap.set("i", "<S-Down>", "<Esc>vj", { desc = "Select line down" })
vim.keymap.set("i", "<S-Left>", "<Esc>vh", { desc = "Select character left" })
vim.keymap.set("i", "<S-Right>", "<Esc>vl", { desc = "Select character right" })

-- Extend selection with Shift+Arrow keys when already in visual mode
vim.keymap.set("v", "<S-Up>", "k", { desc = "Extend selection up" })
vim.keymap.set("v", "<S-Down>", "j", { desc = "Extend selection down" })
vim.keymap.set("v", "<S-Left>", "h", { desc = "Extend selection left" })
vim.keymap.set("v", "<S-Right>", "l", { desc = "Extend selection right" })

-- Delete selection with backspace/delete (AGGRESSIVE OVERRIDE)
vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "User" }, {
  callback = function()
    vim.schedule(function()
      pcall(vim.keymap.set, "v", "<BS>", "c", { desc = "Delete selection", buffer = true, remap = true })
      pcall(vim.keymap.set, "v", "<Del>", "c", { desc = "Delete selection", buffer = true, remap = true })
    end)
  end,
})
