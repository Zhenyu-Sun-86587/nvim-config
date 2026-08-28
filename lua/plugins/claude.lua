return {
  {
    "coder/claudecode.nvim",
    lazy = false, -- 禁用懒加载，在 Neovim 启动时即初始化配置，避免首次打开按键时使用默认尺寸与未透明高亮
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = {
        provider = "auto", -- 自动使用 snacks.nvim 终端或内置终端
        split_side = "right",
        split_width_percentage = 0.30, -- 默认侧边栏宽度设为 30%
        diff_split_width_percentage = 0.45, -- 审查 Diff 时的侧边栏宽度
        snacks_win_opts = {
          width = 0.30,
          backdrop = false,

          -- Claude Code terminal 不交给 edgy.nvim 管理
          w = {
            edgy_disable = true,
          },

          wo = {
            winfixwidth = false,
            winhighlight = "Normal:Normal,NormalNC:NormalNC,SignColumn:Normal,EndOfBuffer:Normal",
          },
        },
      },
    },
    config = function(_, opts)
      -- 1. 加载并应用插件配置
      require("claudecode").setup(opts)

      -- 2. 彻底清除终端、浮窗和 Snacks 相关高亮组的背景色，保证全透明
      local function apply_transparency()
        local transparent_hls = {
          "SnacksNormal",
          "SnacksNormalNC",
          "SnacksWinBar",
          "SnacksWinBarNC",
          "NormalFloat",
          "FloatBorder",
          "FloatTitle",
          "Terminal",
          "TermNormal",
          "TermNormalNC",
        }
        for _, hl in ipairs(transparent_hls) do
          vim.api.nvim_set_hl(0, hl, { bg = "none", ctermbg = "none" })
        end
      end

      -- 立即执行一次
      apply_transparency()

      -- 在主题切换或加载时持续保持透明
      local group = vim.api.nvim_create_augroup("ClaudeCodeTransparency", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        pattern = "*",
        callback = function()
          apply_transparency()
        end,
      })

      -- 3. 注册在终端打字模式 (t) 与普通模式 (n) 下通用的窗口调大小快捷键
      -- Alt + 左/右方向键 实时调整侧边栏宽度（无需按 Ctrl+\ Ctrl-N 退出终端模式）
      vim.keymap.set({ "n", "t" }, "<A-Left>", "<cmd>vertical resize -3<cr>", { desc = "减小 Claude 侧边栏宽度" })
      vim.keymap.set({ "n", "t" }, "<A-Right>", "<cmd>vertical resize +3<cr>", { desc = "增大 Claude 侧边栏宽度" })
      vim.keymap.set({ "n", "t" }, "<A-h>", "<cmd>vertical resize -3<cr>", { desc = "减小 Claude 侧边栏宽度" })
      vim.keymap.set({ "n", "t" }, "<A-l>", "<cmd>vertical resize +3<cr>", { desc = "增大 Claude 侧边栏宽度" })
    end,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "切换 Claude Code 终端" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "聚焦 Claude Code" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "恢复 Claude Code 会话" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "继续 Claude Code" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "选择 Claude 模型" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "添加当前 Buffer 到上下文" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "发送选中代码到 Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "添加文件到 Claude",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
      -- Diff 审查与采纳
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "接受 Diff 修改" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "拒绝 Diff 修改" },
    },
  },
}
