function dev -d "Jump into the agent-sandbox Lima VM with tmux"
    # Start the VM if it exists but isn't running.
    # limactl list --json outputs NDJSON (one object per line), not an array.
    if not limactl list --json 2>/dev/null | jq -e 'select(.name == "agent-sandbox")' >/dev/null 2>&1
        echo "VM 'agent-sandbox' doesn't exist yet. Create it with:"
        echo "  limactl create --name=agent-sandbox ~/.config/lima/agent-sandbox.yaml"
        echo "  limactl start agent-sandbox"
        return 1
    end

    if not limactl list --json 2>/dev/null | jq -e 'select(.name == "agent-sandbox" and .status == "Running")' >/dev/null 2>&1
        echo "Starting agent-sandbox..."
        limactl start agent-sandbox
        or return 1
    end

    # Attach to an existing tmux session, or create one.
    # -A makes new-session behave like attach if the session exists.
    limactl shell agent-sandbox -- tmux new-session -A -s main
end
