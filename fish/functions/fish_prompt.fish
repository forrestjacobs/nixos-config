function fish_prompt
  set -l last_pipestatus $pipestatus
  set -lx __fish_last_status $status # Exported for __fish_print_pipestatus

  set -l status_text
  if test $__fish_last_status != 0
    set status_text ' '(__fish_print_pipestatus '[' ']' '|' (set_color $fish_color_status) (set_color $fish_color_error) $last_pipestatus)
  end

  set -l host_color "$fish_color_host"
  if test -n "$TMUX" -o -n "$SSH_CLIENT"
    set host_color "$fish_color_host_remote"
  end

  echo -n -s \
    (set_color $host_color) \
    '@'(string match -r '[^.]*' "$hostname")' ' \
    (set_color $fish_color_cwd) \
    (string replace -r '^'"$HOME"'($|/)' '~$1' "$PWD") \
    "$status_text" \
    (set_color normal) ' > '
end
