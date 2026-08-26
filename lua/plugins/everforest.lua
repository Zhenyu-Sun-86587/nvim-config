return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.everforest_background = "medium"
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("nightfox").setup({
          options = {
            transparent = true,
          },
        })
        vim.cmd.colorscheme("nightfox")
      end,
    },
  },
}
