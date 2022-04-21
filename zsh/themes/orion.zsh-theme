# AX0rion
#PROMPT='%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$fg_bold[white]%}%m :: %{$fg[blue]%}%c %{$fg[white]%}$B»%b%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} %{$fg[white]%}$B»%b% %{$reset_color%}'

# Git
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[blue]%}git(%{$fg_no_bold[red]%}";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} ";
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_no_bold[blue]%})";
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_no_bold[blue]%})";

#------------------------------
# FUNCTIONS
#------------------------------
# Arrow
function arrow_start() {
    local arrow="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"
    local color_reset="%{$reset_color%}";
    echo "${arrow}${color_reset}";
}

function arrow_end() {
    local arrow="%{$fg_bold[red]%}❱%{$fg_bold[yellow]%}❱%{$fg_bold[green]%}❱";
    local color_reset="%{$reset_color%}";
    echo "${arrow}${color_reset}";
}


# Directory
function directory() {
    local color="%{$fg_bold[blue]%}";
    local directory="${PWD/#$HOME/~}";
    local color_reset="%{$reset_color%}";
    echo "${color}${directory}${color_reset}";
}

# Git
function git_status() {
    GIT_STATUS=$(git_prompt_info);
    echo "${GIT_STATUS}"
}

# Hostname
function hostname() {
    local hostname="%{$fg_bold[white]%}%m ::"
    local color_reset="%{$reset_color%}";
    echo "${hostname}${color_reset}";
}

# User
function user() {
    local color="%{$fg_bold[white]%}";
    local user="%n";
    local color_reset="%{$reset_color%}";
    echo "${color}${user}${color_reset}";
}


# PROMPT
PROMPT='$(arrow_start) $(hostname) $(directory) $(git_status)$(arrow_end) ';