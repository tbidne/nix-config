###############################################################################
#                                 GENERAL NIX                                 #
###############################################################################

# Functions for launching nix shell w/ various args

ns () {
  nix-shell -L $@
}

nsj1 () {
  nix-shell --max-jobs 1 -L $@
}

nse () {
  nix-shell -L --command exit $@
}

nsej1 () {
  nix-shell --max-jobs 1 -L --command exit $@
}

nd () {
  nix develop -L $@
}

ndj1 () {
  nix develop --max-jobs 1 -L $@
}

nde () {
  nix develop -L -c bash -c 'exit' $@
}

ndej1 () {
  nix develop --max-jobs 1 -L -c bash -c 'exit' $@
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

nix_info() {
  nix-shell -p nix-info --run "nix-info -m"
}

plasma_nix () {
  nix run github:pjones/plasma-manager
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

# applies unsym-f to all files in the current directory
unsym_d () {
  for f in $(find -type l); do
    cp --remove-destination $(readlink $f) $f
    chmod a+rw $f
  done
}

###############################################################################
#                                NIX + HASKELL                                #
###############################################################################

# runs nix-hs-tools where first arg is tool and the rest are args
htool () {
  nix run github:tbidne/nix-hs-tools/0.8#$1 -- ''${@:2}
}

# Launches a nix shell using those defined in my external repo.
# The first arg is the shell and the rest are passed through. E.g.
#
# hshell liquidhaskell
# hshell liquidhaskell --arg ghcid false
hshell () {
  if [[ -z "$1" ]]; then
    attr=default
    args=""
  else
    attr=$1
    args=''${@:2}
  fi

  nix-shell http://github.com/tbidne/nix-hs-shells/archive/main.tar.gz -A $attr $args
}

###############################################################################
#                                   HASKELL                                   #
###############################################################################

hs_del () {
  find . \
    -type d -name .stack-work -o -name dist-newstyle -o -name result \
      | xargs rm -r

  if [[ -d ~/.cabal ]]; then
    echo "deleting ~/.cabal"
    rm -r ~/.cabal
  fi
  if [[ -d ~/.cabal ]]; then
    echo "deleting ~/.stack"
    rm -r ~/.stack
  fi
}

# Watches hs files via find and entr
hs_watch () {
  dir="."
  clean=0
  cmd="cabal build"
  verbose=0

  while [ $# -gt 0 ]; do
    if [[ $1 == "--help" || $1 == "-h" ]]; then
      echo -e "hs_watch: Simple bash function for using entr with haskell.\n"
      echo "Usage: hs_watch [--clean]"
      echo "                [-c|--cmd COMMAND]"
      echo "                [-d|--dir DIR]"
      echo "                [-v|--verbose]"
      echo "                [-h|--help]"
      echo ""
      echo "Available options:"
      echo -e "  --clean         \tRuns 'cabal clean' before --cmd.\n"
      echo -e "  -c,--cmd COMMAND\tCommand to run with entr e.g. 'cabal build all'."
      echo -e "                  \tDefaults to 'cabal build'.\n"
      echo -e "  -d,--dir DIR    \tDirectory on which to run find. Defaults to '.'\n"
      echo "Examples:"
      echo "  hs_watch"
      echo -e "    = find . -type f -name \"*.hs\" | entr -s \"cabal build\"\n"
      echo "  hs_watch -d /path/to/src"
      echo -e "    = find /path/to/src -type f -name \"*.hs\" | entr -s \"cabal build\"\n"
      echo "  hs_watch -c \"cabal test foo --test-options '-p \\\"pattern\\\"'\""
      echo -e "    = find . -type f -name \"*.hs\" | entr -s \"cabal test foo '-p \\\"pattern\\\"'\"\n"
      return 0
    elif [[ $1 == "--clean" ]]; then
      clean=1
    elif [[ $1 == "--cmd" || $1 == "-c" ]]; then
      cmd=$2
      shift
    elif [[ $1 == "--dir" || $1 == "-d" ]]; then
      dir=($2)
      shift
    elif [[ $1 == "--verbose" || $1 == "-v" ]]; then
      verbose=1
    else
      echo "Unexpected arg: '$1'. Try --help."
      return 1
    fi
    shift
  done

  if [[ 1 -eq $clean ]]; then
    final_cmd="cabal clean && $cmd"
  else
    final_cmd=$cmd
  fi

  excluded_dirs="! -path */\".*\" ! -path */dist-newstyle/* ! -path */stack-work/*"
  find_cmd="find $dir -type f -name *.hs $excluded_dirs"

  if [[ $verbose = 1 ]]; then
    echo "dir:  '$dir'"
    echo "cmd:  '$final_cmd'"
    echo -e "full: '$find_cmd | entr -s $final_cmd'\n"
  fi

  $find_cmd | entr -s "$final_cmd"
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
  git add -A && \
    git commit --amend --no-edit && \
    git push --force && \
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

###############################################################################
#                                     MISC                                    #
###############################################################################

color_my_prompt () {
  local __user_and_host="\[\033[01;32m\]\u@\h"
  local __cur_location="\[\033[01;34m\]\w"
  local __git_branch_color="\[\033[31m\]"
  #local __git_branch="\`ruby -e \"print (%x{git branch 2> /dev/null}.grep(/^\*/).first || \'\').gsub(/^\* (.+)$/, '(\1) ')\"\`"
  local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
  local __prompt_tail="\[\033[35m\]\n$"
  local __last_color="\[\033[00m\]"
  export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
}
