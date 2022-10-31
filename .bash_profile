alias compilec="gcc -std=c99 -Wall -Wextra -pedantic"

alias cl="clear"

alias compilecpp="g++ -std=c++11 -pedantic -Wall -Wextra"

HOMEBREW_EDITOR="/usr/bin/emacs"

alias jn="jupyter notebook"

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

alias cddev="cd ~/Developer/_projects/in\ progress/"
