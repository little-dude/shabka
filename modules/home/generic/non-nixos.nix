{ config, lib, ... }:

with lib;

{
  config = mkIf (config.mine.nixosConfig == {}) {
    home.file = {
      ".ssh/authorized_keys".source = builtins.readFile (builtins.fetchurl {
        url = "https://github.com/kalbasit.keys";
        sha256 = "033rs0pnm8aiycrfmx04qx8fmnkfdhp4hy3kdpgil3cgbgff9736";
      });
    };
  };
}