return {
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose" },
    keys = {
      { "<leader>r", "<cmd>RunCode<cr>", desc = "Run Code" },
      { "<leader>rf", "<cmd>RunFile<cr>", desc = "Run File" },
      { "<leader>rp", "<cmd>RunProject<cr>", desc = "Run Project" },
      { "<leader>rc", "<cmd>RunClose<cr>", desc = "Run Close" },
    },
    opts = {
      mode = "float",
      float = {
        border = "rounded",
        height = 0.8,
        width = 0.8,
        x = 0.5,
        y = 0.5,
        border_hl = "FloatBorder",
        float_hl = "Normal",
        blend = 0,
      },
      filetype = {
        python = "python -u",
        typescript = "deno run",
        javascript = "node",
        c = {
          "cd $dir &&",
          "gcc $fileName -o $fileNameWithoutExt.exe &&",
          "./$fileNameWithoutExt.exe",
        },
        cpp = {
          "cd $dir &&",
          "g++ $fileName -o $fileNameWithoutExt.exe &&",
          "./$fileNameWithoutExt.exe",
        },
        rust = {
          "cd $dir &&",
          "rustc $fileName &&",
          "./$fileNameWithoutExt.exe",
        },
      },
    },
  },
}
