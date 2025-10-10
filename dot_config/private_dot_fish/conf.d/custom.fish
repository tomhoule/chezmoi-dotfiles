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
set fish_greeting

if type -q helix
    set EDITOR helix
else if type -q hx
    set EDITOR hx
else if type -q nvim
    set EDITOR nvim
else if type -q vi
    set EDITOR vi
end
