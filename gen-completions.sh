#!/usr/bin/env bash

COMPLETIONS_DIR="completions"

trash -r "./$COMPLETIONS_DIR"/*


# codegpt completion zsh > "$COMPLETIONS_DIR/_codegpt" # not work now
# fnm completions --shell fish > "$COMPLETIONS_DIR/fnm.fish"
# npm completion > "$COMPLETIONS_DIR/npm.fish"
# pip completion --fish > "$COMPLETIONS_DIR/__fish_complete_pip.fish"
pnpm completion fish > "$COMPLETIONS_DIR/pnpm.fish"
# mise completion fish > "$COMPLETIONS_DIR/mise.fish"
# delta --generate-completion fish > "$COMPLETIONS_DIR/delta.fish"
# rustup completions fish > "$COMPLETIONS_DIR/rustup.fish"