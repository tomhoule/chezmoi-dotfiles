if set -q $CARGO_HOME
    set CARGO_ENV_FISH "$CARGO_HOME/env.fish"
    fish_add_path "$CARGO_HOME/bin"
else
    set CARGO_ENV_FISH ~/.cargo/env.fish
    fish_add_path ~/.cargo/bin
end

if test -e $CARGO_ENV_FISH
    source $CARGO_ENV_FISH
end
