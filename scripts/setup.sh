#!/usr/bin/env bash
# Bootstrap this dotfiles repo on a fresh macOS machine.
set -euo pipefail

# Create setup files
DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # a fresh install isn't on PATH in this shell yet
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Brew packages (autojump, stow, zsh-autosuggestions, git, go, neovim, etc.)
brew bundle --file="$DOTFILES/other/Brewfile"

# 4. Claude Code
if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

# 5. Symlink dotfiles into $HOME via GNU stow
#    Remove any plain .zshrc (e.g. the oh-my-zsh template) so stow can place ours.
#    --no-folding keeps ~/.config a real dir, so app state never lands in the repo.
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && rm "$HOME/.zshrc"
cd "$DOTFILES"
stow --no-folding --target="$HOME" --restow .

cat <<'EOF'

dotfiles setup complete — restart your shell

Per-machine overrides (create if needed):
  ~/.gitconfig.local   — [user] email + signingkey
  ~/.zshrc.local       — machine-specific PATH exports / completions
EOF
