-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 退出插入模式（经典快速 Esc 映射）
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- VS Code 风格：插入模式下 Ctrl+Z 撤销，但继续保持插入模式。
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo" })

-- 翻页与搜索时光标居中
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search match and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search match and center" })

-- 视觉模式连续缩进保持选中状态
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- 粘贴时不覆盖寄存器（丢入黑洞寄存器）
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without overwriting register" })

vim.keymap.set("n", "<leader>h", function()
  Snacks.dashboard()
end, { desc = "Home Dashboard" })
