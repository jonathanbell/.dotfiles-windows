#!/usr/bin/env bash

# Using the --global option will write the values to the global `.gitconfig` file, `~/.gitconfig`.
# Alternatively, I guess we could syslink a .gitconfig file to a .gitconfig file in this repo (such as `.dotfiles/git/.gitgonfig`).
# However, this prevents absolute paths that get written to `.gitconfig` ending up in this repo.
git config --global user.name "Jonathan Bell"
# https://gist.github.com/trey/2722934#bonus
git config --global user.email "jonathanbell.ca@gmail.com"
# Set VS Code as the core text editor.
git config --global core.editor code
# http://stackoverflow.com/q/3206843/1171790
git config --global core.autocrlf input
# Fix whitespace isssues. http://stackoverflow.com/a/2948167/1171790
git config --global core.whitespace fix
# But don't warn about whitespace, thanks.
git config --global apply.whitespace nowarn
# Allow all Git commands to use colored output.
git config --global color.ui true
# https://gist.github.com/trey/2722934
git config --global color.branch auto
git config --global color.diff auto
git config --global color.status auto
git config --global color.interactive auto
git config --global color.ui true
git config --global color.pager true
# Push only the current branch to remote (same as what a `git pull` would use).
# Note that the remote branch *could* possibly have a different name than your local branch.
# https://git-scm.com/docs/git-config.html#git-config-branchltnamegtremote
git config --global push.default current
# Accept the auto-generated merge message.
# https://git-scm.com/docs/merge-options#merge-options---no-edit
git config --global core.mergeoptions --no-edit

# TODO: Setup VS Code as our mergetool

# Global .gitignore
git config --global core.excludesfile ~/.dotfiles/git/.gitignore_global
# Global attributes
git config --global core.attributesfile ~/.dotfiles/git/.gitattributes_global
