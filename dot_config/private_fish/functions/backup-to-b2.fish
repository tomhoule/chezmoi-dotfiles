function backup-to-b2
    switch $(hostname)
    case "fw13"
        set bucket_name "private-laptop"
    case '*'
        echo "No backblaze-b2 bucket defined for this machine."
        return 1
    end

    echo "Back up local directories to $bucket_name?"
    read --prompt-str "[y]es/[n]o/[d]ry run: " --local confirmation

    switch $confirmation
    case "y" "Y"
        echo "Starting backup..."
    case "d"
        echo "Starting backup dry run..."
        set dry_run "--dry-run"
    case '*'
        echo "Backup cancelled."
        return 1
    end

    for dirname in Desktop Downloads Documents Music Pictures Templates Public Videos src
        set src "$HOME/$dirname"
        echo "Syncing from $src to backblaze-b2:$bucket_name"
        rclone sync $dry_run --progress $src backblaze-b2:$bucket_name/$dirname
    end

    echo "🥦 Done syncing."
end
