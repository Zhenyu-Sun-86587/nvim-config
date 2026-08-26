local image_extensions = {
  avif = true,
  bmp = true,
  gif = true,
  heic = true,
  jpeg = true,
  jpg = true,
  png = true,
  tif = true,
  tiff = true,
  webp = true,
}

local function preview_image_in_wezterm()
  local file = vim.api.nvim_buf_get_name(0)
  local extension = file:match("%.([^.]+)$")

  if file == "" or vim.fn.filereadable(file) == 0 or not extension or not image_extensions[extension:lower()] then
    vim.notify("Current buffer is not a readable image file", vim.log.levels.WARN)
    return
  end

  vim.fn.jobstart({ "wezterm", "start", "--new-tab", "--", "wezterm", "imgcat", "--hold", file }, { detach = true })
end

return {
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gN", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    opts = {},
  },
  {
    "mikavilpas/yazi.nvim",
    cmd = "Yazi",
    init = function()
      vim.env.YAZI_FILE_ONE = "D:/Git/usr/bin/file.exe"
      vim.env.PATH = "C:/Users/SZY/AppData/Local/Microsoft/WinGet/Packages/oschwartz10612.Poppler_Microsoft.Winget.Source_8wekyb3d8bbwe/poppler-25.07.0/Library/bin;"
        .. vim.env.PATH
    end,
    keys = {
      { "<leader>fy", "<cmd>Yazi<cr>", desc = "Yazi File Manager" },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f2>",
      },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fI",
        preview_image_in_wezterm,
        desc = "Preview Image in WezTerm",
      },
    },
  },
}
