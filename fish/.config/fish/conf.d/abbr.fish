# Abbreviations — expand inline so you always see the real command

status is-interactive; or exit

# Editor / files
abbr -a v nvim
abbr -a vi nvim
abbr -a ls 'eza --icons --group-directories-first'
abbr -a ll 'eza -l --icons --group-directories-first --git'
abbr -a la 'eza -la --icons --group-directories-first --git'
abbr -a lt 'eza --tree --level=2 --icons'
abbr -a cat bat

# Git
abbr -a g git
abbr -a gs 'git status -sb'
abbr -a ga 'git add'
abbr -a gaa 'git add -A'
abbr -a gc 'git commit'
abbr -a gcm 'git commit -m'
abbr -a gco 'git checkout'
abbr -a gd 'git diff'
abbr -a gds 'git diff --staged'
abbr -a gl 'git log --oneline --graph --decorate -20'
abbr -a gp 'git push'
abbr -a gpl 'git pull'
abbr -a lg lazygit

# Agentic
abbr -a cl claude
abbr -a clc 'claude --continue'

# Navigation / tools
abbr -a ".." 'cd ..'
abbr -a "..." 'cd ../..'
abbr -a c clear
abbr -a top btop
