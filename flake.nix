{
  description = "Mojo Playground";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      overlays = [
      ];

      allSystems = [
        "aarch64-darwin" # 64-bit macOS ARM
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in
    {
      devShells = forAllSystems ({ pkgs }: with pkgs; {
        default = mkShell {
          packages = [
            direnv
            just
            pixi
            tokei
          ];

          shellHook = ''
            # health checks for Nix flake inputs
            nix run https://flakehub.com/f/NixOS/nixpkgs/0.1#flake-checker

            export MACOSX_DEPLOYMENT_TARGET="15.0"
          '';
        };
      });
    };
}
