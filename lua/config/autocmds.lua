-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local cpp_filetypes = { "c", "cpp", "cuda", "objc", "objcpp" }

vim.api.nvim_create_autocmd("FileType", {
  pattern = cpp_filetypes,
  callback = function(event)
    local options = vim.bo[event.buf]
    options.tabstop = 4
    options.shiftwidth = 4
    options.softtabstop = 4
    options.expandtab = true
  end,
})

-- Tree-sitter 的 C++ 缩进在 `else`、`if (...)` 等未完成语句后偶尔会把
-- 新行当作顶层。输入自动配对的 `{}` 时，继承控制语句所在行的缩进。
vim.api.nvim_create_autocmd("TextChangedI", {
  callback = function(event)
    if not vim.tbl_contains(cpp_filetypes, vim.bo[event.buf].filetype) or vim.api.nvim_get_current_buf() ~= event.buf then
      return
    end

    local row, column = unpack(vim.api.nvim_win_get_cursor(0))
    if row <= 1 then
      return
    end

    local line = vim.api.nvim_buf_get_lines(event.buf, row - 1, row, false)[1]
    local current_indent = line:match("^(%s*)") or ""
    local content = line:sub(#current_indent + 1)
    if not content:match("^{}%s*$") then
      return
    end

    local previous = vim.api.nvim_buf_get_lines(event.buf, row - 2, row - 1, false)[1]
    local header = previous:gsub("%s+$", "")
    local is_allman_header = header:match("^%s*else%s*$")
      or header:match("^%s*do%s*$")
      or header:match("^%s*try%s*$")
      or header:match("^%s*catch%s*%b()%s*$")
      or header:match("^%s*if%s*%b()%s*$")
      or header:match("^%s*for%s*%b()%s*$")
      or header:match("^%s*while%s*%b()%s*$")
      or header:match("^%s*switch%s*%b()%s*$")

    if not is_allman_header then
      return
    end

    local expected_indent = previous:match("^(%s*)") or ""
    if current_indent == expected_indent then
      return
    end

    vim.api.nvim_buf_set_lines(event.buf, row - 1, row, false, { expected_indent .. content })
    vim.api.nvim_win_set_cursor(0, { row, math.max(0, column + #expected_indent - #current_indent) })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.c", "*.cc", "*.cpp", "*.cxx", "*.h", "*.hpp" },
  callback = function(event)
    local lines = vim.api.nvim_buf_get_lines(event.buf, 0, -1, false)
    local changed = false

    for index, line in ipairs(lines) do
      if line:sub(-1) == "\r" then
        lines[index] = line:sub(1, -2)
        changed = true
      end
    end

    if changed then
      vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, lines)
      vim.notify("已移除文件中的 ^M 字符；保存一次即可永久修复", vim.log.levels.INFO)
    end
  end,
})
