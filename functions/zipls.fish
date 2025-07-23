# @description Lists the contents of various compressed archive files without extracting them.
# @usage peek <archive1> [<archive2> ...]
#
# @dependencies tar, unzip, unrar, 7z
function zipls --description "Lists contents of various compressed archive files."
    # Check if any arguments were provided.
    if test (count $argv) -eq 0
        echo (set_color red)"Usage: zipls <file1.zip> [<file2.tar.gz> ...]"(set_color normal)
        echo "Supported formats: .zip, .rar, .7z, .tar, .tar.gz, .tgz, .tar.bz2, .tbz2, .tar.xz, .txz, .jar"
        return 1
    end

    # Loop through each file provided as an argument.
    for file in $argv
        # Check if the file actually exists before proceeding.
        if not test -f "$file"
            echo (set_color yellow)"Warning: File not found:"(set_color normal)" $file"
            # `continue` skips to the next iteration of the loop.
            continue
        end

        # Print a clear header for each file's output.
        echo (set_color cyan --bold)"--- Contents of: "(set_color --bold blue)"$file"(set_color normal)" ---"

        # The core logic: a switch statement to dispatch based on file extension.
        switch "$file"
            # Case for .zip files
            case '*.zip'
                unzip -l "$file"

            # Case for .rar files
            case '*.rar'
                # `unrar l` is the list command for the non-free unrar.
                # If you use `bsdtar` or `unar`, the command might be different.
                unrar l "$file"

            # Case for .7z files
            case '*.7z'
                7z l "$file"

            # Cases for various tarballs. `tar` can auto-detect compression.
            # We use explicit flags for clarity and correctness.
            case '*.tar'
                tar -tf "$file"
            case '*.tar.gz' '*.tgz'
                tar -tzf "$file"
            case '*.tar.bz2' '*.tbz2'
                tar -tjf "$file"
            case '*.tar.xz' '*.txz'
                tar -tJf "$file"
            case '*.jar'
                jar -tf "$file"

            # Default case for unsupported file types.
            case '*'
                echo (set_color red)"Error: Unsupported file type for '$file'."(set_color normal)
                echo "Don't know how to peek inside."
        end
        # Add a newline for better separation between outputs of multiple files.
        echo ""
    end
end
