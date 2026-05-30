{ pkgs }:
let
  dotnetSdk = pkgs.dotnet-sdk_8;

  nativeLibs = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
    pkgs.zlib
  ];
in
pkgs.mkShell {
  buildInputs = [
    dotnetSdk
    pkgs.microsoft-edge
    pkgs.msedgedriver
    pkgs.ffmpeg-headless
    pkgs.xorgserver
    pkgs.dejavu_fonts
  ];

  shellHook = ''
    export DOTNET_ROOT="${dotnetSdk}/share/dotnet";

    export LD_LIBRARY_PATH="${nativeLibs}:$LD_LIBRARY_PATH"
    
    # Xvfb display
    export DISPLAY=":99"

    export CHROME_PATH="${pkgs.microsoft-edge}/bin/microsoft-edge"
    export CHROMEDRIVER_PATH="${pkgs.msedgedriver}/bin/edgedriver"

    export FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf
    export FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts

    echo "environment started ..."
  '';
}
