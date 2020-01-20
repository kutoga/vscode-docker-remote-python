# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    wd
    zsh-autosuggestions
    alias-tips
    forgit
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

bindkey "^\n" autosuggest-execute


# Welcome message
#toilet -f bigmono9 " Welcome $(whoami) " -F metal -F border -w 300
echo "Welcome $(whoami)"


# Autpjump with fzf
unsetopt BG_NICE
[[ -s ${HOME}/.autojump/etc/profile.d/autojump.sh ]] && source ${HOME}/.autojump/etc/profile.d/autojump.sh
j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sed '/_____/Q; s/^[0-9,.:]*\s*//' |  fzf --height 40% --reverse --inline-info)"
}

# Add an alias that helps to find an alias
alias a="alias | grep"


# Kubernetes aliases
alias k=kubectl
alias kgp="kubectl get po"
alias kgpy="kubectl get po -oyaml"
alias kgd="kubectl get deploy"
alias kgdy="kubectl get deploy -oyaml"
alias kgs="kubectl get secret"
alias kgsy="kubectl get secret -oyaml"
alias kgc="kubectl get cm"
alias kgcy="kubectl get cm -oyaml"
alias kwp="watch -n0.1 -d kubectl get po"
alias kgctx="kubectl config current-context"
alias kgctxs="kubectl config get-contexts"
alias ksctx="kubectl config use-context"
alias kdp="kubectl describe po"
alias kdd="kubectl describe deploy"
alias kx="kubectl exec -it"
alias kl="kubectl logs -f"
alias kl100="kubectl logs -f --tail=100"
alias klp="kubectl logs -f --previous=true"
alias ka="kubectl apply -f"
alias kpn="kubectl get po | tail -n+2 | awk '{print\$1}' | grep"
alias kdeld="kubectl delete deploy"
alias ksd="kubectl scale deployment --replicas"
alias kpf="kubectl port-forward"

alias kgsd="kgd | tail -n +2 | awk '{print\"ksd \"\$2\" \"\$1}'"

alias kcp="kgp | tail +2 | awk '{print\$1}' | fzf"
alias kcd="kgd | tail +2 | awk '{print\$1}' | fzf"

function kcctx() (
    set -e
    local context="$(kgctxs --no-headers | tr '*' ' ' | awk '{print$1}' | fzf)"
    kubectl config use-context $context
)

function kcl() (
    set -e
    local flags="$1"
    local pod="$(kcp)"
    local svc="$(kgp $pod -o jsonpath='{.spec.containers[*].name}' | tr " " "\n" | fzf)"
    kubectl logs -f $pod $svc $flags
)

alias kcl100="kcl --tail=100"

if which kubectl > /dev/null; then
    source <(kubectl completion zsh)
fi


# Docker aliases
alias dri="docker run -it --rm"
alias drie="dri --entrypoint"
alias db="docker build"
alias dbt="docker build -t"

# Misc functions:

# Make a dir and directly change into it
function mkcd {
    target_dir=$1
    mkdir -p $target_dir && cd $target_dir
}

# Add functions to create some "special prompts":
function prompt_without_git {
    PROMPT='${ret_status} %{$fg[cyan]%}%~%{$reset_color%} '
}

function prompt_with_kubecontext {
    PROMPT='${ret_status} %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)$fg[blue]kubectl:($reset_color$fg[red]$(kubectl config current-context)$reset_color$fg[blue])$reset_color '
}

# Make a new 2-digit dir (beginning with 01) and cd into it; if not possible, do nothing
function mkcdn2 {
    d=$(
        for d in $(seq -f '%02g' 1 99); do
            if [ ! -d "$d" ]; then
                echo "$d"
                break
            fi
        done
    )
    if [ ! -z "$d" ]; then
        mkcd "$d"
    fi
}

# Watch a command output (with some default options)
function W {
    watch -n0.1 -d -c "$@"
}

# Load machine-specifc commands
if [ -d ~/.zshrc_custom ]; then
    for f in $(find ~/.zshrc_custom/ -type f | sort); do
        source $f
    done
fi

# Use vim as default editor (e.g. for git commands)
export EDITOR=vim
export VISUAL=vim

