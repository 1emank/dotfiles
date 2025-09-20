#
# ~/.bashrc
#
# vi: ft=sh
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Prompt
use_color() {
        # shellcheck disable=SC2154
        case "$TERM:$color_prompt" in
        *:false) return 1 ;;
        xterm-color:* | *-256color:* | alacritty:* | foot:* )
                if tput setaf sgr0 >/dev/null 2>&1
                then return 0
                else return 1
                fi ;;
        *) return 1 ;;
        esac
}
use_color && {
        SUCCESS=$'\[\E[92m\]'   #\[$(tput setaf 10)\]
        TITLE=$'\[\E[94m\]'     #\[$(tput setaf 12)\]
        ERROR=$'\[\E[91m\]'     #\[$(tput setaf 9)\]
        WARNING=$'\[\E[93m\]'   #\[$(tput setaf 11)\]
        RESET=$'\[\E(B\E[m\]'   #\[$(tput sgr0)\]
}
__PROMPT_COMMAND() {
        __errno=$?
        # __char_alias_return is a workaround for the prompt. $? is still 127
        [ -n "$__char_alias_return" ] && __errno="$__char_alias_return"
        [ "$__errno" = 0 ] && __errno=
        if __branch="$(git branch --show-current 2>/dev/null)"; then
                __status="$(git status -s 2>/dev/null | wc -l)"
                [ "$__status" = 0 ] && __status=
                return 0
        else
                __status=
                return 0
        fi
}
PROMPT_COMMAND=__PROMPT_COMMAND

case "$HOME" in
*termux*) #[USER@HOSTNAME:PWD], [PWD] in termux
        PS1="[${TITLE}\w${RESET}]" ;;
*)
        PS1="[${SUCCESS}\u@\h${RESET}:${TITLE}\w${RESET}]" ;;
esac

PS1+=`  #[git branch<status>] #if they exist
        `'${__branch:+'`
                `'['"${SUCCESS}"'$__branch${__status:+'`
                        `"$WARNING"'<'"$RESET"'$__status'"$WARNING"'>}'`
                `"${RESET}"']'`
        `'}'`

        #[$?] if different than 0
        `'${__errno:+'"$ERROR"'['"$RESET"'$__errno'"$ERROR"']}'"$RESET"`

        # '$' if normal user, '#' if root
        `"$({ [ "$(id -ru)" = 0 ] && echo '# '; } || echo '$ ')"

## RC
exists() { command -v "$1" >/dev/null 2>&1; }
script_is_old() {
        local program="$1"
        [ ! -f "${SHELLCONFIGDIR}/$program" ] && return 0

        local now modified age one_week
        now="$( date '+%s' )"
        modified="$( stat -c '%Y' "${SHELLCONFIGDIR}/$program" 2>/dev/null )"
        age="$(( "$now" - "$modified" ))"
        one_week="$(( 7 *24 *60 *60 ))"

        if [ "$age" -gt "$one_week" ]
        then return 0
        else return 1
        fi
}
update_script(){
        local comm="$1"
        if [ -n "$comm" ] && exists "$comm" && script_is_old "$comm"; then
                launch -q "$@" ||
                        printf 'Error writing the "%s" script' "$comm" 1>&2
        fi
}

CONFIG="${XDG_CONFIG_HOME:-${HOME}/.config}"
SHELLCONFIGDIR="${CONFIG}/term"
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth
HISTIGNORE=ls:pwd:clear:reload:reset

[ -d "$SHELLCONFIGDIR" ] || mkdir -p "$SHELLCONFIGDIR"

update_script fzf --bash
for file in "$SHELLCONFIGDIR"/*; do
        # shellcheck disable=SC1090
        source "$file"
done

## Utilities
### Shell
__char_alias=
char_alias() {
        if [ "${1:1:1}" != '=' ]; then
                echo 'The alias name must be a single letter'
                return 1
        fi

        local char="${1:0:1}"
        local meaning="${1:2}"

        if eval "${char}(){"$'\n'"$meaning \$@"$'\n'"}"
        then __char_alias+="${char}"
        else return
        fi
}
command_not_found_handle() {
        local comm="$1"
        local char="${comm:0:1}"
        if [ -z "${comm//${char}/}" ] && [[ $__char_alias == *"$char"* ]]; then
                return 127
        else
                bash -c "$@"
                cnf_handle_distro "$comm"
                return 127
        fi
}
__cnf_handle_distro() {
        exists pacman && pkgfile "$1" && return
        #TODO: additional package managers
        true
}
__char_alias_runner() {
        # shellcheck disable=SC2086
        set -- ${__last_cmd:-ab}    # no special meaning, just two different
        local comm="$1"             # chars so the test down below fails
        local char="${comm:0:1}"
        local len="${#comm}"
        shift
        if [ -z "${comm//${char}/}" ] && [[ $__char_alias == *"$char"* ]]; then
                if [ -n "$1" ]; then
                        for ((i=0; i<len; i++)); do
                                $char "$@"
                        done
                else
                        for ((i=0; i<len; i++)); do
                                $char
                        done
                fi
        fi
        __char_alias_return=$?
}
trap '[ $? = 127 ] && __char_alias_runner; __last_cmd="$BASH_COMMAND"' DEBUG

reload() { welcome=false exec "${SHELL:-/bin/bash}"; }
reset() { [ -n "$TMUX" ] && tmux clear-history; command reset; }
### Movement
# shellcheck disable=SC2016
char_alias x='pushd ..'
# shellcheck disable=SC2016
char_alias z='popd'
char_alias t='echo'
alias c='pushd'
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
### Other
alias grep='grep --color=auto'
notes() {
        [ -z "$NOTES_DIR" ] && local NOTES_DIR="${HOME}/repos/notes"
        [ -d "$NOTES_DIR" ] || return 1

        case "$(pwd)" in
        "$NOTES_DIR"*)
                git add . &&
                        git commit -m "$(git diff --cached --name-status)" &&
                        git push origin main

                if [ -n "$__notes_uncd" ]; then
                        cd "$__notes_uncd" || return 1
                        unset __notes_uncd
                fi
                ;;
        *)
                __notes_uncd="$(pwd)"
                cd "$NOTES_DIR" || return 1
                git pull origin main
                ;;
        esac
}
upa_distro() {
        local SUDO="$1"
        if exists pacman; then
                $SUDO pacman -Syu --noconfirm
                exists paru && paru -Syu --noconfirm && return
                exists yay && yay -Syu --noconfirm && return 
                return 0
        fi
        if exists pkg; then
                $SUDO pkg upgrade -y && exists apt &&
                        $SUDO apt autoremove --purge -y
                return 0
        fi
        if exists apt; then
                $SUDO apt full-upgrade -y && $SUDO apt autoremove --purge -y
                return 0
        fi
}
update_all() {
        local SUDO root
        if [ "$EUID" -eq 0 ]
        then root=true
        else root=false
        fi
        exists sudo && ! $root && SUDO=sudo

        upa_distro $SUDO
        nvim --headless '+Lazy! sync' +qa
        exists npm && {
                npm -g update
                [ -n "$SUDO" ] && $SUDO npm -g update
        }
        exists rustup && ! $root && rustup update
        true
}
alias upa=update_all
alias nv=nvim
alias nman='MANPAGER="nvim +Man!" man'
alias work='launch -q brave --user-data-dir="${HOME}/.local/work"'
alias luaf='stylua --config-path ~/.config/stylua.toml'
tmux() {
        if [ -n "$1" ]
        then command tmux "$@"
        else command tmux attach 2>/dev/null || command tmux
        fi
}
theme() {
        local check=false
        local silent=false
        local chosen_theme
        while [ $# -gt 0 ]; do case "$1" in
            --check) check=true; shift;;
            --silent) silent=true; shift;;
            *) chosen_theme="$1"; shift;;
        esac done

        local prefix="${CONFIG}/alacritty"
        if cmp --silent "${prefix}/dark_mode.toml" "${prefix}/alacritty.toml"
        then THEME=dark
        else THEME=light
        fi

        if $check; then
            $silent || echo "$THEME"
            return 0
        fi

        case "${THEME}:${chosen_theme}" in
        *:light|dark:)
                THEME=light
                cp "${prefix}/light_mode.toml" "${prefix}/alacritty.toml"
                ;;
        *:dark|light:)
                THEME=dark
                cp "${prefix}/dark_mode.toml" "${prefix}/alacritty.toml"
                ;;
        *) return 1 ;;
        esac
}
launch() {
        case "$1" in
        -q) shift; { ( launch "$@" & ) } >/dev/null 2>&1; return;;
        '') return 1;;
        *) nohup "$@" >/dev/null 2>&1 & return;;
        esac
}

## Opts
shopt -s histappend
shopt -s checkwinsize
shopt -s nullglob
bind 'set completion-ignore-case on'

theme --check --silent
export THEME

if [ -z "${TMUX}${NVIM}" ]; then
        [ -n "$DISPLAY" ] && [ "$(tput cols 2>/dev/null)" -lt 100 ] &&
                xdotool key alt+F10

        if exists fastfetch && ${welcome:-true} && $color_prompt; then
                fastfetch
        else
                fastfetch --pipe
        fi
fi

unset SUCCESS TITLE ERROR WARNING RESET color_prompt use_color welcome \
    update_script check_script
