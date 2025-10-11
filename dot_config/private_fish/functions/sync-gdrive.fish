function sync-gdrive
    set directory_name "$(hostname)"

    if test -z $directory_name
        echo "Could not determine hostname"
        return 1
    end

    set source_path ~/Documents/gdrive-outbox
    set target_path "gdrive-tom:/Inbox/$(hostname)"
    set sync_command "rclone sync $source_path $target_path"

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
