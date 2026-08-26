return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      -- 默认使用 Ctrl+N 选中下一个词，Ctrl+Down / Ctrl+Up 添加垂直光标
      vim.g.VM_default_mappings = 1
    end,
  },
}
