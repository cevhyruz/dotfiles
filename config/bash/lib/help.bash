_help_lines=(
    '#|Navigation'
    'ctrl-r|history picker'
    'ctrl-g|git branch switcher'
    'ctrl-/|this help'
    ''
    '#|Prompt'
    'ctrl-u|clear line'
    'ctrl-w|delete word'
    'alt-.|last argument'
)

_help_popup() {
    _tui_init
    _tui_status "this is status"
    _tui_popup_geom_center help ${#_help_lines[@]} 60
    _tui_frame_begin
    _tui_popup_sync help
    _tui_popup_draw help ' Shortcuts ' _help_lines 8 dim
    _tui_frame_end
    _tui_key            # any key closes
    _tui_deinit
}

bind -m vi-command -x '"?": _help_popup'

# This should be a per-directory monitor.
# or a quick something
#
# Features:
#
# [ ] git status / local settings
# [ ] alerts that shows all pending alerts
# [ ] commit motivator
# [ ] env (nodenv, pyenv, venv)
# [ ] todo/fixme/hacks manager / tasks manager
# [ ] Notes
# [ ] list of files
