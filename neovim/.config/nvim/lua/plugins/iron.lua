return {
  "Vigemus/iron.nvim",
  keys = {
    { "<leader>rs", "<cmd>IronRepl<cr>", desc = "Start REPL" },
    { "<leader>rr", "<cmd>IronRestart<cr>", desc = "Restart REPL" },
    { "<leader>rf", "<cmd>IronFocus<cr>", desc = "Focus REPL" },
    { "<leader>rh", "<cmd>IronHide<cr>", desc = "Hide REPL" },
  },
  config = function()
    local iron = require("iron.core")

    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          python = {
            command = { "ipython", "--no-autoindent" },
          },
        },
        repl_open_cmd = require("iron.view").right(50),
      },
      keymaps = {
        send_motion = "<leader>rc",
        visual_send = "<leader>rc",
        send_line = "<leader>rl",
        send_file = "<leader>rf",
        send_until_cursor = "<leader>ru",
        interrupt = "<leader>r<space>",
        exit = "<leader>rq",
        clear = "<leader>rcl",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })

    -- VSCode-like Ctrl+Enter behavior
    vim.keymap.set("n", "<C-CR>", function()
      iron.send_line()
      vim.cmd("normal! j")
    end, { desc = "Send line and move down" })

    -- Send selection + auto-execute with Enter
    vim.keymap.set("v", "<C-CR>", function()
      iron.visual_send()
      -- Send an extra Enter to execute the code
      -- vim.defer_fn(function()
      -- iron.send(nil, "\n")
      -- end, 100) -- Small delay to ensure the selection is sent first
    end, { desc = "Send visual selection and execute" })
  end,
}
