function dev-zed -d "Open a project in Zed via SSH into the agent-sandbox Lima VM"
    # Usage: dev-zed [path]
    # e.g.  dev-zed ~/gh/my-project
    #       dev-zed              (opens ~/gh)

    # limactl list --json outputs NDJSON (one object per line), not an array.
    if not limactl list --json 2>/dev/null | jq -e 'select(.name == "agent-sandbox")' >/dev/null 2>&1
        echo "VM 'agent-sandbox' doesn't exist yet. Run 'dev' first to set it up."
        return 1
    end

    if not limactl list --json 2>/dev/null | jq -e 'select(.name == "agent-sandbox" and .status == "Running")' >/dev/null 2>&1
        echo "Starting agent-sandbox..."
        limactl start agent-sandbox
        or return 1
    end

    # Lima exposes SSH on a dynamic local port. Read it from the config.
    set -l ssh_port (awk '/^  Port / {print $2}' /Users/tom/.lima/agent-sandbox/ssh.config 2>/dev/null)
    if test -z "$ssh_port"
        echo "Could not determine SSH port. Is the VM running?"
        echo "Try: ssh -F /Users/tom/.lima/agent-sandbox/ssh.config lima-agent-sandbox"
        return 1
    end

    set -l remote_path "/home/tom.linux/gh"
    if test (count $argv) -ge 1
        set remote_path $argv[1]
    end

    echo "Opening $remote_path via SSH (tom@localhost:$ssh_port)..."
    zed "ssh://tom@localhost:$ssh_port/$remote_path"
end
