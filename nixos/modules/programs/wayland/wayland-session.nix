{
  lib,
  pkgs,
  enableXWayland ? true,
  enableWlrPortal ? true,
  enableGtkPortal ? true,
}:

{
  security = {
    polkit.enable = true;
    pam.services.swaylock = { };
  };

  programs = {
    dconf.enable = lib.mkDefault true;
    xwayland.enable = lib.mkIf enableXWayland (lib.mkDefault true);
  };

  services.graphical-desktop.enable = true;

  xdg.portal.wlr.enable = lib.mkIf enableWlrPortal true;
  xdg.portal.extraPortals = lib.mkIf enableGtkPortal [
    pkgs.xdg-desktop-portal-gtk
  ];

  # Window manager only sessions (unlike DEs) don't handle XDG
  # autostart files, so force them to run the service
  services.xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;
}
