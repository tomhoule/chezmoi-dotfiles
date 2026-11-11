function backup-mail --description 'Set up or download an IMAP mail backup' --argument-names action
    set -l usage 'Usage: backup-mail [setup|sync|dry-run] (default: sync)'
    if test (count $argv) -gt 1
        echo "$usage" >&2
        return 2
    end
    if test (count $argv) -eq 0
        set action sync
    end
    switch $action
        case setup sync dry-run
        case -h --help
            echo "$usage"
            return 0
        case '*'
            echo "Unknown mail backup action: $action" >&2
            echo "$usage" >&2
            return 2
    end

    set -l attributes service=backup-mail credential=imap-password
    set -l tools oo7-cli
    if test "$action" != setup
        set -a tools mbsync
    end
    for tool in $tools
        if not command -q $tool
            echo "Required command not found: $tool" >&2
            return 1
        end
    end

    # oo7-cli returns success with no output when no entry matches.
    set -l secret (command oo7-cli lookup --secret-only $attributes)
    or begin
        echo "Could not look up the IMAP backup password in the keychain." >&2
        return 1
    end
    if test (count $secret) -gt 1
        echo "Expected a single-line IMAP backup password." >&2
        return 1
    end

    if test "$action" = setup
        if test (count $secret) -eq 1; and test -n "$secret"
            echo "The IMAP backup password is already stored."
            return 0
        end
        echo "Store the IMAP backup password (use an app password if required):"
        command oo7-cli store "Email backup IMAP password" $attributes
        return $status
    end

    if test (count $secret) -ne 1; or test -z "$secret"
        echo "No IMAP backup password stored. Run backup-mail setup first." >&2
        return 1
    end
    set -e secret

    set -l config_dir "$HOME/.config"
    if set -q XDG_CONFIG_HOME; and test -n "$XDG_CONFIG_HOME"
        set config_dir "$XDG_CONFIG_HOME"
    end
    set -l config "$config_dir/isyncrc"
    if not test -f "$config"
        echo "Missing mbsync configuration: $config. Apply the dotfiles first." >&2
        return 1
    end


    set -l dry_run
    if test "$action" = dry-run
        set dry_run --dry-run
    end
    command mbsync --config "$config" $dry_run mailbox-backup
end
