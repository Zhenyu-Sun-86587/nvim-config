return {
  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- 锁定稳定版本
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
    },
    cmd = {
      "RemoteStart",
      "RemoteStop",
      "RemoteInfo",
      "RemoteCleanup",
      "RemoteConfigDel",
      "RemoteLog",
    },
    keys = {
      { "<leader>ro", "<cmd>RemoteStart<cr>", desc = "Remote-SSH: Connect (连接远程主机)" },
      { "<leader>rs", "<cmd>RemoteStop<cr>", desc = "Remote-SSH: Stop (断开远程连接)" },
      { "<leader>ri", "<cmd>RemoteInfo<cr>", desc = "Remote-SSH: Info (连接状态信息)" },
    },
    opts = {
      -- 远程主机配置，使用系统自带的 SSH 客户端
      ssh_prompts = {
        {
          match = "password:",
          type = "secret",
          value_type = "static",
          value = "",
        },
        {
          match = "continue connecting (yes/no/[fingerprint])?",
          type = "plain",
          value_type = "static",
          value = "yes",
        },
      },
    },
  },
}
