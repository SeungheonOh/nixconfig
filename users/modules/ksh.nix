{ config, lib, pkgs, ... }:

with lib;

let 
  cfg = config.programs.ksh;

in
{
  options = {
    programs.ksh = {
      enable = mkEnableOption "Korn Shell";

      kshrcExtra = mkOption {
        default = "";
        type = types.lines;
        description = "Extra config";
      };

      initExtra = mkOption {
        default = "";
        type = types.lines;
        description = "Extra commands that will be executed on init";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.ksh ];
    home.file.".kshrc".text = ''
      # -*- mode: sh -*-
      # Commands for interactive shells
      if [[ $- == *i* ]]; then
        ${cfg.initExtra}
      fi

      ${cfg.kshrcExtra}
    '';
  };
}
