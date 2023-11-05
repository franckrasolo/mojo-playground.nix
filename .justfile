set dotenv-load := true

_targets:
  @just --list --unsorted --list-heading $'Available targets:\n' --list-prefix "  "

# runs a given program
@run program:
  mojo {{program}}.mojo

# builds a given program
@build program:
  mojo build {{program}}.mojo

# prints names and version numbers of the shared libraries for a given program
@libs program:
  file {{program}}
  otool -L {{program}}

# deletes a given program from the filesystem
@clean program:
  rm -vf {{program}}

# updates the top-level flake lock file
@update:
  nix flake update --commit-lock-file --commit-lockfile-summary "update Nix flake inputs"
