#
# ~/.bash_profile
#
# vi: ft=sh
#

add_to_path() {
        [ -d "$1" ] || return 1
        local directory="$1"

        case ":${PATH}:" in
        *":${directory}:"*) ;;
        *) PATH="${PATH}:${directory}" ;;
        esac
}

# shellcheck disable=SC2155
command -v manpath >/dev/null &&
    export MANPATH="$(manpath -g):${HOME}/.local/share/man"

export EDITOR=nvim
export PAGER=less
export BROWSER=brave

add_to_path "${HOME}/.local/bin"
add_to_path "${HOME}/node_modules/.bin"

[ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
