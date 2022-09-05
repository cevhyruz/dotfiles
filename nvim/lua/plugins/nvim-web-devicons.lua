local devicon = require "nvim-web-devicons"

-- require("nvim-web-devicons").set_default_icon('', '#6d8086')

devicon.setup {
  override = {
    tmux = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
    },
  },
  default = true
}
