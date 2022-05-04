
%hidden _git_branch=\
"#( cd #{pane_current_path}"\
" && git symbolic-ref --quiet --short HEAD "\
"|| git rev-parse --short HEAD )"

%hidden _git_latest_commit=\
"#( cd #{pane_current_path}"\
"&& git rev-parse --short HEAD )"
