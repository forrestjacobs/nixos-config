function fish_greeting
  set -l old_pwd $PWD
  cd "$HOME/.config"
  set -l behind (git 'rev-list' '^HEAD' 'origin/main' '--count')
  if test "$behind" != "0"
    echo "~/.config is behind 'origin/main' by $behind commits."
  end
  cd $old_pwd
end
