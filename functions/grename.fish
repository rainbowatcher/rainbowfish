function grename
    # Check if the correct number of arguments was provided.
    if test (count $argv) -ne 2
        # Print usage information to standard error (stderr).
        # 'status current-command' dynamically gets the function name ('gmv').
        echo "Usage: grename <old_branch> <new_branch>" >&2
        return 1
    end

    # Assign arguments to descriptive local variables.
    set -l old_branch $argv[1]
    set -l new_branch $argv[2]

    echo "Renaming local branch from '$old_branch' to '$new_branch'..."
    git branch -m "$old_branch" "$new_branch"

    # Check the exit status of the local rename before proceeding.
    if test $status -ne 0
        echo "Failed to rename local branch." >&2
        return $status
    end

    echo "Attempting to rename remote branch on 'origin'..."
    # If the remote branch exists and is deleted successfully...
    if git push origin --delete "$old_branch"
        # ...then push the new branch and set it as the upstream.
        echo "Pushing new branch '$new_branch' and setting upstream..."
        git push --set-upstream origin "$new_branch"
    else
        # Handle cases where the remote branch doesn't exist or deletion fails.
        echo "Info: Remote branch '$old_branch' not found on 'origin' or could not be deleted." >&2
        echo "You may need to push the new branch manually: git push -u origin $new_branch" >&2
    end
end
