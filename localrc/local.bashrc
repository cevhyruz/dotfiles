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


#function exit() {
  #if pgrep tmux; then
    #tmux kill-server
  #else
    #builtin exit
  #fi
#}

#function tmux() {
  #echo 'test'
#}
