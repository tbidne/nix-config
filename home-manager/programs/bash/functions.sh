###############################################################################
#                                     TOP                                     #
###############################################################################

toc () {
  cat << ToC
*** Custom functions table of contents ***

GHC
  - ghc_shell: Loads a nix shell for GHC dev
  - ghc_cfg: Runs configure in GHC repo
  - ghc_build: Builds GHC in repo

Git
  - haddock_push: Builds haskell docs and pushes to gh-pages git branch
  - git_yolo: Force push all changes
  - update_badges: Updates readme badges for shields.io changes

Haskell
  - hs_del: Recursively deletes haskell build dirs
  - hs_ormolu: Runs ormolu in the current directory
  - hs_fourmolu: Runs fourmolu in the current directory
  - hs_cabalfmt: Runs cabal-fmt in the current directory
  - hs_hlint: Runs hlint in the current directory
  - hs_refactor: Runs hlint w/ refactor in the current directory
  - hs_watch: Watches hs files via fd and entr

Misc
  - shrunlog: Alias for shrun -f log --file-log-mode write
  - port_to_pid: Finds a process that is listening to the given pid

Nix (General)
  - nd: Load a nix shell
  - nu: Update a single nix flake input
  - nus: Updatte nix flake input(s)
  - nix_info: print nix info
  - unsym_f: Remove a symlink from a file
  - unsym_d: Apply unsym_f to all symlinks in the current dir

Nix (Haskell)
  - htool: Runs nix-hs-tools
  - hshell: Loads an external nix shell for haskell dev
  - nixpkgs_hs_build: Builds a haskell package in the nixpkgs repository

Utils
  - path_hex: Prints a path in hex
  - retry: Retries a command until it succeeds
  - fr: Find/replace
  - find_dirs: Lists all directories in which a string is found
  - rename_fs: Renames files
ToC
}

###############################################################################
#                                 GENERAL NIX                                 #
###############################################################################

# Functions for launching nix shell w/ various args

nd () {
  args=""
  exit=0
  jobs=""
  legacy=0
  path="./"
  verbose=0

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "nd: Load a nix shell\n"
        echo "Usage: nd [-a|--args]"
        echo "          [-e|--exit]"
        echo "          [-j|--jobs MAX_JOBS]"
        echo "          [-l|--legacy]"
        echo "          [-p|--path PATH]"
        echo "          [-v|--verbose]"
        echo "          [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  -e,--exit          \tExits the shell after it loads.\n"
        echo -e "  -j,--jobs MAX_JOBS \tMaximum threads to use.\n"
        echo -e "  -l,--legacy        \tIf true, uses nix-shell over nix develop.\n"
        echo -e "  -p,--path PATH     \tPath to the shell. Defaults to ./.\n"
        return 0
        ;;
      "-a" | "--args")
        args="$2"
        shift
        ;;
      "-e" | "--exit")
        exit=1
        ;;
      "-j" | "--jobs")
        jobs="--max-jobs $2"
        shift
        ;;
      "-l" | "--legacy")
        legacy=1
        ;;
      "-p" | "--path")
        path=$2
        shift
        ;;
      "-v" | "--verbose")
        verbose=1
        ;;
      *)
        echo "Unexpected arg: '$1'. Try --help."
        return 1
    esac
    shift
  done

  if [[ 1 -eq $exit ]]; then
    if [[ 1 -eq $legacy ]]; then
      exit_cmd="--command exit"
    else
      exit_cmd="-c bash -c 'exit'"
    fi
  else
    exit_cmd=""
  fi

  if [[ 1 -eq $legacy ]]; then
    main_cmd="nix-shell"
  else
    main_cmd="nix develop -L"
  fi

  cmd="$main_cmd $path $args $jobs $exit_cmd"
  if [[ 1 -eq $verbose ]]; then
    echo "cmd: $cmd"
  fi

  $cmd
}

# nu and nus update flake inputs

nu () {
  nix flake lock --update-input $@
}

nus () {
  srcs=""
  for src in "$@"; do
    srcs+=" --update-input $src"
  done
  nix flake lock $srcs
}

nix_info () {
  nix-shell -p nix-info --run "nix-info -m"
}

# Turns a symlink into a real file. Useful for testing changes to config
# files that are managed by nix e.g.
#
# unsym-f some-config
#
# # test some-config changes...
#
# After we are satisfied w/ the changes, we can make the same changes to
# our nix file then delete the temp some-config.
unsym_f () {
  [ -L "$1" ] && cp --remove-destination $(readlink $1) $1
  chmod a+rw $1
}

# applies unsym_f to all files in the current directory
unsym_d () {
  for f in $(find -type l); do
    cp --remove-destination $(readlink $f) $f
    chmod a+rw $f
  done
}

nixpkgs_hs_build () {
  ghc=""
  pkg=""
  verbose=""

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "nixpkgs_hs_build: Builds a haskell package in nixpkgs.\n"
        echo "Usage: nixpkgs_hs_build [--ghc GHC]"
        echo "                        [-p|--pkg PKG]"
        echo "                        [-v|--verbose]"
        echo "                        [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  --ghc GHC    \tGHC to use. Optional\n"
        echo -e "  -p,--pkg PKG \tThe package to build.\n"
        echo "Examples:"
        echo -e "  nixpkgs_hs_build -p text\n"
        echo "  nixpkgs_hs_build --ghc ghc963 -p text"
        return 0
        ;;
      "--ghc")
        ghc="$2"
        shift
        ;;
      "-p" | "--pkg")
        pkg="$2"
        shift
        ;;
      "-v" | "--verbose")
        verbose=1
        ;;
      *)
        echo "Unexpected arg: '$1'. Try --help."
        return 1
    esac
    shift
  done

  if [[ $pkg == "" ]]; then
    echo "No --pkg given. Try help."
  fi

  if [[ $ghc != "" ]]; then
    cmd="nix build .#haskell.packages.$ghc.$pkg"
  else
    cmd="nix build .#haskellPackages.$pkg"
  fi

  if [[ $verbose == 1 ]]; then
    echo "cmd: $cmd"
  fi
  $cmd
}

###############################################################################
#                                NIX + HASKELL                                #
###############################################################################

# runs nix-hs-tools where first arg is tool and the rest are args
htool () {
  nix run github:tbidne/nix-hs-tools/0.9.1.0#$1 -- ${@:2}
}

# Launches a nix shell using those defined in my external repo.
# The first arg is the shell and the rest are passed through. E.g.
hshell () {
  args=""
  exit_cmd=""
  shell=default
  URL=http://github.com/tbidne/nix-hs-shells/archive/main.tar.gz
  verbose=0

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "hshell: Load an external nix shell for haskell dev.\n"
        echo "Usage: hshell [-a|--args ARGS]"
        echo "              [-e|--exit]"
        echo "              [-s|--shell SHELL]"
        echo "              [-v|--verbose]"
        echo "              [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  --args ARGS      \tArgs to pass through to shell.\n"
        echo -e "  --e,--exit       \tExits immediately after loading.\n"
        echo -e "  -s,--shell SHELL \tShell to load e.g. default.\n"
        echo "Examples:"
        echo "  hshell -s liquidhaskell -a '--arg hls true' -e"
        echo -e "    = nix-shell \\"
        echo -e "        http://github.com/tbidne/nix-hs-shells/archive/main.tar.gz \\"
        echo -e "        -A liquidhaskell \\"
        echo -e "        --arg hls true \\"
        echo -e "        --command exit"
        return 0
        ;;
      "-a" | "--args")
        args="$2"
        shift
        ;;
      "-e" | "--exit")
        exit_cmd="--command exit"
        ;;
      "-s" | "--shell")
        shell=$2
        shift
        ;;
      "-v" | "--verbose")
        verbose=1
        ;;
      *)
        echo "Unexpected arg: '$1'. Try --help."
        return 1
    esac
    shift
  done

  cmd="nix-shell $URL -A $shell $args $exit_cmd"
  if [[ $verbose == 1 ]]; then
    echo "cmd: $cmd"
  fi

  $cmd
}

###############################################################################
#                                     GHC                                     #
###############################################################################

ghc_shell () {
  exit_cmd=""

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "ghc_shell: Load a nix shell for GHC development.\n"
        echo "Usage: ghc_shell [-e|--exit]"
        echo "                 [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  --e,--exit       \tExits immediately after loading.\n"
        return 0
        ;;
      "-e" | "--exit")
        exit_cmd="-c bash -c 'exit'"
        ;;
      *)
        echo "Unexpected arg: '$1'. Try --help."
        return 1
    esac
    shift
  done

  nix develop github:alpmestan/ghc.nix -L $exit_cmd
}

ghc_cfg () {
  ./boot && configure_ghc
}

ghc_build () {
  build_root="_mybuild"
  clean=0
  config=0
  flavour="quickest"
  threads=8
  verbose=0

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "ghc_build: Building GHC.\n"
        echo "Usage: ghc_build [--build-root DIR]"
        echo "                 [--clean]"
        echo "                 [--config]"
        echo "                 [--flavour FLAVOUR]"
        echo "                 [--threads NUM_THREADS]"
        echo "                 [-v|--verbose]"
        echo "                 [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  --build-root DIR      \tSets the build directory.\n"
        echo -e "  --clean               \tDeletes --build-root before building.\n"
        echo -e "  --config              \tRuns configuration step before building.\n"
        echo -e "  --flavour FLAVOUR     \tSets the flavour(s). Defaults to 'quickest'.\n"
        echo -e "  --threads NUM_THREADS \tSets the threads. Defaults to 8.\n"
        echo "Examples:"
        echo "  ghc_build --clean --config --build-root _mybuild"
        return 0
        ;;
      "--build-root")
        build_root="$2"
        shift
        ;;
      "--clean")
        clean=1
        ;;
      "--config")
        config=1
        ;;
      "--flavour")
        flavour="$2"
        shift
        ;;
      "--threads")
        threads="$2"
        shift
        ;;
      "--verbose" | "-v")
        verbose=1
        ;;
      *)
        echo "Unexpected arg: '$1'. Try --help."
        return 1
    esac
    shift
  done

  if [[ 1 -eq $clean ]]; then
    echo "*** Cleaning $build_root ***"
    if [[ -d $build_root ]]; then
      rm -r --interactive=never $build_root
    else
      echo "$build_root does not exist"
    fi
  fi

  if [[ 1 -eq $config ]]; then
    echo "*** Configuring ***"
    ghc_cfg
  fi

  cmd="hadrian/build -j$threads --flavour=$flavour --build-root=$build_root"

  if [[ 1 -eq $verbose ]]; then
    echo "*** Command: '$cmd' ***"
  fi

  $cmd
}

###############################################################################
#                                   HASKELL                                   #
###############################################################################

hs_del () {
  # -t d -> find dirs
  # -I   -> ignore .gitignore
  # -H   -> search hidden
  # -s   -> case sensitive
  hs_dirs=$(fd -t d -I -H -s '^.stack-work$|^dist-newstyle$')
  # -t l -> find symlinks
  nix_dirs=$(fd -t l -I -H -s '^result$')

  # --interactive=never is a safer way to ignore write-protected files.
  # I.e. we do not want to prompt on every write-protected files, so we could
  # use -f, but this will ignore non-existent files/args too.
  # --interactive=never will also not prompt, but will error on
  # non-existent files/args, so it's a mildly safer way to do what we want.

  for d in $hs_dirs; do
    echo "Deleting haskell build dir: '$d'"
    rm -r --interactive=never "$d"
  done

  for nd in $nix_dirs; do
    target=$(readlink $nd)
    if [[ $target =~ ^/nix/store/.* ]]; then
      echo "Deleting nix sym link: '$nd'"
      rm -r --interactive=never "$nd"
    fi
  done

  if [[ -d ~/.cabal ]]; then
    echo "deleting ~/.cabal"
    rm -r --interactive=never ~/.cabal
  fi
  if [[ -d ~/.cache/cabal ]]; then
    echo "deleting ~/.cache/cabal"
    rm -r --interactive=never ~/.cache/cabal
  fi
  if [[ -d ~/.local/state/cabal ]]; then
    echo "deleting ~/.local/state/cabal"
    rm -r --interactive=never ~/.local/state/cabal
  fi
  if [[ -d ~/.stack ]]; then
    echo "deleting ~/.stack"
    rm -r --interactive=never ~/.stack
  fi
}

hs_ormolu () {
  ormolu -m inplace $(fd -e hs)
}

hs_fourmolu () {
  fourmolu -m inplace $(fd -e hs)
}

hs_cabalfmt () {
  cabal-fmt --inplace $(fd -e cabal)
}

hs_hlint () {
  hlint $(fd -e hs)
}

hs_refactor () {
  $(fd -e hs) | xargs -I % sh -c " \
    hlint \
    --ignore-glob=dist-newstyle \
    --ignore-glob=stack-work \
    --refactor \
    --with-refactor=refactor \
    --refactor-options=-i \
    %"
}

# Watches hs files via fd and entr
hs_watch () {
  dir="."
  clean=0
  dry_run=0
  cmd="cabal build"
  verbose=0

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "hs_watch: Simple bash function for using entr with haskell.\n"
        echo "Usage: hs_watch [--clean]"
        echo "                [-c|--cmd COMMAND]"
        echo "                [-d|--dir DIR]"
        echo "                [--dry-run]"
        echo "                [-v|--verbose]"
        echo "                [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  --clean         \tRuns 'cabal clean' before --cmd.\n"
        echo -e "  -c,--cmd COMMAND\tCommand to run with entr e.g. 'cabal build all'."
        echo -e "                  \tDefaults to 'cabal build'.\n"
        echo -e "  -d,--dir DIR    \tDirectory on which to run find. Defaults to '.'\n"
        echo -e "  --dry-run       \tShows which files will be watched.\n"
        echo "Examples:"
        echo "  hs_watch"
        echo -e "    = fd . -e cabal -e hs | entr -s \"cabal build\"\n"
        echo "  hs_watch -d /path/to/src"
        echo -e "    = fd . /path/to/src -e cabal -e hs | entr -s \"cabal build\"\n"
        echo "  hs_watch -c \"cabal test foo --test-options '-p \\\"pattern\\\"'\""
        echo -e "    = fd . -e cabal -e hs | entr -s \"cabal test foo '-p \\\"pattern\\\"'\"\n"
        return 0
        ;;
      "--clean")
        clean=1
        ;;
      "--cmd" | "-c")
        cmd=$2
        shift
        ;;
      "--dir" | "-d")
        dir=". $2"
        shift
        ;;
      "--dry-run")
        dry_run=1
        ;;
      "--verbose" | "-v")
        verbose=1
        ;;
      *)
        echo "Unexpected arg: '$1'. Try --help."
        return 1
    esac
    shift
  done

  fd_cmd="fd $dir -e cabal -e hs"

  if [[ 1 -eq $dry_run ]]; then
    $fd_cmd
    return
  fi

  if [[ 1 -eq $clean ]]; then
    final_cmd="cabal clean && $cmd"
  else
    final_cmd=$cmd
  fi

  if [[ $verbose == 1 ]]; then
    echo "dir:  '$dir'"
    echo "cmd:  '$final_cmd'"
    echo -e "full: '$fd_cmd | entr -s $final_cmd'\n"
  fi

  $fd_cmd | entr -s "$final_cmd"
}

###############################################################################
#                                     GIT                                     #
###############################################################################

# Runs haddock job and pushes docs to gh-pages branch. Assumes
# the following:
#
# - main branch is 'main'
# - pages branch is 'gh-pages'
# - haddock script is 'make haddock' (i.e. makefile and cabal)
# - remote is 'origin'
haddock_push_legacy () {
  git checkout main && \
  git branch -D gh-pages && \
    git checkout -b gh-pages && \
    make haddock && \
    git add -A && \
    git commit -m "Add haddocks" && \
    git push -u --force origin gh-pages && \
    git checkout main
}

# Runs haddock job and pushes docs to gh-pages branch. Assumes
# the following:
#
# - main branch is 'main'
# - pages branch is 'gh-pages'
# - haddock script is './tools/haddock.sh'
# - remote is 'origin'
haddock_push () {
  set -e

  # make gh-pages branch off main
  git checkout main
  git branch -D gh-pages
  git checkout -b gh-pages

  # create docs
  ./tools/haddock.sh

  # commit and push
  git add -A
  git commit -m "Add haddocks"
  git push -u --force origin gh-pages

  # checkout main
  git checkout main
}

# force pushes all changes, copies the new git revision into the clipboard
git_yolo () {
  set -e

  git add -A
  git commit --amend --no-edit
  git push --force

  git log \
    | head -n 1 \
    | cut -c 8-47 \
    | xclip -selection clipboard
}

# Update per https://github.com/badges/shields/issues/8671
update_badges () {
  find . \
    -type f -name '*md' ! -path "./.*" ! -path "./dist-newstyle/*" \
      | xargs sed -i -E 's/https:\/\/img.shields.io\/github\/workflow\/status\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_-]+)\?(.*)/http:\/\/img.shields.io\/github\/actions\/workflow\/status\/\1\/\2\/\3.yaml\?branch=\4\&\5/g'
}

###############################################################################
#                                    UTILS                                    #
###############################################################################

path_hex () {
  printf '%s\n' $1 | od -t x1 -a
}

# tries param command until it succeeds
retry () {
  success=0
  count=1
  while [[ $success == 0 ]]; do
    $@
    if [[ $? == 0 ]]; then
      echo "'$@' succeeded on try $count"
      success=1
    else
      echo "'$@' failed on try $count"
      sleep 1
    fi
    count=$((count + 1))
  done
}

# find-replace
fr () {
  find . \
    -type f -name '*' ! -path "./.*" ! -path "./dist-newstyle/*" \
      | xargs sed -i "s/$1/$2/g"
}

# find_dirs str path lists all directories under path in which str is
# found, according to ripgrep. If path is not given then we search in the
# current dir.
find_dirs () {
  set +e

  str=$1
  root=$2
  if [[ -z $root ]]; then
    root=$(pwd)
  fi

  contents=$(ls $root)

  for c in $contents; do
    d="$root/$c"
    if [[ -d $d ]]; then
      output=$(rg $str $d)
      ec=$?
      if [[ $ec == 0 ]]; then
        echo $d
      fi
    fi
  done
}

rename_fs () {
  if [[ $1 == "" || $2 == "" ]]; then
    echo "Usage: rename_fs <string to match> <new string>"
    return
  fi

  RX="^(.*)$1(.*)$"

  files=$(ls)

  for f in $files; do
    if [[ $f =~ $RX ]]; then
      prefix=${BASH_REMATCH[1]}
      suffix=${BASH_REMATCH[2]}

      new_f="$prefix$2$suffix"
      echo "Renaming $f to $new_f"

      mv $f $new_f
    fi
  done
}

###############################################################################
#                                     MISC                                    #
###############################################################################

shrunlog () {
  shrun "$1" -f shrun.log --file-log-mode write
}

port_to_pid () {
  # e.g. port_to_pid 5432
  sudo ss -lptn "sport = :$1"
}
