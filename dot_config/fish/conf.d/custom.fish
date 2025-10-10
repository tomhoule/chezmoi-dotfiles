# Abbreviations
abbr --add -- cntr 'cargo nextest run'
abbr --add -- dc 'docker compose'
abbr --add -- e '$EDITOR'
abbr --add -- g git
abbr --add -- st 'git status'
abbr --add -- tw 'typst watch'
abbr --add -- cm 'chezmoi'

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

if type -q helix
    set -U EDITOR hx
else if type -q hx
    set -U EDITOR hx
end
