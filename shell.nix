{ pkgs }:

pkgs.mkShell {
  buildInputs = [
    pkgs.dotnet-sdk_8
    pkgs.microsoft-edge
    pkgs.edgedriver
    pkgs.ffmpeg-headless
    pkgs.xorg.xorgserver
    pkgs.dejavu_fonts
  ];

  shellHook = ''
    # Xvfb display
    export DISPLAY=":99"

    export CHROME_PATH="${pkgs.microsoft-edge}/bin/microsoft-edge"
    export CHROMEDRIVER_PATH="${pkgs.edgedriver}/bin/edgedriver"

    export FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf
    export FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts

    echo "environment started ..."
  '';
}
