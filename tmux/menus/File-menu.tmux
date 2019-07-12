set -s @_sep '-#[fg=colour243] ------------------------------------ '

#  
# TODO: colors and icons should be provided by the theme

# glyphicons
set -s @_file "#[default bold fg=colour240] #[default]"
set -s @_serv "#[default bold fg=colour240]\uf233 #[default]"
set -s @_srcf "#[default bold fg=yellow]\ue60b #[default]"
set -s @_hook "#[default bold fg=yellow]\uf644 #[default]"
set -s @_cmda "#[default bold fg=yellow]\uf155 #[default]"
set -s @_opts "#[default bold fg=yellow]\uf0ca #[default]"
set -s @_sett "#[default bold fg=yellow]\uf013 #[default]"
set -s @_term "#[default bold fg=yellow]\ue795 #[default]"

set -s @_edit "#[bold]\uf591 #[default]"
set -s @_view "#[bold]\uf06e #[default]"
set -s @_selc "#[bold]\uf46d#[default]"

set -s @_arrL "#[default bold]\uf30a#[default]" #uf060
set -s @_arrR "#[default bold]\uf30b#[default]" #uf061

set -s @_title "#[bold align=centre]     #[fg=colour30] FILE#[default bold fg=colour248]  EDIT  PACKAGES  VIEW  SELECTION      "

display-menu -T "#{@_title}" -x 0 -y 0 \
" #{@_serv} Server Information"               n   ''                                                     \
" #{@_file} Key Bindings"                     n   ''                                                     \
" #{@_cmda} Command Aliases"                  n   ''                                                     \
" #{@_srcf} Sourced Files"                    n   ''                                                     \
"#{@_sep}"                                     ''  ''                                                     \
" #{@_opts} Options #[bold align=right] \uf0da"                          n   'source ~/Projects/dotfiles/tmux/menus/sub-menus/options-submenu.tmux'                                                     \
"#{@_sep}"                                     ''  ''                                                     \
" #{@_hook} Global Hooks"                     n   ''                                                     \
" #{@_file} Local Hooks"                      n   ''                                                     \
"#{@_sep}"                                     ''  ''                                                     \
" #{@_file} Global Environment"               n   ''                                                     \
" #{@_file} Local Environment"                n   ''                                                     \
"#{@_sep}"                                     ''  ''                                                     \
" #{@_term} Outer terminfo Description"       n   ''                                                     \
" #{@_term} Innter terminfo Description"      n   ''                                                     \
"#{@_sep}"                                     ''  ''                                                     \
" #{@_sett} Default Settings"                 n   ''                                                     \
"" \
"#[bold fg=colour30]#{@_arrR}  Next "  C-l 'source ~/Projects/dotfiles/tmux/menus/Edit-menu.tmux' \
