{ pkgs } :

let
  csharpTestApp = pkgs.buildDotnetModule {
    pname = "nix-selenium";
    version = "1.0.0";
    src = ./.;
    dotnet-sdk = pkgs.dotnet-sdk_8;
    dotnet-runtime = pkgs.dotnet-runtime_8;
    nugetDeps = ./nuget-deps.nix;
  };
in
pkgs.dockerTools.buildImage {
  name = "k8s-selenium-runner";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [
      csharpTestApp
      pkgs.microsoft-edge
      pkgs.edgedriver
      pkgs.ffmpeg-headless
      pkgs.xorg.xorgserver
      pkgs.dejavu_fonts
      pkgs.busybox # k8 debugging
    ];
    pathsToLink = [ "/bin" "/etc" ];
  };

  extraCommands = ''
    mkdir -p tmp
    mkdir -p dev
  ''
  
  config = {
    Entrypoint = [ "${csharpTestApp}/bin/nix-selenium" ]
    Env = [
      "PATH=/bin"
      "DISPLAY=:99"
      "CHROME_PATH=/bin/microsoft-edge"
      "CHROMEDRIVER_PATH=bin/edgedriver"
    ]
  };
}
