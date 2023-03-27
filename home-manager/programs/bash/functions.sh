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

# runs nix-hs-tools where first arg is tool and the rest are args
hs () {
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

cghcid () {
  ghcid --command "cabal repl $@"
}

ns () {
  nix-shell -L $@
}

nse () {
  nix-shell -L --command exit $@
}

nd () {
  nix develop -L $@
}

nde () {
  nix develop -L -c bash -c 'exit' $@
}

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

# find-replace
fr () {
  find . \
    -type f -name '*' ! -path "./.*" ! -path "./dist-newstyle/*" \
      | xargs sed -i "s/$1/$2/g"
}

# Update per https://github.com/badges/shields/issues/8671
update_badges () {
  find . \
    -type f -name '*md' ! -path "./.*" ! -path "./dist-newstyle/*" \
      | xargs sed -i -E 's/https:\/\/img.shields.io\/github\/workflow\/status\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_-]+)\?(.*)/http:\/\/img.shields.io\/github\/actions\/workflow\/status\/\1\/\2\/\3.yaml\?branch=\4\&\5/g'
}

del_hs () {
  find . \
    -type d -name .stack-work -o -name dist-newstyle \
      | xargs rm -r

  rm -r ~/.cabal
  rm -r ~/.stack
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

plasma_nix () {
  nix run github:pjones/plasma-manager
}

# Runs haddock job and pushes docs to gh-pages branch. Assumes
# the following:
#
# - main branch is 'main'
# - pages branch is 'gh-pages'
# - haddock script is 'make haddock' (i.e. makefile and cabal)
# - remote is 'origin'
haddock_push () {
  git checkout main && \
  git branch -D gh-pages && \
    git checkout -b gh-pages && \
    make haddock && \
    git add -A && \
    git commit -m "Add haddocks" && \
    git push -u --force origin gh-pages && \
    git checkout main
}