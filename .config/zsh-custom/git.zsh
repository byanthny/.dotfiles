# Custom g-prefix git aliases (wrap git aliases defined in ~/.gitconfig)
# Auto-loaded by oh-my-zsh via ZSH_CUSTOM (see ~/.zshrc).
alias gplease='git please'       # safe force push (--force-with-lease)
alias gnb='git nb'               # new branch off fresh origin/main — usage: gnb feat/x
alias gun='git uncommit'         # soft-reset HEAD~1 (keeps changes staged)
alias gfix='git fixup'           # amend last commit, keep message
alias gsave='git save'           # named stash push — usage: gsave "fixing header"
alias gpop='git pop'             # stash pop
alias gstashes='git stashes'     # pretty stash list
alias glast='git last'           # show last commit's file stats
alias gfind='git find'           # grep commit messages — usage: gfind "auth bug"

# ghelp — pretty git-alias cheat sheet.
#   ghelp          full sheet
#   ghelp <word>   filter rows (headers always shown)
#
# Legend:  ★ = custom (added by this dotfiles setup)  ·  ⚠ = destructive  ·  ✓ = safe variant
ghelp() {
  local filter="${1:-}"

  # Colors
  local B=$'\e[1m' D=$'\e[2m' R=$'\e[0m'
  local C=$'\e[36m' Y=$'\e[33m' G=$'\e[32m' M=$'\e[35m' RED=$'\e[31m'

  # Header printer
  _ghelp_h() { printf "\n${B}${C}━━  %s  ━━${R}\n" "$1"; }
  _ghelp_r() { printf "  ${Y}%-14s${R} %s\n" "$1" "$2"; }

  {
    printf "\n${B}${M}  git cheat sheet${R}  ${D}— ★ custom · ⚠ destructive · ✓ safe${R}\n"

    _ghelp_h "EVERYDAY"
    _ghelp_r "gst"         "status"
    _ghelp_r "gss"         "short status"
    _ghelp_r "gaa"         "add all (${D}ga <f>${R} for one file)"
    _ghelp_r "gcam \"m\""  "add-all + commit"
    _ghelp_r "gcmsg \"m\"" "commit only staged"
    _ghelp_r "gd / gds"    "diff unstaged / staged"
    _ghelp_r "glog"        "pretty graph log"

    _ghelp_h "BRANCH"
    _ghelp_r "gb"          "list branches"
    _ghelp_r "gco <b>"     "checkout branch"
    _ghelp_r "gcb <b>"     "create + checkout branch"
    _ghelp_r "gnb <b>"     "★ new branch off fresh origin/main"
    _ghelp_r "gcm / gcd"   "checkout main / develop"
    _ghelp_r "gbd / gbD"   "delete / force-delete branch"

    _ghelp_h "PUSH · PULL · SYNC"
    _ghelp_r "gp"          "push  ${D}(auto-upstream, no -u needed)${R}"
    _ghelp_r "gl"          "pull  ${D}(rebases, no merge commit)${R}"
    _ghelp_r "gfa"         "fetch --all --prune"

    _ghelp_h "FORCE PUSH"
    printf "  ${G}✓${R} ${Y}%-14s${R} %s\n" "gplease" "★ push --force-with-lease  ${D}(refuses if remote moved)${R}"
    printf "  ${RED}⚠${R} ${Y}%-14s${R} %s\n" "gpf!" "push --force  ${D}(can clobber teammates)${R}"

    _ghelp_h "STASH  ${D}(hides from branch)${R}"
    _ghelp_r "gsave \"m\"" "★ named stash push"
    _ghelp_r "gpop"        "★ pop top stash"
    _ghelp_r "gstashes"    "★ pretty stash list"
    _ghelp_r "gstl / gsts" "list / show stash"
    _ghelp_r "gstd"        "drop one stash"
    printf "  ${RED}⚠${R} ${Y}%-14s${R} %s\n" "gstc" "clear ALL stashes"

    _ghelp_h "WIP  ${D}(commits — travels with branch)${R}"
    _ghelp_r "gwip"        "commit everything as WIP"
    _ghelp_r "gunwip"      "undo WIP ${D}(safe: checks commit msg)${R}"
    printf "  ${RED}⚠${R} ${Y}%-14s${R} %s\n" "gwipe" "nuke working tree + untracked"

    _ghelp_h "REBASE · MERGE"
    _ghelp_r "grb <b>"     "rebase onto branch"
    _ghelp_r "grbi"        "interactive rebase"
    _ghelp_r "grbc / grba" "continue / abort rebase"
    _ghelp_r "grbm"        "rebase onto main"
    _ghelp_r "gm <b>"      "merge"

    _ghelp_h "UNDO · AMEND"
    _ghelp_r "gun"         "★ undo last commit  ${D}(keep changes staged)${R}"
    _ghelp_r "gfix"        "★ amend, keep message"
    _ghelp_r "gcan!"       "omz equivalent of gfix"
    _ghelp_r "grh <f>"     "unstage file"
    printf "  ${RED}⚠${R} ${Y}%-14s${R} %s\n" "grhh"  "HARD reset (lose changes)"
    printf "  ${RED}⚠${R} ${Y}%-14s${R} %s\n" "groh"  "HARD reset to origin"

    _ghelp_h "LOG · SEARCH"
    _ghelp_r "glast"       "★ show last commit's file stats"
    _ghelp_r "gfind \"q\"" "★ grep all commit messages"
    _ghelp_r "glo"         "oneline log"

    _ghelp_h "TIPS"
    printf "  ${D}·${R} first ${Y}gp${R} auto-sets upstream — no ${Y}-u origin${R} dance\n"
    printf "  ${D}·${R} ${Y}gd${R}/${Y}gds${R} use delta pager — ${Y}n${R}/${Y}N${R} between files, ${Y}q${R} to quit\n"
    printf "  ${D}·${R} ${Y}gwip${R} → switch branch = WIP follows  ·  ${Y}gsave${R} = hide from branch\n"
    printf "  ${D}·${R} ${Y}ghelp <word>${R} filters: try ${Y}ghelp force${R}, ${Y}ghelp stash${R}, ${Y}ghelp undo${R}\n\n"

  } | if [[ -n "$filter" ]]; then
    # Keep section headers (lines starting with ━) + any matching rows
    grep -i --color=always -E "━━|$filter"
  else
    cat
  fi

  unfunction _ghelp_h _ghelp_r 2>/dev/null
}
