if not status is-interactive
    exit
end

# Abbreviations
abbr --add -- cntr 'cargo nextest run'
abbr --add -- dc 'docker compose'
abbr --add -- e '$EDITOR'
abbr --add -- g git
abbr --add -- st 'git status'
abbr --add -- tw 'typst watch'
abbr --add -- cm chezmoi

# Aliases
alias cat bat
alias corgi cargo
alias ls eza

# No greeting
set fish_greeting
