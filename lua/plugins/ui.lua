return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
        },
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      cursor_color = "#7aa2f7",
      hide_target_hack = false,
      never_draw_over_target = false,

      smear_between_buffers = false,
      smear_between_neighbor_lines = true,
      smear_insert_mode = false,
      smear_terminal_mode = false,

      stiffness = 0.78,
      trailing_stiffness = 0.62,
      damping = 0.94,
      max_length = 10,
      distance_stop_animating = 0.25,
      time_interval = 17,

      particles_enabled = false,
    },
  },
}
