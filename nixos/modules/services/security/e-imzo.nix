{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.e-imzo;
in {
  options = with lib; {
    services.e-imzo = {
      enable = mkEnableOption "E-IMZO";

      package = mkPackageOption pkgs "e-imzo" {
        example = "unstable.e-imzo";
        extraDescription = "Feel free to use either unstable or your own custom e-imzo with this module.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.e-imzo = {
      enable = true;
      description = "E-IMZO, uzbek state web signing service";
      documentation = ["https://github.com/xinux-org/e-imzo"];

      after = ["network-online.target" "graphical.target"];
      wants = ["network-online.target" "graphical.target"];
      wantedBy = ["default.target"];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 1;
        ExecStart = "${cfg.package}/bin/e-imzo";

        NoNewPrivileges = true;
        SystemCallArchitectures = "native";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ orzklv ];
}
