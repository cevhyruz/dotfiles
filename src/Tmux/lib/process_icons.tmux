# vi:ft=tmux
# vi:ft=tmux fdm=marker
#
# Live process icons for tmux.

# @TODO: add this icon  , for wired connection.
# Wlan0 status
%hidden wlan0_icon=\
"#{?#{==:#(iw wlan0 link),Not connected.},"\
"#[push-default #{@process_disabled}]#{@fa-wifi}#[pop-default default],"\
"#[push-default #{@process_enabled}]#{@fa-wifi}#[pop-default default]}"\

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
