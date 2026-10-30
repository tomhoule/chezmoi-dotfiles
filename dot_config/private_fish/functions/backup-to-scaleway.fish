function backup-to-scaleway --description 'Set up, initialize, or run Scaleway backups with restic' --argument-names action
    set -l usage 'Usage: backup-to-scaleway [setup|init|backup] (default: backup)'
    if test (count $argv) -gt 1
        echo "$usage" >&2
        return 2
    end
    if test (count $argv) -eq 0
        set action backup
    end
    switch $action
        case setup init backup
        case -h --help
            echo "$usage"
            return 0
        case '*'
            echo "Unknown Scaleway backup action: $action" >&2
            echo "$usage" >&2
            return 2
    end

    set -l role tom-main
    set -l bucket workstation-backups
    set -l region fr-par
    set -l repository s3:https://s3.$region.scw.cloud/$bucket/restic/$role
    set -l attributes service=restic-scaleway role=$role
    set -l credentials AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_PASSWORD

    set -l tools oo7-cli
    if test "$action" != setup
        set -a tools restic
    end
    for tool in $tools
        if not command -q $tool
            echo "Required command not found: $tool" >&2
            return 1
        end
    end

    if test "$action" = setup
        for variable in $credentials
            # oo7-cli returns success with no output when no entry matches.
            set -l secret (command oo7-cli lookup --secret-only $attributes credential=$variable)
            or begin
                echo "Could not look up $variable in the keychain for $role." >&2
                return 1
            end
            if test (count $secret) -gt 1
                echo "Expected a single-line keychain secret for $variable ($role)." >&2
                return 1
            end
            if test (count $secret) -eq 1; and test -n "$secret"
                echo "$variable is already stored for $role."
                continue
            end

            echo "Store $variable for $role:"
            command oo7-cli store "$variable for Scaleway backup ($role)" $attributes credential=$variable
            or begin
                echo "Could not store $variable in the keychain for $role." >&2
                return 1
            end
        end

        echo "Keychain setup complete. Keep a recovery copy of the repository password outside this machine."
        return 0
    end

    set -l dry_run
    switch $action
        case backup
            echo "Back up local directories to $bucket/restic/$role?"
            read --nchars 1 --prompt-str "[y]es/[n]o/[d]ry run: " --local confirmation
            echo

            switch $confirmation
                case y Y
                    echo "Starting backup..."
                case d D
                    echo "Starting backup dry run..."
                    set dry_run --dry-run
                case '*'
                    echo "Backup cancelled."
                    return 1
            end
        case init
            echo "Initialize the restic repository at $bucket/restic/$role?"
            read --nchars 1 --prompt-str "[y]es/[n]o: " --local confirmation
            echo

            switch $confirmation
                case y Y
                case '*'
                    echo "Initialization cancelled."
                    return 1
            end
    end

    set -lx AWS_ACCESS_KEY_ID
    set -lx AWS_SECRET_ACCESS_KEY
    for variable in $credentials[1..2]
        set -l secret (command oo7-cli lookup --secret-only $attributes credential=$variable)
        or begin
            echo "Could not read $variable from the keychain for $role." >&2
            return 1
        end
        if test (count $secret) -ne 1; or test -z "$secret"
            echo "Expected one nonempty keychain secret for $variable ($role)." >&2
            return 1
        end
        set $variable "$secret"
    end

    # Ignore inherited password settings so restic always uses the keychain command.
    set -lu RESTIC_PASSWORD
    set -lu RESTIC_PASSWORD_FILE
    set -lu RESTIC_PASSWORD_COMMAND
    set -l password_command (string join ' ' -- (string escape -- oo7-cli lookup --secret-only $attributes credential=$credentials[3]))
    set -l options --repo $repository --password-command "$password_command" -o s3.storage-class=STANDARD -o s3.region=$region

    if test "$action" = init
        command restic $options init
        set -l init_status $status
        if test $init_status -ne 0
            echo "Repository initialization failed (restic exit status $init_status)." >&2
            return $init_status
        end

        echo "Repository initialized. Run backup-to-scaleway to create the first snapshot."
        return 0
    end

    set -l sources
    for dirname in Desktop Downloads Documents Music Pictures Templates Public Videos src
        set -a sources "$HOME/$dirname"
    end

    command restic $options backup $dry_run --host $role $sources
    set -l backup_status $status
    if test $backup_status -ne 0
        echo "Backup failed or was incomplete (restic exit status $backup_status)." >&2
        return $backup_status
    end

    if test (count $dry_run) -gt 0
        echo "🥦 Backup dry run complete."
    else
        echo "🥦 Backup complete."
    end
end
