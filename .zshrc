# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/zhud/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Powerlevel10k (zsh-theme-powerlevel10k from AUR)
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Scratchpad terminal (i3 dropdown): transient + two-line prompt at bottom
if [[ -n ${DROPDOWN_TERM:-} ]]; then
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir
    vcs
    newline
    prompt_char
  )
  (( $+functions[p10k] )) && p10k reload

  # Pin prompt to the bottom without scrolling command output away:
  # only pad from the current cursor row down to the last lines.
  autoload -Uz add-zsh-hook
  _dropdown_pin_bottom() {
    emulate -L zsh
    [[ -o interactive && -t 1 && -n $TTY ]] || return
    local _ _row _col
    print -rn -- $'\e[6n' >$TTY
    IFS='[;' read -r -s -d R -t 0.1 _ _row _col <$TTY || return
    [[ $_row == <-> ]] || return
    local -i pad=$(( LINES - _row - 2 ))
    (( pad > 0 )) && printf '\n%.0s' {1..$pad} >$TTY
  }
  add-zsh-hook precmd _dropdown_pin_bottom
fi
