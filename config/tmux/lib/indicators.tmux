# vi:ft=tmux fdm=marker
# =============================================================================

set -g @indicators on

# Boolean variables supporting icons, characters, and styles.
# with configurable user options for true and false expansion.
#
# Example:
#   Display the string 'on' when the indicator 'foo' is true
#   and 'off' when it is false:
#
#     $ set-option -g @ind-foo-0-char "on"
#     $ set-option -g @ind-foo-1-char "off"
#
# The same applies for icons and styles:
#
#     $ set-option -g @ind-foo-0-icon "🔔"
#     $ set-option -g @ind-foo-1-icon "🔕"
#
#     $ set-option -g @ind-foo-0-style "fg=green"
#     $ set-option -g @ind-foo-1-style "fg=red"
#
# Usage:
#
#   If you want to display wlan status in the statusbar:
#
#     $ set-option -g status-format[0] "#{E:wlan0_ind}"
#
#   @ind-*-char  [string]
#   @ind-*-icon  [string]
#   @ind-*-style [style]
#
#
# If variable is used in statusbar and it's user-option is not defined then,
# it will use the following default user-options:
#
#     @ind-foo-0-icon-def
#     @ind-foo-1-icon-def
#     ...

# =============================================================================



# user options: (change 0 to 1 for true)
#   @ind-wlan0-chars [string]
#   @ind-wlan0-icon  [string]
#   @ind-wlan0-style [styles]

# chars
# set -g @ind-wlan-0-char "Not connected"
# set -g @ind-wlan-1-char "Connected"
# # icons
# set -g @ind-wlan-0-icon "#{@fa-wifi}"
# set -g @ind-wlan-1-icon "#{@fa-wifi}"
# # styles
# set -g @ind-wlan-0-style "bold,fg=colour239"
# set -g @ind-wlan-1-style "bold,fg=white"
#
%hidden ind_wlan=\
"#{?#{==:#(iw wlan0 link),Not connected.},"\
"#[push-default #{@ind-wlan-0-style}]#{E:@ind-wlan-0-icon}#{E:@ind-wlan-0-char}#[pop-default default],"\
"#[push-default #{@ind-wlan-1-style}]#{E:@ind-wlan-1-icon}#{E:@ind-wlan-1-char}#[pop-default default]}"\

# Sound status
%hidden sound=\
"#{?#{==:#(grep -A4 -ri 'Headphone Playback Switch' /proc/asound/card*/* | "\
"grep \"Amp-Out vals.*0x00 0x0\" && echo 'yes' || echo 'no'),yes},"\
"#[push-default #{@process_enabled}]#{@fa-headphones}#[pop-default default],"\
"#[push-default #{@proces_enabled}]#{@fa-volume-up}#[pop-default default]}"

# show if my drive is mounted.
%hidden win_drive=\
"#{?#{!=:#(mount | grep 'on /media/devs'),}, "\
"#[push-default #{@process_enabled}]#{@fa-windows}#[pop-default default], "\
"#[push-default #{@process_disabled}]#{@fa-windows}#[pop-default default]}"
