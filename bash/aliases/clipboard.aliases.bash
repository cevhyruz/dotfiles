
if [[ $(command -v xclip) ]]; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -out"
fi

# very useful for things like:
# cat ~/.ssh/id_rsa.pub | pbcopy
