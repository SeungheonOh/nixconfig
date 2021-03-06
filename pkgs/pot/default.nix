# This file was generated by https://github.com/kamilchm/go2nix v1.3.0
{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "pot-unstable-${version}";
  version = "2020-06-14";
  rev = "caac6bd5f7ee760a22db5439bdecd4b14829798d";

  goPackagePath = "github.com/SeungheonOh/pot";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/SeungheonOh/pot";
    sha256 = "0mm623k7fa2zdyd9a0ik8fqcxq2xngr4m5kl0dnk68id32fz3dws";
  };

  goDeps = ./deps.nix;

  # TODO: add metadata https://nixos.org/nixpkgs/manual/#sec-standard-meta-attributes
  meta = {
  };
}
