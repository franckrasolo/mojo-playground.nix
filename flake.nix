{
  description = "Mojo Playground";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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

      modular_home = "$HOME/.modular";
    in
    {
      devShells = forAllSystems ({ pkgs }: with pkgs; {
        default = mkShell {
          buildInputs = with pkgs; [
            gnused
            ncurses
            zlib
          ];

          packages = [
            just
          ];

          shellHook = ''
            export MACOSX_DEPLOYMENT_TARGET=13.0
            export MOJO_PYTHON_LIBRARY=/opt/homebrew/opt/python@3.11/Frameworks/Python.framework/Versions/3.11/Python
            export PATH=${modular_home}/pkg/packages.modular.com_mojo/bin:$PATH

            sed 's/-lcurses/-lncurses/' -i ${modular_home}/modular.cfg

            if test -x "$(command -v mojo)"; then
              modular update mojo
            else
              modular install mojo
            fi
          '';
        };
      });
    };
}
