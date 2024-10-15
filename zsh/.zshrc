# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Only for my Mac
if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Zinit Plugin Manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Install NVM (Node 17 needed by COC)
[ ! -d ${HOME}/.nvm ] && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install Powerlevel10k theme
zinit ice depth=1; zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Other zsh plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Aliases
alias vim='nvim'
alias c='clear'
alias cd='z'
alias ls='exa --icons --color=always -a --group-directories-first'
alias ll='exa --icons --color=always -a --group-directories-first --long'
alias cat='bat --theme base16 -p'

# Fzf options to match everforest theme
export FZF_DEFAULT_OPTS='--color=fg:-1,fg+:#ffefcc,bg:-1,bg+:#232a2e,hl:#a7c980,hl+:#a7c980,info:#d3c6aa,marker:#83c092,prompt:#d699b6,spinner:#dbbc7f,pointer:#d699b6,header:#7fbbb3,border:#3d484d,label:#aeaeae,query:#d3c6aa --border-label-pos="0" --preview-window="border-rounded" --prompt="❯ " --marker="❯" --pointer="│" --separator="─" --scrollbar="│"'
zstyle ':fzf-tab:*' fzf-flags --color='fg:-1,fg+:#ffefcc,bg:-1,bg+:#232a2e,hl:#a7c980,hl+:#a7c980,info:#d3c6aa,marker:#83c092,prompt:#d699b6,spinner:#dbbc7f,pointer:#d699b6,header:#7fbbb3,border:#3d484d,label:#aeaeae,query:#d3c6aa' --border-label-pos="0" --preview-window="border-rounded" --prompt="❯ " --marker="❯" --pointer="│" --separator="─" --scrollbar="│" --bind=tab:accept

# Useful functions
function calc() {
	expression=$@
	python3 -c "from numpy import *; print($expression)"
}
