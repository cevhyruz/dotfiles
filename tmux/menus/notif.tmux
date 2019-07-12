

# This will be the template for all popup notifation messages
set -s @_title   "#[align=centre bold fg=colour30] Oops! "

set -s @_sep '-#[fg=colour243]---------------------------------------------'

display-menu -T "#{E:@_title}" -x 73 -y 28 \
" "                                                                   ''  ''             \
"- #{@_sett}#[fg=colour255] Something has went wrong on installation" ''  ''             \
"-#[fg=colour255]    plese selec another file in the directory"       ''  ''             \
"- "                                                                  ''  ''             \
"#{@_sep}"                            ''  ''                                                     \
"#[bold fg=colour30]Proceed"                                                             'Y' 'display you'  \
"#[bold fg=colour167]Cancel"                                                              'N' 'display exit' \


# TODO: can I add sleep then send-keys interrupts,
# to emulate popup message timeout?
