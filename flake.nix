{
  description = "nix selenium c# config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };

      packages.${system} = {
        dockerImage = import ./docker-build.nix {
          inherit pkgs;
          buildDotnetModule = pkgs.buildDotnetModule;
          dotnetCorePackages = pkgs.dotnetCorePackages;
        };
        default = self.packages.${system}.dockerImage;
      };
    };
}
