#!/usr/bin/env bash
# one-time fix for a folded ~/.config.
# older setups stowed without --no-folding, so ~/.config is a symlink into this
# repo and every app writes its state here. this moves that state back into a
# real ~/.config and restows. run it from the main checkout, not a worktree.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd -P)"
CONFIG="$HOME/.config"

die() { echo "unfold-config: $*" >&2; exit 1; }

# 1. only run when ~/.config is the folded link into this repo
[ -L "$CONFIG" ] || die "$CONFIG is not a symlink, nothing to unfold"
[ "$CONFIG" -ef "$DOTFILES/.config" ] || die "$CONFIG does not point at $DOTFILES/.config"
command -v stow >/dev/null 2>&1 || die "stow not found, run: brew install stow"
# the old zsh-autosuggestions submodule clone would get stowed again
[ ! -e "$DOTFILES/.oh-my-zsh/plugins" ] \
  || die "remove the old submodule clone first: rm -rf \"$DOTFILES/.oh-my-zsh/plugins\" (brew installs zsh-autosuggestions now)"

# 2. list what git doesn't track in the repo's .config, that's app state
tracked="$(git -C "$DOTFILES" ls-files -- .config | cut -d/ -f2 | sort -u)"
[ -n "$tracked" ] || die "git tracks nothing under .config, stopping"
untracked=()
shopt -s nullglob dotglob
for path in "$DOTFILES/.config"/*; do
  name="${path##*/}"
  grep -qxF "$name" <<<"$tracked" || untracked+=("$name")
done
shopt -u nullglob dotglob

echo "tracked, stays in the repo:"
while IFS= read -r name; do echo "  $name"; done <<<"$tracked"
echo "untracked, moves to $CONFIG:"
for name in ${untracked[@]+"${untracked[@]}"}; do echo "  $name"; done
echo "quit apps that write to ~/.config before going on."
read -r -p "continue? [y/N] " answer
case "$answer" in y|Y) ;; *) die "stopped, nothing changed" ;; esac

# from here on a failure leaves things half done, so say where to look
trap 'echo "unfold-config: stopped partway, check $CONFIG and $DOTFILES/.config" >&2' ERR

# 3. swap the link for a real dir
rm "$CONFIG"
mkdir "$CONFIG"

# 4. move app state out of the repo, never overwriting
for name in ${untracked[@]+"${untracked[@]}"}; do
  if [ -e "$CONFIG/$name" ] || [ -L "$CONFIG/$name" ]; then
    die "$CONFIG/$name already exists, stopping. check $CONFIG and $DOTFILES/.config"
  fi
  mv "$DOTFILES/.config/$name" "$CONFIG/$name"
done

# 5. stale links from the old submodule setup
for link in "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" "$HOME/.gitmodules"; do
  if [ -L "$link" ]; then rm "$link"; fi
done

# 6. restow without folding, so ~/.config stays a real dir
cd "$DOTFILES"
stow --no-folding --target="$HOME" --restow .
trap - ERR

# 7. show the result and check it
ls -la "$CONFIG"
fail=0
if [ -L "$CONFIG" ] || [ ! -d "$CONFIG" ]; then
  echo "not ok: $CONFIG is not a real dir"; fail=1
fi
# no folding means nvim/ and zsh-custom/ are real dirs and each tracked file is a link
while IFS= read -r f; do
  if [ -L "$HOME/$f" ] && [ "$HOME/$f" -ef "$DOTFILES/$f" ]; then
    echo "ok: ~/$f links into the repo"
  else
    echo "not ok: ~/$f is not a link into the repo"; fail=1
  fi
done < <(git -C "$DOTFILES" ls-files -- .config)
if [ "$fail" -eq 0 ]; then echo "done. ~/.config is a real dir and app state lives outside the repo"; fi
exit "$fail"
