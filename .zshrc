HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=500000
ZCOMPDUMP_FILE="$HOME/.local/state/zsh/.zcompdump"
if [[ -f "$ZCOMPDUMP_FILE" && "$ZCOMPDUMP_FILE" -nt "$fpath[1]" ]]; then
    # Load the dump file if it's up-to-date
    autoload -Uz compinit && compinit -d "$ZCOMPDUMP_FILE"
    echo "loaded from cache"
else
    # Otherwise, generate a new dump file
    echo "Creating cache"
    autoload -Uz compinit && compinit -C -d "$ZCOMPDUMP_FILE"
fi
alias k=kubectl
alias go=/usr/local/go/bin/go
alias kinit=/usr/bin/kinit
alias klist=/usr/bin/klist
#alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias ls="ls --color"
HIST_STAMPS="mm/dd/yyyy"
export EDITOR=/usr/bin/nvim
export PATH="/home/bshephar/.local/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export GPG_TTY=$(tty)
bindkey -v
bindkey "^R" history-incremental-search-backward
bindkey -M viins "^A" beginning-of-line
bindkey -M vicmd "^A" beginning-of-line
bindkey -M viins "^E" end-of-line
bindkey -M vicmd "^E" end-of-line
bindkey -M viins "^D" delete-char-or-list
bindkey -M vicmd "^D" delete-char
bindkey -M viins "^F" backward-delete-char
bindkey -M vicmd "^F" backward-delete-char
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'e' edit-command-line
#eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"

#### Prompt Configuration ####
# Enable vcs_info
setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

# Check for local changes
zstyle ':vcs_info:git:*' check-for-changes true

# Use Nerd Font icons for local status
# 󱓎 = Unstaged/Modified, 󰐗 = Staged/Ready
zstyle ':vcs_info:git:*' unstagedstr ' %F{1}󱓎%f'
zstyle ':vcs_info:git:*' stagedstr ' %F{2}󰐗%f'

# Format: 󰊢 branch_name + local status
# 󰊢 is the standard Git branch icon
zstyle ':vcs_info:git:*' formats ' %F{242}󰊢 %b%f%u%c'
zstyle ':vcs_info:git:*' actionformats ' %F{242}󰊢 %b%f|%a%u%c'

# Refresh vcs_info before every prompt
precmd() { vcs_info }

# Function to check Remote Status (Ahead/Behind)
# 󰶣 = Ahead (Needs Push), 󰶡 = Behind (Needs Pull)
git_remote_status() {
  local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
  local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
  
  local status_output=""
  [[ $ahead -gt 0 ]] && status_output+=" %F{3}󰶣$ahead%f"
  [[ $behind -gt 0 ]] && status_output+=" %F{1}󰶡$behind%f"
  echo "$status_output"
}

# Final Prompt Construction
PROMPT='
%F{242}%n@%m%f %F{6}%~%f${vcs_info_msg_0_}$(git_remote_status)
%F{5}❯%f '
