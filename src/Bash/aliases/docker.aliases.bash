

# for ntc5 delete me after your ojt


function dcopy() {
  file="$(\ls | fzf)"
  docker cp "$file" sql1:/tmp/${file}
}


# login
alias dlogin="docker exec -it sql1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -C"

# root shell
alias droot="docker exec -it --user root sql1 'bash'"

# shell
alias dbash="docker exec -it sql1 'bash'"
