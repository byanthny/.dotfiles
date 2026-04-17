# .dotfiles [use at your own risk]

my config files and other setup related information.
to be used with gnu stow

## setup

- install git, clone this repo into `~/.dotfiles`
- run `./scripts/setup.sh`

The script installs Homebrew, oh-my-zsh, the `zsh-autosuggestions` plugin, the Brewfile packages, and Claude Code, then stows everything into `$HOME`.

### ignoring local changes

you can use `git update-index --skip-worktree <file-list>` to ignore changes to files that are being tracked by git (useful for different .gitconfig's)

use `git update-index --no-skip-worktree <file-list>` to start tracking changes again.

## config files

- .gitconfig - git
- init.vim - neovim
- .zshrc - oh my zsh
- .claude/statusline.sh - claude code status line
- vscode/settings.json, vscode/keybindings.json - vscode
- other/Brewfile - Homebrew dump
- iterm2_profile.json - iterm2

## todo

- [x] gnu stow
- [x] setup script
- [ ] config neovim
- [ ] work on zsh custom theme

## useful tools

- [claude code](https://claude.com/claude-code)
- [claude](https://claude.ai)
- [vscode](https://code.visualstudio.com)
- [neovim](https://neovim.io)
- [zed](https://zed.dev)
- [logseq](https://logseq.com)
- [ticktick](https://ticktick.com)
- [zen browser](https://zen-browser.app)
- [figma](https://www.figma.com)
- [iterm2](https://iterm2.com)
