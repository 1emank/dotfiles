#
# ~/.bashrc
#
# vi: ft=sh
#

# If not running interactively, don't do anything
case $- in *i*) ;;
*) return ;;
esac

## Prompt
use_color() {
        # shellcheck disable=SC2154
        case "$TERM:$color_prompt" in *:false) return 1 ;;
        xterm-color:* | *-256color:* | alacritty:* | foot:* )
                { tput setaf sgr0 >/dev/null 2>&1 && return 0; } ||
                        return 1 ;;
        *) return 1 ;;
        esac
}
use_color && {
        SUCCESS="\[$(tput setaf 10)\]"
        TITLE="\[$(tput setaf 12)\]"
        ERROR="\[$(tput setaf 9)\]"
        WARNING="\[$(tput setaf 11)\]"
        RESET="\[$(tput sgr0)\]"
}
__PROMPT_COMMAND() {
        __errno=$?; [ $__errno = 0 ] && __errno=
        __branch="$(git branch --show-current 2>/dev/null)" && {
                __status="$(git status -s 2>/dev/null | wc -l)"
                [ "$__status" = 0 ] && __status=
                return
        }
        __status=
}
PROMPT_COMMAND=__PROMPT_COMMAND

case "$HOME" in *termux*) #[USER@HOSTNAME:PWD], [PWD] in termux
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
check_script() {
        local program="$1"
        [ ! -f "${SHELLCONFIGDIR}/$program" ] && return

        local now modified age one_week
        now="$( date '+%s' )"
        modified="$( stat -c '%Y' "${SHELLCONFIGDIR}/$program" 2>/dev/null )"
        age="$(( "$now" - "$modified" ))"
        one_week="$(( 7 *24 *60 *60 ))"

        [ "$age" -gt "$one_week" ]  && return

        return 1
}
update_script(){
        local comm="$1"
        [ "$comm" ] && exists "$comm" && check_script "$comm" && ( {
                nohup "$@" > "${SHELLCONFIGDIR}/$comm" 2>/dev/null ||
                        printf 'Error writing the "%s" script' "$comm" 1>&2
        } & )
}

SHELLCONFIGDIR="${XDG_CONFIG_HOME:-"${HOME}/.config"}/term"
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth
HISTIGNORE=ls:pwd:clear:reload:reset

[ -d "$SHELLCONFIGDIR" ] || mkdir -p "$SHELLCONFIGDIR"

update_script fzf --bash
for file in "$SHELLCONFIGDIR"/*; do
        # shellcheck disable=SC1090
        . "$file"
done

## Utilities
### Shell
__repeat_alias=
char_alias() {
        if [ "$2" ]; then
                local char="$1"
                local meaning="$2"
        elif [[ "$1" =~ ^(.)+=(.)+ ]]; then
                IFS='=' read -r char meaning <<< "$1"
        fi

        [ ${#char} != 1 ] &&
                echo 'The alias name must be a single letter' &&
                return 1

        # shellcheck disable=SC2139
        alias "$char"="$meaning" && __repeat_alias+="${char}"
}
command_not_found_handle() {
        local comm="$1"
        local char=${comm:0:1}
        local len=${#comm}

        # If removing all the ocurrences of the first character we have no
        # characters left, we can have a valid char_alias
        [ -z "${comm//${char}/}" ] &&
                [[ $__repeat_alias =~ ^(.)*${char}(.)* ]] && {
                shift
                for (( j=0; j<len; j++ )); do
                        $char "$@"
                done
                return
        }

        bash -c "$@"
        cnf_handle_distro "$comm"

        return 127
}
cnf_handle_distro() {
        exists pacman && pkgfile "$1"
        #TODO: additional package managers
        true
}
reload() { welcome=false exec "${SHELL:-/bin/bash}"; }
reset() { [ "$TMUX" ] && tmux clear-history; command reset; }
#loop() {}
launch() {
    [ "$1" = '-q' ] && shift && ( launch "$@" )
    [ -z "$1" ] && echo 'No program to launch' 1>&2 && return 255
    [ "$1" ] && nohup "$@" >/dev/null 2>&1 &
}
### Movement
char_alias x='pushd .. >/dev/null'
char_alias z='popd >/dev/null'
char_alias c='pushd >/dev/null'
char_alias t='echo test'
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
### Other
alias grep='grep --color=auto'
rmr() { rm -r "$@" && echo "Done!"; }
# shellcheck disable=SC2164
notes() {
        [ -z "$NOTES_DIR" ] && local NOTES_DIR="${HOME}/repos/notes"
        [ -d "$NOTES_DIR" ] || return 1

        case "$(pwd)" in "$NOTES_DIR"*)
                git add .
                git commit -m "$(git diff --cached --name-status)"
                git push origin main

                [ "$__notes_uncd" ] && {
                        cd "$__notes_uncd"
                        unset __notes_uncd
                }
                ;;
        *)
                __notes_uncd="$(pwd)"
                cd "$NOTES_DIR"
                git pull origin main
                ;;
        esac
}
upa_distro() {
        local SUDO="$1"

        exists pacman && {
                $SUDO pacman -Syu --noconfirm
                exists paru && paru -Syu --noconfirm && return
                exists yay && yay -Syu --noconfirm && return 
                return 0
        }
        exists pkg && {
                $SUDO pkg upgrade -y && exists apt &&
                        $SUDO apt autoremove --purge
                return 0
        }
        exists apt && {
                $SUDO apt full-upgrade -y && $SUDO apt autoremove --purge
                return 0
        }
}
update_all() {
        local SUDO=
        local root
        root="$({ [ "$EUID" -eq 0 ] && echo true; } || echo false)"
        exists sudo && ! $root && SUDO=sudo

        upa_distro $SUDO
        exists rustup && ! $root && rustup update
        nvim --headless "+Lazy! sync" +qa
        exists npm && {
                npm update
                [ $SUDO ] && $SUDO npm -g update
        }
        true
}
alias upa=update_all
alias nv=nvim
alias nman='MANPAGER="nvim +Man!" man'
alias work='launch -q brave --user-data-dir="${HOME}/.local/work"'
alias luafmt='stylua --config-path ~/.config/stylua.toml'
tmux() {
        if [ "$1" ] || [ "$TMUX" ]; then
                command tmux "$@"
        else
                command tmux attach 2>/dev/null ||
                        command tmux
        fi
}

## Opts
shopt -s histappend
shopt -s checkwinsize
shopt -s nullglob
bind 'set completion-ignore-case on'

[ "$DISPLAY" ] && [ "$(tput cols 2>/dev/null)" -lt 100 ] &&
        xdotool key alt+F10

[ -z "${TMUX}${NVIM}" ] && exists fastfetch && ${welcome:-true} && {
        { $color_prompt && fastfetch; } || fastfetch --pipe
}

unset SUCCESS TITLE ERROR WARNING RESET color_prompt use_color welcome \
        update_script check_script
