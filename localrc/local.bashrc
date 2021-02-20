# vim:ft=sh

# shellcheck disable=SC2112

# ----------------------------------------------------------------------------
# https://dev.to/jay_js/setting-up-flutter-without-android-studio-olo
# ----------------------------------------------------------------------------

# Setting up flutter without android studio

# android home
# export ANDROID_HOME=/usr/lib/Android
# export PATH=$ANDROID_HOME/tools:$PATH
# export PATH=$ANDROID_HOME/tools/bin:$PATH
# export PATH=$ANDROID_HOME/platform-tools:$PATH

# android sdk root
# export ANDROID_SDK_ROOT=/usr/lib/Android
# export PATH=$ANDROID_SDK_ROOT:$PATH

# gradle
# export GRADLE_HOME=/opt/gradle/gradle-5.6.2
# export PATH=$GRADLE_HOME/bin:$PATH


# export GEM_HOME=~/.ruby
# export PATH=$PATH:$GEM_HOME/bin

# ----------------------------------------------------------------------------
# Downloaded tools that I'm too lazy to even figure out where the hell
# should I put them so as to not clutter my $HOME directory.
# ----------------------------------------------------------------------------

# export PATH=$PATH:$ANDROID_HOME/tools/bin

# ----------------------------------------------------------------------------

# map capslock to backspace and double shift to capslock,
# also make capslock (now backspace) repeatable when on-hold.
alias k='setxkbmap -option caps:backspace -option shift:both_capslock && xset r 66'

alias tmuxtest='tmux -Ltmuxtest -f /home/devs/Projects/cloned-repo/tmux/tmux.conf'
#alias tmux='tmux kill-serve; tmux'
#alias exit='tmux kill-server'

#[ -e "$HOME/.config/tmuxvm/bin" ] && export PATH="$HOME/.config/tmuxvm/bin:$PATH"



#[ -z "${TVM_CURRENT}" ] && {
  #readonly PREV_PATH="${PATH}"
  #export PATH="${HOME}/.tvm/3.1/bin:${PATH}"
#}

#function tvm() {

  #if [[ "${1}" == 'use' ]]; then
    #if [[ -d "${HOME}/.tvm/${2}" ]]; then
      #export TVM_CURRENT="${2}"
      #echo 'switching...';
      #sleep .500;
      ## restore path
      #export PATH="${PREV_PATH}"
      ## add new version to path
      #export PATH="${HOME}/.tvm/${TVM_CURRENT}/bin:${PATH}"
      #echo "Now using tmux ${TVM_CURRENT}";
    #else
      #echo "tmux ${2} is not installed yet"
    #fi
  #fi

#}


function fman() {
  man -k . | fzf --preview $"echo {} | tr -d '()' | awk '{printf \"%s \", \$2} {print \$1}' | xargs -r man"
}
 


# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
