return {
  "Redooyyy/floatbar-nvim",
  config = function()
    -- Enable true colors globally (optional if not in init.lua)
    vim.o.termguicolors = true

    -- Setup plugin with default config
    require("floatbar").setup({
      width = 0.7, -- 70% width
      height = 0.7, -- 70% height
      winblend = 0, -- transparency
      border = "rounded", -- rounded border
      keymaps = {
        toggle = "<C-t>", -- default kehymaps
      },
    })
  end,
}
