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
        default = mkShell rec {
          venvDir = "venv";

          buildInputs = [
            gnused
            ncurses
            zlib

            python312Packages.venvShellHook
          ];

          packages = [
            just
            pdm
          ];

          postShellHook = ''
            # health checks for Nix flake inputs
            nix run "github:DeterminateSystems/flake-checker"

            export MACOSX_DEPLOYMENT_TARGET=14.0
            export MODULAR_HOME=$HOME/.modular
            export MOJO_PYTHON_LIBRARY=$(python -c "
            import sys, sysconfig
            print(f'{sys.base_prefix}/lib/libpython{sysconfig.get_python_version()}.dylib')
            ")
            export PATH=$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH

            sed 's/-lcurses/-lncurses/' -i $MODULAR_HOME/modular.cfg

            if test -x "$(command -v mojo)"; then
              modular update mojo 2> /dev/null
            else
              modular install mojo
            fi

            export PDM_CHECK_UPDATE=0
            python -m venv --without-pip --upgrade --upgrade-deps --prompt venv ${venvDir}
            pdm update --no-self --update-all --fail-fast
          '';
        };
      });
    };
}
