local function add_tool_directory(executable, directory)
  if vim.fn.executable(executable) == 0 and vim.fn.isdirectory(directory) == 1 then
    vim.env.PATH = directory .. ";" .. vim.env.PATH
  end
end

add_tool_directory("rg", "C:/Users/SZY/AppData/Local/Programs/Cindy/resources/tools/ripgrep")

local fd_executables = vim.fn.glob(
  vim.fn.expand("$LOCALAPPDATA/Microsoft/WinGet/Packages/sharkdp.fd_*/fd-*/fd.exe"),
  false,
  true
)

if #fd_executables > 0 then
  add_tool_directory("fd", vim.fn.fnamemodify(fd_executables[1], ":h"))
end
