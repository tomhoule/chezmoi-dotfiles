function sync-gdrive
    set directory_name "$(hostname)"

    if test -z $directory_name
        echo "Could not determine hostname"
        return 1
    end

    set source_path ~/Documents/gdrive-outbox
    set target_path "gdrive-tom:/Inbox/$(hostname)"
    set sync_command "rclone sync --interactive --progress $source_path $target_path"

    echo "Syncing outbox"
    echo "Run this? $sync_command"
    read --nchars 1 --local --prompt-str "[y/N]: " confirm

    switch $confirm
    case "y" "Y"
        eval $sync_command
        if test $status -ne 0
            echo "Command failed with status $status"
            return $status
        end
    case '*'
        echo "Sync cancelled"
        return 1
    end

    set source_path "gdrive-tom:/"
    set target_path ~/gdrive
    set sync_command "rclone sync --interactive --progress $source_path $target_path"

    echo ""
    echo "Syncing inbox"
    echo ""
    echo "Run this? $sync_command"
    read --nchars 1 --local --prompt-str "[y/N]: " confirm

    switch $confirm
    case "y" "Y"
        eval $sync_command
        return $status
    case '*'
        echo "Sync cancelled"
        return 1
    end
end
