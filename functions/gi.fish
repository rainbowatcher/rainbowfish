# @description Fetches .gitignore files from gitignore.io API (via toptal.com).
# If one argument is given, downloads that .gitignore file.
# Otherwise, lists all available templates.
function gi --argument-names env
    # Check if exactly one argument was provided.
    if test (count $argv) -eq 1
        echo "Downloading .gitignore for '$env'..."
        curl -sfLw '\n' "https://www.toptal.com/developers/gitignore/api/$env" -o .gitignore

        # Check if the download was successful before judging.
        if test $status -eq 0
            echo (set_color green)Success (set_color normal): ".gitignore for '$env' created."(set_color normal)
        else
            echo (set_color red)Error (set_color normal): "Failed to download .gitignore for '$env'."(set_color normal) >&2
            return 1
        end
    else
        echo "Available .gitignore templates:"
        # List all available templates.
        # Use the built-in 'string replace' for performance and Fish-idiomatic code.
        # The '-a' or '--all' flag ensures all commas are replaced.
        curl -sfL https://www.toptal.com/developers/gitignore/api/list | string replace --all ',' '\n'
    end
end
