if not set -q EDITOR
    if type -q helix
        set -gx EDITOR helix
    else if type -q hx
        set -gx EDITOR hx
    else if type -q nvim
        set -gx EDITOR nvim
    else if type -q vi
        set -gx EDITOR vi
    end
end
