{ config, lib, pkgs, ... }:
  with lib;
  let
    cfg = config.services.ytdl-sub;
  in
    options = {
      enable = mkEnableOption "Enable ytdl-sub cronjobs";

      configFilePath = mkOption {
        type = lib.types.path;
        default = "/etc/ytdl-sub/config.yaml";
        description = lib.mDoc "Path to the config.yaml";
      };

      subscriptionsFilePath = mkOption {
        type = lib.types.path;
        default = "/etc/ytdl-sub/subscriptions.yaml";
        description = lib.mDoc "Path to the subscriptions.yaml";
      };

      userName = mkOption {
        type = lib.types.str;
        default = "ytdl-sub";
        description = lib.mDoc "Name of the user that will be executing the systemd units";
      };

      userExtraGroups = mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = lib.mDoc "A list of extra groups added to the user running the systemd units";
      };

    };

    config = mkIf cfg.enable {
      users.users."${cfg.userName}" = {
        isNormalUser = false;
        description = "ytdl-sub downloads videos for us";
        extraGroups = cfg.userExtraGroups;
      };

      systemd.service."ytdl-sub" = {
        script = ''
          set -euo pipefail
          ${pkgs.ytdl-sub}/bin/ytdl-sub --config=${ toString cfg.configFilePath } sub ${ toString cfg.subcriptionsFilePath }
        '';

        serviceConfig = {
          Type = "oneshot";
          User = ${cfg.userName};
        };
      };
    }; 
