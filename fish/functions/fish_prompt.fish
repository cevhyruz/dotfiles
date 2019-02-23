function fish_prompt
    set_color cyan
    echo -e (pwd)
    set_color normal
    echo -n ' $ '
end
