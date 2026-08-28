local image_extensions = {
  avif = true,
  bmp = true,
  gif = true,
  heic = true,
  jpeg = true,
  jpg = true,
  png = true,
  tif = true,
  tiff = true,
  webp = true,
}

local function preview_image_in_wezterm()
  local file = vim.api.nvim_buf_get_name(0)
  local extension = file:match("%.([^.]+)$")

  if file == "" or vim.fn.filereadable(file) == 0 or not extension or not image_extensions[extension:lower()] then
    vim.notify("Current buffer is not a readable image file", vim.log.levels.WARN)
    return
  end

  vim.fn.jobstart({ "wezterm", "start", "--new-tab", "--", "wezterm", "imgcat", "--hold", file }, { detach = true })
end

-- Snacks bottom terminal 高度记忆
local terminal_height_file = vim.fn.stdpath("state") .. "/snacks-terminal-height"
local terminal_height = 0.30

local function clamp_terminal_height(value)
  return math.max(0.15, math.min(0.60, value))
end

-- 启动时读取上一次 terminal 高度
do
  local ok, lines = pcall(vim.fn.readfile, terminal_height_file)
  if ok and lines[1] then
    local value = tonumber(lines[1])
    if value then
      terminal_height = clamp_terminal_height(value)
    end
  end
end

local function find_bottom_terminal()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local snacks_win = vim.w[win].snacks_win

      if
        snacks_win
        and snacks_win.position == "bottom"
        and snacks_win.relative == "editor"
      then
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].filetype == "snacks_terminal" then
          return win
        end
      end
    end
  end
end

local function save_terminal_height()
  local win = find_bottom_terminal()
  if not win then
    return
  end

  -- Snacks 对 editor-relative window 本身就是用 vim.o.lines
  -- 计算百分比高度，所以这里按相同基准保存
  local height = vim.api.nvim_win_get_height(win)
  local ratio = clamp_terminal_height(height / math.max(vim.o.lines, 1))

  terminal_height = ratio

  pcall(
    vim.fn.writefile,
    { string.format("%.6f", ratio) },
    terminal_height_file
  )
end

-- 鼠标拖动时 WinResized 会连续触发，做一个简单 debounce
local terminal_resize_generation = 0

local function schedule_save_terminal_height()
  terminal_resize_generation = terminal_resize_generation + 1
  local generation = terminal_resize_generation

  vim.defer_fn(function()
    if generation ~= terminal_resize_generation then
      return
    end

    save_terminal_height()
  end, 200)
end

return {
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gN", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    opts = {},
  },
  {
    "mikavilpas/yazi.nvim",
    cmd = "Yazi",
    init = function()
      vim.env.YAZI_FILE_ONE = "D:/Git/usr/bin/file.exe"
      vim.env.PATH = "C:/Users/SZY/AppData/Local/Microsoft/WinGet/Packages/oschwartz10612.Poppler_Microsoft.Winget.Source_8wekyb3d8bbwe/poppler-25.07.0/Library/bin;"
        .. vim.env.PATH
    end,
    keys = {
      { "<leader>fy", "<cmd>Yazi<cr>", desc = "Yazi File Manager" },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f2>",
      },
    },
  },
  {
    "folke/snacks.nvim",

    opts = {
      terminal = {
        win = {
          -- 普通 Snacks terminal 不再交给 Edgy 管
          w = {
            edgy_disable = true,
          },

          -- bottom terminal 使用上一次保存的高度
          height = function(win)
            if
              win.opts.position == "bottom"
              and win.opts.relative == "editor"
            then
              return terminal_height
            end

            -- 保持 Snacks 原本行为：
            -- float 默认 90%，普通 split 默认 40%
            return win.opts.position == "float" and 0.9 or 0.4
          end,

          on_win = function(win)
            -- bottom terminal 作为普通可自由 resize 的 split
            if
              win.opts.position == "bottom"
              and win.opts.relative == "editor"
            then
              win.opts.wo.winfixheight = false
              vim.wo[win.win].winfixheight = false
            end
          end,
        },
      },
    },

    init = function()
      local group = vim.api.nvim_create_augroup(
        "SnacksTerminalHeightMemory",
        { clear = true }
      )

      vim.api.nvim_create_autocmd("WinResized", {
        group = group,
        callback = schedule_save_terminal_height,
      })

      -- 防止刚拖完窗口马上退出，200ms debounce 还没来得及写盘
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = group,
        callback = save_terminal_height,
      })
    end,

    keys = {
      {
        "<leader>fI",
        preview_image_in_wezterm,
        desc = "Preview Image in WezTerm",
      },
    },
  },
}
