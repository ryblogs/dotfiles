-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Enable mouse support for shift+click selection
vim.opt.mouse = "a"           -- Enable mouse in all modes
vim.opt.mousemodel = "extend" -- Right-click extends selection

-- Save with Ctrl+S
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file", silent = true })
vim.keymap.set("i", "<C-s>", "<C-o>:w<CR>", { desc = "Save file", silent = true })
vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>", { desc = "Save file", silent = true })

-- Quit with Ctrl+Q
vim.keymap.set("n", "<C-q>", ":q<CR>", { desc = "Quit", silent = true })
vim.keymap.set("i", "<C-q>", "<Esc>:q<CR>", { desc = "Quit", silent = true })
vim.keymap.set("v", "<C-q>", "<Esc>:q<CR>", { desc = "Quit", silent = true })

-- Undo with Ctrl+Z
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo" })

-- Redo with Ctrl+Shift+Z
vim.keymap.set("n", "<C-S-z>", "<C-r>", { desc = "Redo" })
vim.keymap.set("i", "<C-S-z>", "<C-o><C-r>", { desc = "Redo" })

-- Select all with Ctrl+A
vim.keymap.set("n", "<C-a>", ":<C-u>normal! ggVG<CR>", { desc = "Select all" })
vim.keymap.set("i", "<C-a>", "<Esc>:<C-u>normal! ggVG<CR>", { desc = "Select all" })

-- Copy with Ctrl+C and keep selection
vim.keymap.set("v", "<C-c>", '"+ygv', { desc = "Copy to clipboard and keep selection" })

-- Paste with Ctrl+V
vim.keymap.set("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })
vim.keymap.set("v", "<C-v>", '"+P', { desc = "Paste over selection" })

-- Cut with Ctrl+X
vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut to clipboard" })

-- Comment/uncomment with Ctrl+/ and adjust cursor position
-- A single, smart function to handle commenting for all modes.
local function smart_toggle()
    -- Get the current mode and the cursor's current position.
    local mode = vim.fn.mode()
    local original_pos = vim.api.nvim_win_get_cursor(0)
    local original_line = vim.fn.getline(original_pos[1])

    -- Execute the comment command based on the mode.
    if mode:find('[vV\x16]') then
        vim.cmd("'<,'>Commentary")
    else
        vim.cmd("Commentary")
    end

    -- Calculate the new cursor position.
    local new_line = vim.fn.getline(original_pos[1])
    local length_diff = #new_line - #original_line
    local new_col = math.max(0, original_pos[2] + length_diff)

    -- If in visual mode, restore the selection.
    if mode:find('[vV\x16]') then
        vim.cmd("normal! gv")
    else
        -- Move the cursor to its new calculated position.
        vim.api.nvim_win_set_cursor(0, { original_pos[1], new_col })
    end
end

-- Keymap for Normal Mode
vim.keymap.set("n", "<C-/>", smart_toggle, { desc = "Toggle comment" })

-- Keymap for Visual Mode
vim.keymap.set("v", "<C-/>", smart_toggle, { desc = "Toggle comment" })

-- Keymap for Insert Mode - use <C-o> to execute normal command and auto-return
vim.keymap.set("i", "<C-/>", "<C-o>:lua smart_toggle()<CR>", { desc = "Toggle comment" })

-- Toggle file explorer with Ctrl+B (LazyVim uses neo-tree)
vim.keymap.set("n", "<C-b>", "<leader>e", { desc = "Toggle file explorer", remap = true })

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

-- Double-click to select word (common IDE behavior)
vim.keymap.set("n", "<2-LeftMouse>", "viw", { desc = "Select word under mouse" })
vim.keymap.set("i", "<2-LeftMouse>", "<Esc>viw", { desc = "Select word under mouse" })

-- Triple-click to select line (common IDE behavior)
vim.keymap.set("n", "<3-LeftMouse>", "V", { desc = "Select line under mouse" })
vim.keymap.set("i", "<3-LeftMouse>", "<Esc>V", { desc = "Select line under mouse" })

-- Command palette with Ctrl+Shift+P (like Helix/VSCode)
vim.keymap.set("n", "<C-S-p>", ":Telescope commands<CR>", { desc = "Command palette", silent = true })
vim.keymap.set("i", "<C-S-p>", "<Esc>:Telescope commands<CR>", { desc = "Command palette", silent = true })
vim.keymap.set("v", "<C-S-p>", "<Esc>:Telescope commands<CR>", { desc = "Command palette", silent = true })

-- Delete selection with backspace/delete (AGGRESSIVE OVERRIDE)
vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "User" }, {
    callback = function()
        vim.schedule(function()
            pcall(vim.keymap.set, "v", "<BS>", "c", { desc = "Delete selection", buffer = true, remap = true })
            pcall(vim.keymap.set, "v", "<Del>", "c", { desc = "Delete selection", buffer = true, remap = true })
        end)
    end,
})

-- Right-click context menu with LSP actions
local function show_context_menu()
    local actions = {
        {
            "Go to Definition",
            function()
                vim.lsp.buf.definition()
            end,
        },
        {
            "Go to Declaration",
            function()
                vim.lsp.buf.declaration()
            end,
        },
        {
            "Find References",
            function()
                require("telescope.builtin").lsp_references()
            end,
        },
        {
            "Show Hover Info",
            function()
                vim.lsp.buf.hover()
            end,
        },
        {
            "Rename Symbol",
            function()
                vim.lsp.buf.rename()
            end,
        },
        {
            "Code Actions",
            function()
                vim.lsp.buf.code_action()
            end,
        },
        {
            "Go to Implementation",
            function()
                vim.lsp.buf.implementation()
            end,
        },
        {
            "Go to Type Definition",
            function()
                vim.lsp.buf.type_definition()
            end,
        },
    }

    -- Filter to only show actions available for current buffer
    local available_actions = {}
    for _, action in ipairs(actions) do
        if #vim.lsp.get_active_clients({ bufnr = 0 }) > 0 then
            table.insert(available_actions, action)
        end
    end

    if #available_actions == 0 then
        vim.notify("No LSP actions available")
        return
    end

    vim.ui.select(
        vim.tbl_map(function(action)
            return action[1]
        end, available_actions),
        { prompt = "LSP Actions:" },
        function(choice, idx)
            if choice and available_actions[idx] then
                available_actions[idx][2]()
            end
        end
    )
end

-- Map right-click to show context menu
vim.keymap.set("n", "<RightMouse>", show_context_menu, { desc = "Show context menu" })
vim.keymap.set("i", "<RightMouse>", function()
    vim.cmd("stopinsert")
    show_context_menu()
end, { desc = "Show context menu" })
