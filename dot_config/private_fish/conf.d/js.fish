if command -q fnm
  fnm env --use-on-cd --shell fish | source
end

if test -d "$HOME/.bun"; and not set -q BUN_INSTALL
    set --export BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
end
