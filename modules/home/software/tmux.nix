{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.mine.tmux;

  tmuxConfig = import ../../tmux {
    inherit (cfg) extraConfig extraPlugins keyboardLayout;
    inherit pkgs;
  };

in {
  options.mine.tmux = {
    enable = mkEnableOption "Tmux";

    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = ''
        Extra TMux configuration.
      '';
    };

    extraPlugins = mkOption {
      default = [];
      description = ''
        Extra TMux plugins.
      '';
    };

    keyboardLayout = mkOption {
      type = with types; enum [ "colemak" "qwerty" ];
      default = if config.mine.useColemakKeyboardLayout then "colemak" else "qwerty";
      description = ''
        The keyboard layout to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = tmuxConfig // {
      inherit (cfg) enable;
    };
  };
}
