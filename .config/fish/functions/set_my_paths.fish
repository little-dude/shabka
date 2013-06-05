function set_my_paths
  # Add my bin folder
  if test -d "$HOME/.filesystem/bin"
    add_path "$HOME/.filesystem/bin"
  end

  # Add my usr/bin folder
  if test -d "$HOME/.filesystem/usr/bin"
    add_path "$HOME/.filesystem/usr/bin"
  end

  # Add any folder in my opt folders
  if test -d "$HOME/.filesystem/opt/"
    set -l opt_paths (find "$HOME/.filesystem/opt/" -maxdepth 2 -name bin -type d)

    if count $opt_paths > 0
      for dir in $opt_paths
        add_path "$dir"
      end
    end
  end
end
