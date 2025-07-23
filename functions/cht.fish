function cht --argument-names query
    set -l query (string join '+' $argv)
    if test -z "$query"
        echo "Usage: cheat <topic> [subtopic...]" >&2
        echo "Example: cheat bash for loop" >&2
        return 1
    end
    echo (set_color -o yellow)"curl cht.sh/$query"(set_color normal)
    curl "cht.sh/$query"
end 