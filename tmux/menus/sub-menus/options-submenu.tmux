


set -s @_uplvl  "#[default bold]\uf3bf#[default]"
set -s @_title   " #[fg=colour30]FILE#[default bold] \uf105 #{@_opts} Options"

display-menu -T "#{E:@_title}" -x 0 -y 0 \
" #{@_serv} statusbar_name"           n   ''                                                     \
" #{@_file} color_scheme"             n   ''                                                     \
" #{@_cmda} client_key_table"         n   ''                                                     \
"#{@_sep}"                            ''  ''                                                     \
" #{@_file} terminfor_host"           n   ''                                                     \
" #{@_file} glyphicons_file"          n   ''                                                     \
"#{@_sep}"                            ''  ''                                                     \
" #{@_term} date_time_format"         n   ''                                                     \
" #{@_term} clock_work_mode"          n   ''                                                     \
"#{@_sep}"                            ''  ''                                                     \
" #{@_sett} Restore Options"          n   ''                                                     \
""                                    \
"#[bold fg=colour30]#{@_uplvl} Back  " C-h 'source ~/Projects/dotfiles/tmux/menus/File-menu.tmux' \
