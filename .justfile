set dotenv-load := true
set fallback := true

_targets:
  @just --list --unsorted --list-heading $'Available targets:\n' --list-prefix "  "

# runs a given program with either '.mojo' or '.🔥' extension
@run program:
  mojo {{program}}.*

# builds a given program with either '.mojo' or '.🔥' extension
@build program:
  mojo build {{program}}.*

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

# runs all tests under the examples directory
check:
  #!/usr/bin/env sh

  export PYTHONPATH=$(pwd)/projects/packages_with_a_single_tests_directory
  pytest --mojo-include projects/packages_with_a_single_tests_directory projects/packages_with_a_single_tests_directory

  export PYTHONPATH=$(pwd)/projects/packages_with_src_and_tests_directories/src
  pytest --mojo-include projects/packages_with_src_and_tests_directories/src projects/packages_with_src_and_tests_directories/tests
