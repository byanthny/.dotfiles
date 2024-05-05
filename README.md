# .dotfiles [use at your own risk]

my config files and other setup related information.
to be used with gnu stow

## setup

- install homebrew (on mac), x (on windows)
- install stow
- install git
- clone this repo
- run setup.sh (todo)

### ignoring local changes

you can use `git update-index --skip-worktree <file-list>` to ignore changes to files that are being tracked by git (useful for different .gitconfig's)

use `git update-index --no-skip-worktree <file-list>` to start tracking changes again.

## config files

- .gitconfig - git
- init.vim - neovim
- .zshrc - oh my zsh
- ~~.bash_profile, .bashrc - bash~~ (using zsh now)
- vscode/settings.json, vscode/keybindings.json - vscode
- Brewfile - Homebrew dump
- iterm2_profile.json - iterm2
- /archives - backups or old config files

## todo

- [x] gnu stow
- [ ] setup script, customized install (OS & scope specific)
- [ ] config neovim
- [ ] work on zsh custom theme
- [ ] add windows and mac apps

## other useful applications (not exhaustive)

- logseq
- tick tick
- brave
- zed (testing)

### Mac

- alttab
- magnet
- bartender
- iterm2

### Windows

- wsl
