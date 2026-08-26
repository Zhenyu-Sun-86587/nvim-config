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
      ssh_config = {
        ssh_binary = "ssh",
        scp_binary = "scp",
        -- 针对 Windows 路径进行正斜杠规范化，避免 sh 展开时转义丢失
        ssh_config_file_paths = {
          vim.fs.normalize(vim.fn.expand("~/.ssh/config")),
        },
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
  },
}
