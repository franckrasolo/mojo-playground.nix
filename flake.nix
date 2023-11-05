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
          buildInputs = with pkgs; [
            gnused
            ncurses
            zlib
          ];

          packages = [
            just
          ];

          postShellHook = ''
            export MACOSX_DEPLOYMENT_TARGET=13.0
            export MODULAR_HOME=$HOME/.modular
            export MOJO_PYTHON_LIBRARY=/opt/homebrew/opt/python@3.11/Frameworks/Python.framework/Versions/3.11/Python
            export PATH=$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH

            sed 's/-lcurses/-lncurses/' -i $MODULAR_HOME/modular.cfg

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
