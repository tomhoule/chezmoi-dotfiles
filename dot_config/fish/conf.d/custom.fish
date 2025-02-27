# Abbreviations
abbr --add -- cntr 'cargo nextest run'
abbr --add -- dc 'docker compose'
abbr --add -- e '$EDITOR'
abbr --add -- g git
abbr --add -- st 'git status'

# Aliases
alias cat bat
alias corgi cargo
alias ls eza

# Interactive shell initialisation
function tn
    set --local DIRNAME $(basename $(pwd | tr -d '\n'))
    tmux new -s $DIRNAME
end

# No greeting
set -U fish_greeting
