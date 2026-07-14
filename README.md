# .dotfiles [use at your own risk]

my config files and other setup related information.
to be used with gnu stow

## setup

- install git, clone this repo into `~/.dotfiles`
- run `bash scripts/setup.sh`

The script installs Homebrew, oh-my-zsh, the `zsh-autosuggestions` plugin, the Brewfile packages, and Claude Code, then stows everything into `$HOME`.

### per-machine overrides

Two optional files let you customize per machine without editing the tracked dotfiles:

- `~/.gitconfig.local` — overrides `[user]` email / signingkey
- `~/.zshrc.local` — extra PATH exports, completions, anything machine-specific

Both are sourced automatically if present, ignored if not. Create them only where needed:

```
git config --file ~/.gitconfig.local user.email "you@example.com"
git config --file ~/.gitconfig.local user.signingkey "~/.ssh/id_ed25519.pub"
echo 'export PATH="$HOME/some/bin:$PATH"' >> ~/.zshrc.local
```

## config files

```
.
├── .gitconfig                  git + delta pager + custom aliases
├── .zshrc                      oh my zsh (ZSH_CUSTOM → .config/zsh-custom)
├── .claude/
│   └── statusline.sh           claude code status line
├── .config/
│   ├── nvim/
│   │   └── init.vim            neovim
│   └── zsh-custom/             oh-my-zsh custom dir (auto-sourced *.zsh)
│       └── git.zsh             g-prefix git aliases + ghelp cheat sheet
└── other/
    ├── Brewfile                homebrew dump
    ├── iterm2_profile.json     iterm2
    └── vscode/
        ├── settings.json       vscode settings
        └── keybindings.json    vscode keybinds
```

> `.config/` uses an allowlist in `.gitignore` — default-deny, opt in per module
> so app-written state (tokens, caches, machine IDs) stays untracked. Adding a
> new module? Append `!.config/<name>/` to `.gitignore`.

> `other/vscode/` is **legacy** — kept for reference only. I don't use VS Code
> day-to-day anymore, so it isn't stowed or wired into `setup.sh`.

## git workflow

The shell is loaded with oh-my-zsh's `git` plugin (`gst`, `gco`, `gcb`, `gp`, `gd`,
`gwip`, `gstp`, etc.) plus a layer of custom `g`-prefix aliases for the workflows
the plugin doesn't cover:

| Alias       | Does                                             |
|-------------|--------------------------------------------------|
| `gnb <b>`   | new branch off fresh `origin/main`               |
| `gplease`   | push `--force-with-lease` (safe force push)      |
| `gsave "m"` | named stash push                                 |
| `gpop`      | stash pop                                        |
| `gstashes`  | pretty stash list                                |
| `gun`       | undo last commit, keep changes staged            |
| `gfix`      | amend last commit, keep message                  |
| `glast`     | show last commit's file stats                    |
| `gfind "q"` | grep all commit messages                         |

Forgot one? Run **`ghelp`** for the full categorised cheat sheet, or
`ghelp <word>` to filter (e.g. `ghelp force`, `ghelp stash`, `ghelp undo`).

Diff/log output is paged through [`delta`](https://github.com/dandavison/delta)
with side-by-side view and the `OneHalfDark` syntax theme. `n`/`N` navigates
between files in the pager, `q` quits.

### notable gitconfig defaults

- `push.autoSetupRemote = true` — first `gp` on a new branch sets upstream automatically
- `pull.rebase = true` — no merge-commit spam on pulls
- `rebase.autoStash = true` — stash+pop around rebases
- `fetch.prune = true` — stale remote branches cleaned on fetch
- `rerere.enabled = true` — remembers conflict resolutions
- `branch.sort = -committerdate` — recent branches first in `git branch`
- `merge.conflictstyle = zdiff3` — 3-way conflict markers

## todo

- [x] gnu stow
- [x] setup script
- [x] delta + git aliases + ghelp
- [ ] config neovim
- [ ] work on zsh custom theme

## useful tools

- [claude code](https://claude.com/claude-code)
- [claude](https://claude.ai)
- [vscode](https://code.visualstudio.com)
- [neovim](https://neovim.io)
- [zed](https://zed.dev)
- [delta](https://github.com/dandavison/delta) — syntax-highlighted git diffs
- [logseq](https://logseq.com)
- [ticktick](https://ticktick.com)
- [zen browser](https://zen-browser.app)
- [figma](https://www.figma.com)
- [iterm2](https://iterm2.com)
- [neodisk](https://github.com/tkslucas/Neodisk) — read-only macOS disk space visualizer
