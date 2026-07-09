function load-dotenv --description 'Load environment variables from a .env file'
    set -l env_file .env
    if test (count $argv) -gt 0
        set env_file $argv[1]
    end

    if not test -f $env_file
        echo "Error: $env_file file not found."
        return 1
    end

    while read -l line; or test -n "$line"
        string match -q -r '^#|^$' "$line"; and continue
        set -l kv (string split -m 1 = $line)
        # Remove potential wrapping quotes around the value
        set -l val (string trim -c '"\' ' $kv[2])
        set -gx $kv[1] $val
    end < $env_file

    echo "Successfully loaded $env_file"
end
