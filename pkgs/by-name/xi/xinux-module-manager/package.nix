{
  pkgs,
  lib,
  appstream-glib,
  polkit,
  gettext,
  meson,
  ninja,
  pkg-config,
  git,
  wrapGAppsHook4,
  cargo,
  rustc,
  rustPlatform,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  libxml2,
  openssl,
  vte-gtk4,
  wayland,
  adwaita-icon-theme,
  desktop-file-utils,
  fetchFromGitHub,
}:
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "xinux-module-manager";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "xinux-org";
    repo = "module-manager";
    tag = finalAttrs.version;
    hash = "sha256-X6X1jeVTrhGatllrsFuEA5vISz/jGlBTfp6dzUllUkM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-wwXIOsb1cw98TtbCE1qxc791cR9pb7aczOgAGPmvEkY=";

  };

  nativeBuildInputs = [
    appstream-glib
    polkit
    gettext
    desktop-file-utils
    meson
    ninja
    pkg-config
    git
    wrapGAppsHook4
    cargo
    rustc
  ]
  ++ (with rustPlatform; [ cargoSetupHook ]);

  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    libxml2
    openssl
    vte-gtk4
    wayland
    adwaita-icon-theme
    desktop-file-utils
  ];

  meta = {
    homepage = "https://github.com/xinux-org/module-manager";
    mainProgram = "Module Manager";
    description = "Application for configuring and managing Xinux modules on a Xinux system";
    license = with lib.licenses; [ gpl3 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      orzklv
      bahrom04
    ];
  };
})
