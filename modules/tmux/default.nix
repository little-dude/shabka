{ extraConfig ? ""
, extraPlugins ? []
# TODO: Move the keyboard layout into modules similar to how themes are structured.
, keyboardLayout ? "qwerty"
, pkgs
}:

with pkgs.lib;

let

  # TODO(high): Each color theme is defining it's own status format. The format
  # should be unified and nix should interpolate to set the correct format

  tmuxVimAwarness = ''
    # Smart pane switching with awareness of Vim splits.
    # See: https://github.com/christoomey/vim-tmux-navigator
    is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
    bind-key -n M-n if-shell "$is_vim" "send-keys M-n"  "select-pane -L"
    bind-key -n M-e if-shell "$is_vim" "send-keys M-e"  "select-pane -D"
    bind-key -n M-i if-shell "$is_vim" "send-keys M-i"  "select-pane -U"
    bind-key -n M-o if-shell "$is_vim" "send-keys M-o"  "select-pane -R"
  '';

  colemakBindings = (builtins.readFile (./keyboard_layouts + "/${keyboardLayout}.conf"));

  copyPaste =
    if pkgs.stdenv.isLinux then ''
      # copy/paste to system clipboard
      bind-key C-p run "${getBin pkgs.tmux}/bin/tmux save-buffer - | ${getBin pkgs.gist}/bin/gist -f tmux.sh-session --no-private | ${getBin pkgs.xsel}/bin/xsel --clipboard -i && ${getBin pkgs.libnotify}/bin/notify-send -a Tmux 'Buffer saved as public gist' 'Tmux buffer was saved as Gist, URL in clipboard' --icon=dialog-information"
      bind-key C-g run "${getBin pkgs.tmux}/bin/tmux save-buffer - | ${getBin pkgs.gist}/bin/gist -f tmux.sh-session --private | ${getBin pkgs.xsel}/bin/xsel --clipboard -i && ${getBin pkgs.libnotify}/bin/notify-send -a Tmux 'Buffer saved as private gist' 'Tmux buffer was saved as Gist, URL in clipboard' --icon=dialog-information"
      bind-key C-c run "${getBin pkgs.tmux}/bin/tmux save-buffer - | ${getBin pkgs.xsel}/bin/xsel --clipboard -i"
      bind-key C-v run "${getBin pkgs.xsel}/bin/xsel --clipboard -o | ${getBin pkgs.tmux}/bin/tmux load-buffer; ${getBin pkgs.tmux}/bin/tmux paste-buffer"
    '' else "";

in {
  plugins = with pkgs.tmuxPlugins; [
    logging
    prefix-highlight
    fzf-tmux-url
  ] ++ extraPlugins;

  extraConfig = ''
    ${tmuxVimAwarness}

    #
    # Settings
    #

    set  -g default-terminal "tmux-256color"
    set  -g base-index      0
    setw -g pane-base-index 0

    set -g mode-keys   vi

    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R

    bind -r H resize-pane -L 5
    bind -r J resize-pane -D 5
    bind -r K resize-pane -U 5
    bind -r L resize-pane -R 5

    # rebind main key: C-t
    unbind C-b
    set -g prefix C-t
    bind t send-prefix
    bind C-t last-window

    # Display the clock in 24 hours format
    setw -g clock-mode-style  24

    # don't allow the terminal to rename windows
    set-window-option -g allow-rename off

    # show the current command in the border of the pane
    set -g pane-border-status "top"
    set -g pane-border-format "#P: #{pane_current_command}"

    # Terminal emulator window title
    set -g set-titles on
    set -g set-titles-string '#S:#I.#P #W'

    # Status Bar
    set-option -g status on

    # Notifying if other windows has activities
    #setw -g monitor-activity off
    set -g visual-activity on

    # Trigger the bell for any action
    set-option -g bell-action any
    set-option -g visual-bell off

    # No Mouse!
    set -g mouse off

    # Do not update the environment, keep everything from what it was started with
    set -g update-environment ""

    # fuzzy client selection
    bind s split-window -p 20 -v ${getBin pkgs.nur.repos.kalbasit.swm}/bin/swm tmux switch-client --kill-pane

    # Last active window
    bind C-t last-window
    bind C-r switch-client -l
    # bind C-n next-window
    bind C-n switch-client -p
    bind C-o switch-client -n

    ${copyPaste}
  ''
  + optionalString (keyboardLayout == "colemak") colemakBindings
  + extraConfig;
}
