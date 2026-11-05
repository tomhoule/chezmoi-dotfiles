function alacritthere -d "Open Alacritty in the current directory"
    alacritty --working-directory "$PWD" </dev/null &>/dev/null &
    disown $last_pid
end
