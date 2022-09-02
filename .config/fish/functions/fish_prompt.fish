function fish_prompt
  set -l last_pipestatus $pipestatus
  set -lx __fish_last_status $status # Exported for __fish_print_pipestatus

  set -l status_text
  if test $__fish_last_status != 0
    set status_text ' '(__fish_print_pipestatus '[' ']' '|' (set_color $fish_color_status) (set_color $fish_color_error) $last_pipestatus)
  end

  echo -n -s \
    (set_color $fish_color_cwd) \
    (string replace -ar '([^/]{2})[^/]*/' '$1/' (string replace -r '^'"$HOME"'($|/)' '~$1' $PWD)) \
    "$status_text" \
    (set_color normal) ' > '
end
