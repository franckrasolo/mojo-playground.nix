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
          buildInputs = [
            gnused
            ncurses
            zlib
          ];

          packages = [
            just
          ];

          shellHook = ''
            # health checks for Nix flake inputs
            nix run "github:DeterminateSystems/flake-checker"

            export MACOSX_DEPLOYMENT_TARGET=14.0
            export MAGIC_VERSION=$HOME/.modular
            export MAGIC_NO_PATH_UPDATE=1
            export MODULAR_HOME=$MAGIC_VERSION

            # curl -ssL https://magic.modular.com/f3a6b733-35d3-4233-bc28-21a8a09099a5 | bash
            # export PATH=$MODULAR_HOME/bin:$PATH
            # eval "$(magic completion --shell zsh)"

            magic self-update --version 0.2.3 --force
            sed 's/-lcurses/-lncurses/' -i .magic/envs/default/share/max/modular.cfg
          '';
        };
      });
    };
}
