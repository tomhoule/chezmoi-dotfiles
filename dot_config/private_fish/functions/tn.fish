function tn
    set --local DIRNAME $(basename $(pwd | tr -d '\n'))
    tmux new -s $DIRNAME
end
