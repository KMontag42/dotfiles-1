# ZSH Theme emulating the Fish shell's default prompt.

_fishy_collapsed_wd() {
  echo $(pwd | perl -pe '
   BEGIN {
      binmode STDIN,  ":encoding(UTF-8)";
      binmode STDOUT, ":encoding(UTF-8)";
   }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
')
}

user_prompt() {
  # Context: user@hostname (who am I and where am I)
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    echo "%(!.%{%F{yellow}%}.)$USER@%m "
  fi
}

rvm_prompt() {
  echo "%{$fg_bold[blue]%}rvm:(%{$fg[green]%}$(~/.rvm/bin/rvm-prompt s i v g)%{$fg_bold[blue]%})%{$reset_color%} "
}

nvm_prompt() {
  echo "%{$fg_bold[blue]%}nvm:(%{$fg[green]%}$(nvm current)%{$fg_bold[blue]%})%{$reset_color%} "
}

manager_prompts() {
  if [[ -z "$HIDE_MANAGER_INFO" ]]; then
     echo "$(rvm_prompt)$(nvm_prompt)"
  fi
}

local user_color='green'; [ $UID -eq 0 ] && user_color='red'
PROMPT='%{$fg[$user_color]%}$(manager_prompts)$(_fishy_collapsed_wd)%{$reset_color%}%(!.#.>) '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

local return_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
RPROMPT='${return_status}$(git_prompt_info)$(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"
