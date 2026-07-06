return {
  {
    "wa11breaker/flutter-bloc.nvim",
    ft = "dart",
    config = function()
      require("flutter-bloc").setup({
        bloc_type = "default",
        use_sealed_classes = false,
      })

      vim.keymap.set("n", "<Leader>bb", function()
        require("flutter-bloc").create_bloc()
      end, { desc = "Create Flutter Bloc" })

      vim.keymap.set("n", "<Leader>bc", function()
        require("flutter-bloc").create_cubit()
      end, { desc = "Create Flutter Cubit" })
    end,
  },

  {
    "RobertPietraru/bloc.nvim",
    ft = "dart",
    dependencies = {
      {
        "nvimtools/none-ls.nvim",
        name = "null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    config = function()
      require("bloc").setup()
    end,
  },
}
