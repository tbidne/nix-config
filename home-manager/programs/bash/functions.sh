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
  - nix_del_profs: delete old nix profiles
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
  offline=""
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
        echo "          [-o|--offline]"
        echo "          [-p|--path PATH]"
        echo "          [-v|--verbose]"
        echo "          [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  -a,--args          \tMisc args that are passed through.\n"
        echo -e "  -e,--exit          \tExits the shell after it loads.\n"
        echo -e "  -j,--jobs MAX_JOBS \tMaximum threads to use.\n"
        echo -e "  -l,--legacy        \tIf true, uses nix-shell over nix develop.\n"
        echo -e "  -o,--offline       \tSkips binary cache lookup.\n"
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
      "-o" | "--offline")
        offline="--option substitute false"
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

  cmd="$main_cmd $path $args $jobs $offline $exit_cmd"
  if [[ 1 -eq $verbose ]]; then
    cmd="$cmd -vvvvv"
    echo "cmd: $cmd"
  fi

  $cmd
}

# nu and nus update flake inputs

nu () {
  nix flake update "$@"
}

nus () {
  nix flake update "$@"
}

nix_del_profs () {
  path=/nix/var/nix/profiles

  all_files=$(ls $path)

  RX="^system-[0-9]+-link$"

  live_link=$(readlink "$path/system")

  for f in $all_files; do
    if [[ $f =~ $RX ]]; then
      if [[ $f == $live_link ]]; then
        echo "Skipping active profile: $f"
      else
        echo "Deleting non-active profile: $f"
        sudo unlink "$path/$f"
      fi
    fi
  done

  # Keeping here just in case we want to sort the links we find...
  #sorted_links=$(echo $sys_links | xargs -n1 | sort | xargs)
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
  broken=0
  ghc=""
  pkg=""
  verbose=""

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "nixpkgs_hs_build: Builds a haskell package in nixpkgs.\n"
        echo "Usage: nixpkgs_hs_build [-b|--broken]"
        echo "                        [--ghc GHC]"
        echo "                        [-p|--pkg PKG]"
        echo "                        [-v|--verbose]"
        echo "                        [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  -b,--broken  \tAttempts to build a package marked broken.\n"
        echo -e "  --ghc GHC    \tGHC to use. Optional\n"
        echo -e "  -p,--pkg PKG \tThe package to build.\n"
        echo "Examples:"
        echo -e "  nixpkgs_hs_build -p text\n"
        echo "  nixpkgs_hs_build --ghc ghc963 -p text"
        return 0
        ;;
      "-b" | "--broken")
        broken=1
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

  if [[ $verbose == 1 ]]; then
    base_cmd="nix build"
  else
    base_cmd="nix build -Lv"
  fi

  if [[ $broken == 1 ]]; then
    mbroken_cmd="export NIXPKGS_ALLOW_BROKEN=1; $base_cmd --impure"
  else
    mbroken_cmd="$base_cmd"
  fi

  if [[ $ghc != "" ]]; then
    cmd="$mbroken_cmd .#haskell.packages.$ghc.$pkg"
  else
    cmd="$mbroken_cmd .#haskellPackages.$pkg"
  fi

  if [[ $verbose == 1 ]]; then
    echo "cmd: $cmd"
  fi

  eval $cmd
}

# Using this is a bit non-obvious. AFAICT, after creating the latest generation
# (i.e. nixos-rebuild switch), run this, reboot, then run it again.
#
# Other tips for clearing space:
#
# - delete unused roots i.e. /nix/var/nix/profiles/
#
# - From home dir (so writable), run:
#
#     shrun "path-size -a -s pool -d 1 -e proc /" --no-file-log-delete-on-success
#
#   (Takes about 1 min)
#
# - /var can be large, especially /var/lib/docker. If docker is a problem, run:
#
#     Kill all running containers:
# docker kill $(docker ps -q)
#
# Delete all stopped containers
# # docker rm $(docker ps -a -q)
#
# Delete all images
# # docker rmi $(docker images -q)
#
# Remove unused data
# # docker system prune
#
# And some more
# # docker system prune -af

nix_gc () {
  set -e

  period="-d"
  profile="system"
  verbose=""

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "nix_gc: Runs the garbage collector.\n"
        echo "Usage: nix_gc [--period PERIOD]"
        echo "              [--profile PROFILE]"
        echo "              [-v|--verbose]"
        echo "              [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  --period PERIOD   \tDeletes entries older than PERIOD. Defaults to all (-d)\n"
        echo -e "  --profile PROFILE \tDeletes entries for the profile. Defaults to system.\n"
        echo "Examples:"
        echo "  nix_ghc --period 30d --profile per-user/<user_name>"
        return 0
        ;;
      "--period")
        days="--delete-older-than $2"
        shift
        ;;
      "--profile")
        profile="$2"
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

  df_cmd="df -h /"
  ls_cmd="sudo nix-env --list-generations --profile /nix/var/nix/profiles/$profile"
  del_cmd="nix-collect-garbage $days"
  del_sudo_cmd="sudo nix-collect-garbage $days"
  boot_cmd="sudo /run/current-system/bin/switch-to-configuration boot"
  boot2_cmd="sudo nixos-rebuild boot"

  if [[ 1 == $verbose ]]; then
    echo "df_cmd = $df_cmd"
    echo "ls_cmd = $ls_cmd"
    echo "del_cmd = $del_cmd"
    echo "del_sudo_cmd = $del_sudo_cmd"
    echo "boot_cmd = $boot_cmd"
  fi

  echo "*** Get space ***"
  $df_cmd

  echo "*** Listing generations ***"
  $ls_cmd

  echo "*** Deleting generations ***"
  nix_del_profs

  echo "*** Deleting ***"
  $del_cmd

  echo "*** Deleting with sudo ***"
  $del_sudo_cmd

  echo "*** Cleaning boot ***"
  $boot_cmd

  echo "*** Listing generations ***"
  $ls_cmd

  echo "*** Get space ***"
  $df_cmd
}

ntest () {
  sudo nixos-rebuild test --flake '.#nixos' -L
}

nswitch () {
  sudo nixos-rebuild switch --flake '.#nixos' -L
}

nix_revw_hd () {
  nix-shell -p nixpkgs-review --run "nixpkgs-review rev HEAD"
}

###############################################################################
#                                NIX + HASKELL                                #
###############################################################################

# runs nix-hs-tools where first arg is tool and the rest are args
htool () {
  nix run github:tbidne/nix-hs-tools/0.10#$1 -- ${@:2}
}

# Launches a nix shell using those defined in my external repo.
# The first arg is the shell and the rest are passed through. E.g.
hshell () {
  args=""
  exit_cmd=""
  ghc=""
  hls=""
  shell=default
  URL=http://github.com/tbidne/nix-hs-shells/archive/main.tar.gz
  verbose=0

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "hshell: Load an external nix shell for haskell dev.\n"
        echo "Usage: hshell [-a|--args ARGS]"
        echo "              [-g|--ghc GHC]"
        echo "              [-e|--exit]"
        echo "              [--hls]"
        echo "              [-s|--shell SHELL]"
        echo "              [-v|--verbose]"
        echo "              [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  --args ARGS      \tArgs to pass through to shell.\n"
        echo -e "  -g,--ghc GHC     \tSpecifies ghc.\n"
        echo -e "  -e,--exit        \tExits immediately after loading.\n"
        echo -e "  --hls            \tLoads hls.\n"
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
      "-g" | "--ghc")
        ghc=" --argstr ghc-vers $2"
        shift
        ;;
      "--hls")
        hls=" --arg hls true"
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

  final_args="$args$ghc$hls"
  cmd="nix-shell $URL -A $shell $final_args $exit_cmd"
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
  js=0
  verbose=""

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "ghc_shell: Load a nix shell for GHC development.\n"
        echo "Usage: ghc_shell [-e|--exit]"
        echo "                 [--js]"
        echo "                 [-h|--help]"
        echo "                 [-v|--verbose]"
        echo ""
        echo "Available options:"
        echo -e "  --e,--exit       \tExits immediately after loading.\n"
        echo -e "  --js             \tLoads JS shell.\n"
        return 0
        ;;
      "-e" | "--exit")
        exit_cmd="-c bash -c 'exit'"
        ;;
      "--js")
        js=1
        ;;
      "-v" | "--verbose")
        verbose="-vvvvv"
        ;;
      *)
        echo "Unexpected arg: '$1'. Try --help."
        return 1
    esac
    shift
  done

  if [[ 1 -eq $js ]]; then
    cmd="nix develop git+https://gitlab.haskell.org/ghc/ghc.nix#js-cross -L $exit_cmd $verbose"
  else
    cmd="nix develop git+https://gitlab.haskell.org/ghc/ghc.nix -L $exit_cmd $verbose"
  fi

  if [[ -n $verbose ]]; then
    echo "cmd: $cmd"
  fi

  $cmd
}

ghc_cfg () {
  ./boot && configure_ghc
}

ghc_cfg_js () {
  ./boot && emconfigure ./configure --target=javascript-unknown-ghcjs
}

ghc_build () {
  build_root="_build"
  clean=0
  config=0
  flavour="quickest"
  js=0
  # for available targets, try hadrian/build --help
  target=""
  test=0
  threads=8
  verbose=0

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "ghc_build: Building GHC.\n"
        echo "Usage: ghc_build [-b|--build-root DIR]"
        echo "                 [--clean]"
        echo "                 [--config]"
        echo "                 [--flavour FLAVOUR]"
        echo "                 [--js]"
        echo "                 [--target TARGET]"
        echo "                 [--test]"
        echo "                 [--threads NUM_THREADS]"
        echo "                 [-v|--verbose]"
        echo "                 [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  -b,--build-root DIR   \tSets the build directory.\n"
        echo -e "  --clean               \tDeletes --build-root before building.\n"
        echo -e "  --config              \tRuns configuration step before building.\n"
        echo -e "  --flavour FLAVOUR     \tSets the flavour(s). Defaults to 'quickest'.\n"
        echo -e "  --js                  \tBuilds js compiler. Runs boot and configure.\n"
        echo -e "  --target TARGET       \tSpecifies the target e.g. nofib.\n"
        echo -e "  --test                \tRuns the validate tests only.\n"
        echo -e "  --threads NUM_THREADS \tSets the threads. Defaults to 8.\n"
        echo "Examples:"
        echo "  ghc_build --clean --config --build-root _build"
        return 0
        ;;
      "-b" | "--build-root")
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
      "--js")
        js=1
        ;;
      "--target")
        target="$2"
        shift
        ;;
      "--test")
        test=1
        ;;
      "--threads")
        threads="$2"
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

  if [[ 1 -eq $clean ]]; then
    echo "*** Cleaning $build_root ***"
    if [[ -d $build_root ]]; then
      rm -r --interactive=never $build_root
    else
      echo "$build_root does not exist"
    fi
  fi

  if [[ 1 -eq $config ]]; then
    if [[ 1 -eq $js ]]; then
      echo "*** Configuring JS ***"
      ghc_cfg_js
    else
      echo "*** Configuring ***"
      ghc_cfg
    fi
  fi

  if [[ 1 -eq $test ]]; then
    cmd="./validate --fast --testsuite-only"
  elif [[ 1 -eq $js ]]; then
    cmd="hadrian/build -j$threads --flavour=quick --bignum=native --docs=none --build-root=$build_root"
  else
    cmd="hadrian/build $target -j$threads --flavour=$flavour --build-root=$build_root"
  fi

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
  all=0
  dir="."
  clean=0
  dry_run=0
  cmd="cabal build"
  custom_cmd=""
  ghc_opts=""
  no_code=0
  target=""
  test=0
  verbose=0
  werror=0

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "hs_watch: Simple bash function for using entr with haskell.\n"
        echo "Usage: hs_watch [-a|--all]"
        echo "                [--clean]"
        echo "                [-c|--cmd COMMAND]"
        echo "                [-d|--dir DIR]"
        echo "                [--dry-run]"
        echo "                [-n|--no-code]"
        echo "                [--target STRING]"
        echo "                [-t|--test]"
        echo "                [-w|--werror]"
        echo "                [-v|--verbose]"
        echo "                [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  -a,--all        \tRuns 'cabal build all --enable-tests --enable-benchmarks'.\n"
        echo -e "  --clean         \tRuns 'cabal clean' before --cmd.\n"
        echo -e "  -c,--cmd COMMAND\tCommand to run with entr e.g. 'cabal build all'."
        echo -e "                  \tDefaults to 'cabal build'.\n"
        echo -e "  -d,--dir DIR    \tDirectory on which to run find. Defaults to '.'\n"
        echo -e "  --dry-run       \tShows which files will be watched.\n"
        echo -e "  -n,--no-code    \tPasses ghc --no-code, type checking only.\n"
        echo -e "  --target        \tCabal target.\n"
        echo -e "  -t,--test       \tSwaps 'cabal build' for 'cabal test'.\n"
        echo -e "  -w,--werror     \tAdds Werror to ghc-options.\n"
        echo "Examples:"
        echo "  hs_watch"
        echo -e "    = fd . -e cabal -e hs | entr -s \"cabal build\"\n"
        echo "  hs_watch -d /path/to/src"
        echo -e "    = fd . /path/to/src -e cabal -e hs | entr -s \"cabal build\"\n"
        echo "  hs_watch -c \"cabal test foo --test-options '-p \\\"pattern\\\"'\""
        echo -e "    = fd . -e cabal -e hs | entr -s \"cabal test foo '-p \\\"pattern\\\"'\"\n"
        return 0
        ;;
      "-a" | "--all")
        all=1
        ;;
      "--clean")
        clean=1
        ;;
      "-c" | "--cmd")
        custom_cmd=$2
        shift
        ;;
      "-d" | "--dir")
        dir=". $2"
        shift
        ;;
      "--dry-run")
        dry_run=1
        ;;
      "-n"| "--no-code")
        no_code=1
        ;;
      "--target")
        target="$2"
        shift
        ;;
      "--test" | "-t")
        test=1
        ;;
      "--verbose" | "-v")
        verbose=1
        ;;
      "--werror" | "-w")
        werror=1
        ;;
      *)
        echo "Unexpected arg: '$1'. Try --help."
        return 1
    esac
    shift
  done

  fd_cmd="fd $dir -e cabal -e hs -e project -e x -e y"

  # if custom_cmd is not set, take other options into account
  if [[ -z $custom_cmd ]]; then
    # swap build for test
    if [[ $test -eq 1 ]]; then
      cmd="cabal test"
    fi

    # Set target
    if [[ -n $target ]]; then
      # custom target
      cmd="$cmd $target"
    elif [[ $all -eq 1 ]]; then
      # all
      cmd="$cmd all --enable-tests --enable-benchmarks"
    fi

    # Add no_code. Note that this is inconsisent at best.
    if [[ $no_code -eq 1 ]]; then
      ghc_opts="$ghc_opts -fno-code"
    fi

    # add werror
    if [[ $werror -eq 1 ]]; then
      ghc_opts="$ghc_opts -Werror"
    fi

    # add clean
    if [[ $clean -eq 1 ]]; then
      cmd="cabal clean && $cmd"
    fi

    # add ghc_opts
    if [[ -n $ghc_opts ]]; then
      cmd="$cmd --ghc-options='$ghc_opts'"
    fi
  else
    cmd=$custom_cmd
  fi

  if [[ 1 -eq $dry_run ]]; then
    $fd_cmd
    echo ""
    verbose=1
  fi

  if [[ $verbose == 1 ]]; then
    echo "dir:  '$dir'"
    echo "cmd:  '$cmd'"
    echo -e "full: '$fd_cmd | entr -s $cmd'\n"
  fi

  if [[ 1 -eq $dry_run ]]; then
    return
  fi

  $fd_cmd | entr -s "$cmd"
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

  if [ `git branch | egrep "^\*?[[:space:]]+gh-pages$"` ]; then
    git branch -D gh-pages
  fi

  git checkout -b gh-pages

  # create docs
  if [[ -f "./tools/haddock.sh" ]]; then
    ./tools/haddock.sh
  elif  [[ -f "./scripts/haddock.sh" ]]; then
    ./scripts/haddock.sh
  else
    echo "No haddock shell script found."
    return 1
  fi

  # commit and push
  git add -A
  git commit -m "Add haddocks"
  git push -u --force origin gh-pages

  # checkout main
  # --force so we can run with shrun, which creates shrun.log
  git checkout main --force
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

# Watches files via fd and entr
watch_cmd () {
  dir="."
  clean=0
  dry_run=0
  ext=""
  cmd="echo 'files modified'"
  verbose=0

  while [ $# -gt 0 ]; do
    case "$1" in
      "--help" | "-h")
        echo -e "watch_cmd: Simple bash function for using entr with a command.\n"
        echo "Usage: watch_cmd [-c|--cmd COMMAND]"
        echo "                 [-d|--dir DIR]"
        echo "                 [--dry-run]"
        echo "                 [-e|--ext EXT]"
        echo "                 [-v|--verbose]"
        echo "                 [-h|--help]"
        echo ""
        echo "Available options:"
        echo -e "  -c,--cmd COMMAND\tCommand to run with entr e.g. 'cabal build'."
        echo -e "  -d,--dir DIR    \tDirectory on which to run find. Defaults to '.'\n"
        echo -e "  --dry-run       \tShows which files will be watched.\n"
        echo -e "  -e,--ext EXT    \tFile extension to watch\n"
        return 0
        ;;
      "--clean")
        clean=1
        ;;
      "--cmd" | "-c")
        cmd=$2
        shift
        ;;
      "-d" | "--dir")
        dir=". $2"
        shift
        ;;
      "--dry-run")
        dry_run=1
        ;;
      "-e" | "-ext")
        ext="$2"
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

  fd_cmd="fd $dir -e $ext"

  if [[ 1 -eq $dry_run ]]; then
    $fd_cmd
    return
  fi

  final_cmd=$cmd

  if [[ $verbose == 1 ]]; then
    echo "dir:  '$dir'"
    echo "cmd:  '$final_cmd'"
    echo -e "full: '$fd_cmd | entr -s $final_cmd'\n"
  fi

  $fd_cmd | entr -s "$final_cmd"
}

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

retry_success () {
  failed=0
  count=1
  while [[ $failed == 0 ]]; do
    $@
    if [[ $? == 0 ]]; then
      echo "'$@' succeeded on try $count"
      sleep 1
    else
      echo "'$@' failed on try $count"
      failed=1
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

shrun_su () {
  # -c: su has a different home dir, so we need to specify manually
  # --no-notify-action: dbus fails on root for some reason
  # --no-file-log-delete-on-success: we should probably default to logging on
  shrun \
    -c /home/tommy/.config/shrun/config.toml \
    --no-notify-action \
    --no-file-log-delete-on-success \
    "$1"
}

port_to_pid () {
  # e.g. port_to_pid 5432
  sudo ss -lptn "sport = :$1"
}

cpu_info () {
  lscpu | grep -E '^Thread|^Core|^Socket|^CPU\('
}

top_name () {
  # tragically this has a limit of 20 pids
  top -c -p $(pgrep -d',' -f "$1")
}
