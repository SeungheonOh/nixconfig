{lib, pkgs, config, ...}:
with lib;
let
  cfg = config.services.xserver.windowManager.wind;
in
{
  options = {
    services.xserver.windowManager.wind.enable = mkEnableOption "wind";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.wind ];
  };
}
