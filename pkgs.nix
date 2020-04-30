{  pkgs, ...}:
{
  imports = [
    ./pkgs/wind/wind.nix
  ];
  
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = {
        wind = pkgs.callPackage pkgs/wind/default.nix {};
      };
    };
  };
}
