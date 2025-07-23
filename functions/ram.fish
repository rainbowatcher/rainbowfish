# @description Calculates the total RAM usage for processes matching a given name.
# @usage ram <process_name>
function ram
    # Use `string join` to treat all arguments as a single search pattern
    set -l app_name (string join " " $argv)

    if test -z "$app_name"
        echo "Usage: ram <process_name>"
        return 1
    end

    # 1. Use `pgrep` to robustly find all matching Process IDs (PIDs).
    # -i: case-insensitive
    # -f: match against the full command line
    set -l pids (pgrep -if -- "$app_name")

    # If no PIDs are found, report and exit.
    if not test -n "$pids"
        echo "No active processes matching pattern "(set_color blue)"$app_name"(set_color normal)""
        return 0
    end

    # 2. Use `ps` to get the Resident Set Size (RSS, in KiB) for exactly those PIDs.
    # -o rss=: Only output the RSS column, without a header.
    # Sum the values using awk for efficiency.
    set -l sum_kb (ps -o rss= -p $pids | awk '{s+=$1} END {print s}')

    # If the sum is zero or empty, treat as not found.
    if test -z "$sum_kb" -o "$sum_kb" -eq 0
        echo "No active processes matching pattern '"(set_color blue)"$app_name"(set_color normal)"'"
        return 0
    end

    # 3. Use fish's built-in `math` to convert KiB to MiB with 2 decimal places.
    set -l sum_mb (math --scale=2 "$sum_kb / 1024")

    # 4. Print the final, colored output.
    echo (set_color blue)"$app_name"(set_color normal)" uses "(set_color green)"$sum_mb"(set_color normal)" MB of RAM"
end
