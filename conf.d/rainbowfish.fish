# MARK: common
abbr --add .. 'cd ..'
abbr --add ... 'cd ../..'
abbr --add .... 'cd ../../..'
alias grep 'grep --color'
abbr --add pid "pgrep -lf"

# ls
if type -q eza
    alias ls='eza --group-directories-first'
else
    alias ls='ls --color'
end

alias lt='ls -lhF --time-style long-iso -s time'
alias ll='ls -lhF --time-style long-iso'
alias lg='ls -lbGahF --time-style long-iso'
alias lx='ls -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'
abbr --add lsa 'ls -a'

# vscode
if type -q code
    abbr --add zshrc 'code ~/.zshrc'
    abbr --add zshenv 'code ~/.zshenv'
end

# trash
if type -q trash
    abbr --add rm trash
end

# MARK: Bottom: cross-platform graphical process/system monitor
if type -q btm
    abbr --add btme btm -e --process_memory_as_value --process_command
end

# MARK: fd: program to find entries in your filesystem
if type -q fd
    abbr --add fdd 'fd --hidden --type d'
    abbr --add fdf 'fd --hidden --type f'
end

# MARK: Git

if type -q git
    # MARK: commit
    abbr --add gaa 'git add .'
    abbr --add gc 'git commit -m'
    abbr --add gca 'git commit -am'
    abbr --add gcam 'git commit --amend --no-edit'
    abbr --add gp 'git push'
    abbr --add gpl 'git pull'

    # MARK: clone
    abbr --add gcl 'git clone'
    abbr --add gcl1 'git clone --depth 1'

    # MARK: log
    abbr --add gl 'git log --oneline --cherry'
    abbr --add gll 'git log --graph --cherry --pretty=format:"%h <%an> %ar %s"'
    abbr --add gsl 'git shortlog'

    # MARK: tag
    abbr --add gtl 'git tag -l'
    abbr --add gtd 'git tag -d'

    # MARK: branch
    abbr --add gba 'git branch -a'
    abbr --add gbd 'git branch --delete'
    abbr --add gbrn 'git branch -m'
    abbr --add gs 'git switch'

    # MARK: other
    # current git repo's status in concisely
    abbr --add gst 'git status -s'

    abbr --add gcat 'git cat-file'
    abbr --add gcf 'git config -l'
    abbr --add gcln 'git clean -xdf'
    abbr --add gdf 'git difftool'
    abbr --add gho 'git hash-object'

    # soft reset current branch to last commit
    abbr --add gundo 'git reset --soft HEAD^'
end

if type -q hyperfine
    abbr --add hf hyperfine
    abbr --add hf5 "hf -r5 -w5"
end

if type -q just
    abbr --add j just
    abbr --add jc "just --choose"
end

if test (uname) = Darwin
    abbr --add showfiles "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    abbr --add hidefiles "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    abbr --add spotlightoff "sudo mdutil -a -i off"
    abbr --add spotlighton "sudo mdutil -a -i on"
end

# MARK: IP addresses
abbr --add public_ip "dig +short myip.opendns.com @resolver1.opendns.com"
abbr --add local_ip "ipconfig getifaddr en0"
abbr --add ips "ifconfig -a | grep -oE 'inet6? (addr:)?\s?((([0-9]+.){3}[0-9]+)|[a-fA-F0-9:]+)' | awk '{sub(/inet6? (addr:)? ?/, \"\"); print}'"

if type -q curl
    abbr --add status_code "curl --location --head --max-time 10 --output /dev/null --silent --write-out '%{http_code}'"
end

if type -q ni
    abbr --add nio "ni --prefer-offline"
    abbr --add nid "ni -D"
    abbr --add nido "ni -D --prefer-offline"
    abbr --add nidw "ni -wD"
    abbr --add niw "ni -w"
end

if type -q nr
    abbr --add d "nr dev"
    abbr --add s "nr start"
    abbr --add b "nr build"
    abbr --add c "nr clean"
    abbr --add l "nr lint"
    abbr --add t "nr test"
end

# MARK: Functions
function port --argument-names pt
    lsof -sTCP:LISTEN -iTCP:$pt
end