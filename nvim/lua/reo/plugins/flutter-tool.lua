return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("flutter-tools").setup({})

    local keymap = vim.keymap
    keymap.set("n", "<leader>cf", "<cmd>Telescope flutter commands<CR>", { desc = "Flutter tool commands" })
  end,
}
