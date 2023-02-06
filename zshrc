# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast sudo dirhistory last-working-dir common-aliases copyfile history-substring-search gh zsh-syntax-highlighting)

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Include custom aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.zsh-extras" ]] && source "$HOME/.zsh-extras"

export EDITOR='vim'

if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# Setup asdf
ASDF_DIR=${HOME}/.asdf
. ${ASDF_DIR}/asdf.sh

# Append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# Initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# Finds all remote branches on `origin` (besides main and master).
# Checks each one out, telling the local branch to track the remote one.
checkout_all()
{
    current_branch=$(git_current_branch);
    ignores=(origin/main origin/master origin/HEAD);
    remote=origin;

    git fetch $remote;

    for branch_name in $(git for-each-ref --format="%(refname:short)" refs/remotes/${remote}); do 
        if [[ ! " ${ignores[*]} " =~ " ${branch_name} " ]]; then
            git switch --track $branch_name;
        fi
    done
    git checkout $current_branch;
}

# Pulls all remote branches from `origin`.
pull_all()
{
    current_branch=$(git_current_branch);
    remote=origin;
    git fetch $remote;

    for branch_name in $(git for-each-ref --format="%(refname:short)" refs/heads); do 
        git checkout $branch_name;
        git pull $remote $(git_current_branch); 
    done
    git checkout $current_branch;
}

# check if an array contains a given value:
# https://stackoverflow.com/a/15394738

# iterate over branches/refs in a repo:
# https://stackoverflow.com/a/6300386

copy_fs_session()
{
    if [ "$#" -ne 1 ]; then
        echo "Usage: Call with only one argument: the name of the session"
        return 1
    fi

    SESSION_NAME=$1

    SESSION_DIR=${SYLLABUS_DIR}/sessions/${SESSION_NAME}
    echo Copying session from directory: ${SESSION_DIR}

    cp -r $SESSION_DIR ./sessions/
}

copy_fs_challenges()
{
    if [ "$#" -ne 1 ]; then
        echo "Usage: Call with only one argument: the name of the session"
        return 1
    fi

    SESSION_NAME=$1
    EXERCISES_DIR=${WEB_EXERCISES_DIR}/sessions/${SESSION_NAME}

    echo Copying challenges from directory: ${EXERCISES_DIR}
    cp -r $EXERCISES_DIR ./sessions/${SESSION_NAME}/challenges
}

copy_full_session()
{
    if [ "$#" -ne 1 ]; then
        echo "Usage: Call with only one argument: the name of the session"
        return 1
    fi

    copy_fs_session $1
    copy_fs_challenges $1
}