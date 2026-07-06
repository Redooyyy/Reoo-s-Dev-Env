return {
  "Redooyyy/flutter-deps.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- async jobs
    -- optionally: "stevearc/dressing.nvim" for nicer vim.ui.select UI
  },
  config = function()
    -- no setup() call, because init.lua doesn’t define it
    vim.keymap.set("n", "<leader>pd", function()
      require("flutter_deps").add_dependency()
    end, { desc = "Add pub.dev dependency" })
  end,
}
