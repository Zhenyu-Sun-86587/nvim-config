-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.g.autoformat = false
vim.g.ai_cmp = false

-- Windows PowerShell 核心环境适配（确保终端和子进程 jobstart 执行正常）
if vim.fn.has("win32") == 1 then
  if vim.fn.executable("pwsh") == 1 then
    vim.opt.shell = "pwsh"
  elseif vim.fn.executable("powershell") == 1 then
    vim.opt.shell = "powershell"
  end

  if vim.opt.shell:get():match("powershell") or vim.opt.shell:get():match("pwsh") then
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
    vim.opt.shellredir = "2>&1 | Out-File -FilePath %s -Encoding utf8; exit $LastExitCode"
    vim.opt.shellpipe = "2>&1 | Tee-Object -FilePath %s; exit $LastExitCode"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
  end
end
