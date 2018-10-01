# This file was generated by https://github.com/kamilchm/go2nix v1.2.1
{ stdenv, buildGoPackage, fetchgit, ... }:

buildGoPackage rec {
  name = "swm-unstable-${version}";
  version = "2018-10-01";
  rev = "defb67aaba91c724be15bf1894762347379ac481";

  goPackagePath = "github.com/kalbasit/swm";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/kalbasit/swm";
    sha256 = "09b23m3fxwslw264w1k6szc5n7nga7h9jvd0z4rm5qw4xq1j330c";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/kalbasit/swm;
    description = "swm (Story-based Workflow Manager) is a Tmux session manager specifically designed for Story-based development workflow";
    license = licenses.mit;
    maintainers = [ maintainers.kalbasit ];
    platforms = platforms.all;
  };
}
