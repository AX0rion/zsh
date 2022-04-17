#-----------------------------------------------#
# File:     .zshrc   ZSH resource file          #
# Purpose:  config file for zsh                 #
# Author:   Jean-Guillaume B.                   #
# Date:     Saturday, April 16th 2022           #
#-----------------------------------------------#

#------------------------------
# VARIABLES
#------------------------------
export ZSH="$HOME/.zsh"
export ZSH_CACHE_DIR="$ZSH/cache"
export ZSH_CUSTOM="$ZSH/custom"
export ZSH_PLUGINS="$ZSH/plugins"
export ZSH_THEMES="$ZSH/themes"

#------------------------------
# PLUGINS & THEMES
#------------------------------
# Plugins
plugins=()

# Themes
theme="robbyrussell"

#------------------------------
# OPTIONS
#------------------------------
# Changing Directories
# 
setopt auto_cd              # Change directory given just path.
setopt auto_pushd           # Maintain directories in a heap.
setopt pushd_ignore_dups    # Remove duplicates from directory heap.

# Completion
setopt complete_in_word     # If unset, the cursor is set to the end of the word if completion is started.
setopt hash_list_all        # Avoid false reports of spelling errors.
setopt menu_complete        # Insert the first match immediately, then insert the second match, etc.

# Expansion and Globbing
setopt extended_glob        # Use additional pattern matching features.
setopt no_glob_dots         # Do not require a leading ‘.’ in a filename to be matched explicitly.
setopt unset                # Treat undefined parameters as if they were empty when substituted, and as if they were null when reading their values.

# History
setopt append_history       # Zsh sessions will append their history list to the history file, rather than replace it.
setopt extended_history     # Record the start time stamp of each order and its duration in the history file.
setopt hist_ignore_space    # Remove command lines from the history list when the first character of the line is a space.

# Input / Output
setopt correct              # Try to correct the spelling of commands.

# Job Control
setopt long_list_jobs       # Display PID when using jobs.
setopt notify               # Immediately report changes in background job status.

# Others options
setopt no_beep              # Never beep.

#------------------------------
# FUNCTIONS
#------------------------------
# Name: is_plugin()
# Description: 
is_plugin() {
  local base_dir=$1
  local name=$2
  builtin test -f $base_dir/plugins/$name/$name.plugin.zsh \
    || builtin test -f $base_dir/plugins/$name/_$name
}

# Name: is_theme()
# Description: 
is_theme() {
  local base_dir=$1
  local name=$2
  builtin test -f $base_dir/$name.zsh-theme
}

#------------------------------
# CONFIGURATIONS
#------------------------------
# Add function path
fpath=("$ZSH/functions" "$ZSH/completions" $fpath)

# Cache and completions directory
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# Config files in $ZSH/lib/*.zsh
for config_file ("$ZSH"/lib/*.zsh); do
  source "$config_file"
done
unset config_file

# Construct zcompdump OMZ metadata
zcompdump_revision="#omz revision: $(builtin cd -q "$ZSH"; git rev-parse HEAD 2>/dev/null)"
zcompdump_fpath="#omz fpath: $fpath"

# Completion system
autoload -Uz compinit
compinit

# Colors
BLUE=$'%{\e[1;34m%}'
RED=$'%{\e[1;31m%}'
GREEN=$'%{\e[1;32m%}'
CYAN=$'%{\e[1;36m%}'
WHITE=$'%{\e[1;37m%}'
MAGENTA=$'%{\e[1;35m%}'
YELLOW=$'%{\e[1;33m%}'
NO_COLOR=$'%{\e[0m%}'

# Delete the zcompdump file if OMZ zcompdump metadata changed
if ! command grep -q -Fx "$zcompdump_revision" "$ZSH_COMPDUMP" 2>/dev/null \
   || ! command grep -q -Fx "$zcompdump_fpath" "$ZSH_COMPDUMP" 2>/dev/null; then
  command rm -f "$ZSH_COMPDUMP"
  zcompdump_refresh=1
fi

if [[ "$ZSH_DISABLE_COMPFIX" != true ]]; then
  source "$ZSH/lib/compfix.zsh"
  # If completion insecurities exist, warn the user
  handle_completion_insecurities
  # Load only from secure directories
  compinit -i -C -d "$ZSH_COMPDUMP"
else
  # If the user wants it, load from all found directories
  compinit -u -C -d "$ZSH_COMPDUMP"
fi

# Append zcompdump metadata if missing
if (( $zcompdump_refresh )); then
  # Use `tee` in case the $ZSH_COMPDUMP filename is invalid, to silence the error
  # See https://github.com/ohmyzsh/ohmyzsh/commit/dd1a7269#commitcomment-39003489
  tee -a "$ZSH_COMPDUMP" &>/dev/null <<EOF

$zcompdump_revision
$zcompdump_fpath
EOF
fi
unset zcompdump_revision zcompdump_fpath zcompdump_refresh

# Plugins
# Define plugins in fpath
for plugin ($plugins); do
  if is_plugin "$ZSH" "$plugin"; then
    fpath=("$ZSH_PLUGINGS/$plugin" $fpath)
  else
    echo "ZSH plugin '$plugin' not found in $ZSH_PLUGINS directory"
  fi
done

# Load plugins defined in ~/.zshrc
for plugin ($plugins); do
  if [[ -f "$ZSH_PLUGINS/$plugin/$plugin.plugin.zsh" ]]; then
    source "$ZSH_PLUGINS/$plugin/$plugin.plugin.zsh"
  fi
done
unset plugin

# Stock functions (from $fpath files)
autoload -U compaudit compinit

# Themes
if [[ -n "$theme" ]]; then
  if is_theme "$ZSH_THEMES" "$theme"; then
    source "$ZSH_THEMES/$theme.zsh-theme"
  else
    echo "ZSH theme '$theme' not found in $ZSH_THEMES directory"
  fi
fi

#------------------------------
# USER SETTINGS
#------------------------------
# ALIASES
alias la='ls --color=auto -la'
alias ll='ls --color=auto -l'
alias ls='ls --color=auto'

#HOMEBREW
export PATH=$PATH:/opt/homebrew/bin

# PROMPT
#PROMPT="${BLUE}%n${NO_COLOR}@%m %# "

