{ pkgs, buildDotnetModule, dotnetCorePackages, ffmpeg } :

let
  csharpTestApp = pkgs.buildDotnetModule {
    pname = "nix-selenium";
    projectFile = "src.project.sln"
    version = "0.1";
    src = ./.;
    dotnet-sdk = dotnetCorePackages.sdk_8_0;
    dotnet-runtime = dotnetCorePackages.runtime_8_0;
    nugetDeps = ./nuget-deps.json;
    packNupkg = true;
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
      pkgs.msedgedriver
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
