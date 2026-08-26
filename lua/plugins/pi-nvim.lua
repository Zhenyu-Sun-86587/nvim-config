return {
  {
    "Zhenyu-Sun-86587/pi-nvim-window",
    name = "pi-nvim",
    main = "pi-nvim",
    opts = {
      set_default_keymaps = false,
    },
    cmd = {
      "Pi",
      "PiPing",
      "PiSend",
      "PiSendFile",
      "PiSendSelection",
      "PiSendBuffer",
      "PiSessions",
    },
    keys = {
      { "<leader>p", "<cmd>Pi<cr>", mode = { "n", "v" }, desc = "Send to Pi" },
    },
  },
}
