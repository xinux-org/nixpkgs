{
  stdenv,
  lib,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  gjs,
  glib,
  glib-networking,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk4,
  libadwaita,
  gst_all_1,
  hicolor-icon-theme,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  webkitgtk_6_0,
  blueprint-compiler,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "tangram";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Tangram";
    rev = "v${version}";
    hash = "sha256-OtQN8Iigu92iKa7CAaslIpbS0bqJ9Vus++inrgV/eeM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    gobject-introspection
    hicolor-icon-theme
    meson
    ninja
    pkg-config
    python3
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    gjs
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk4
    libadwaita
    webkitgtk_6_0
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ]);

  dontPatchShebangs = true;

  postPatch = ''
    substituteInPlace src/meson.build --replace "/app/bin/blueprint-compiler" "blueprint-compiler"
    substituteInPlace src/bin.js troll/gjspack/bin/gjspack \
      --replace "#!/usr/bin/env -S gjs -m" "#!${gjs}/bin/gjs -m"
  '';

  # https://github.com/NixOS/nixpkgs/issues/31168#issuecomment-341793501
  preFixup = ''
    sed -e '2iimports.package._findEffectiveEntryPointName = () => "re.sonny.Tangram"' \
      -i $out/bin/re.sonny.Tangram
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Run web apps on your desktop";
    mainProgram = "re.sonny.Tangram";
    homepage = "https://github.com/sonnyp/Tangram";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      austinbutler
      chuangzhu
    ];
    teams = [ lib.teams.gnome-circle ];
  };
}
