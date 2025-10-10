if set -q $CARGO_HOME
    set CARGO_ENV_FISH "$CARGO_HOME/env.fish"
else
    set CARGO_ENV_FISH ~/env.fish
end

if test -e $CARGO_ENV_FISH
    source $CARGO_ENV_FISH
end
