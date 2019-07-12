
# set -s @_title   "#[bold align=centre]      FILE  EDIT #[fg=colour30] PACKAGES#[default bold fg=colour248]  VIEW  SELECTION      "
set -s @_title   "#[bold align=centre]      FILE  EDIT  PACKAGES #[fg=colour30] VIEW#[default bold fg=colour248]  SELECTION      "

display-menu -T "#{@_title}" -x 0 -y 0 \
" #{@_serv} View Information"                n   ''                                                     \
" #{@_file} Key Bindings"                   n   ''                                                     \
" #{@_cmda} Command Aliases"                n   ''                                                     \
" #{@_srcf} Sourced Files"                  n   ''                                                     \
"#{@_sep}"                                  ''  ''                                                     \
" #{@_opts} Options"                        n   ''                                                     \
" #{@_opts} User Options"                   n   ''                                                     \
"#{@_sep}"                                  ''  ''                                                     \
" #{@_hook} Global Hooks"                   n   ''                                                     \
" #{@_file} Local Hooks"                    n   ''                                                     \
"#{@_sep}"                                  ''  ''                                                     \
" #{@_file} Global Environment"             n   ''                                                     \
" #{@_file} Local Environment"              n   ''                                                     \
"#{@_sep}"                                  ''  ''                                                     \
" #{@_term} Outer terminfo Description"     n   ''                                                     \
" #{@_term} Innter terminfo Description"    n   ''                                                     \
"#{@_sep}"                                  ''  ''                                                     \
" #{@_sett} Default Settings"               n   ''                                                     \
""                                          \
"#[bold fg=colour30] Prev Menu  #{@_arrL}" C-h 'source ~/Projects/dotfiles/tmux/menus/Packages-menu.tmux' \
"#[bold fg=colour30] Next Menu  #{@_arrR}"  C-l 'source ~/Projects/dotfiles/tmux/menus/Selection-menu.tmux' \
