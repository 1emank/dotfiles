#
# ~/.bash_profile
#
# vi: ft=sh
#

add_to_path() {
        [ -d "$1" ] || return
        local directory="$1"

        case ":${PATH}:" in
        *":${directory}:"*) ;;
        *) PATH="${PATH}:${directory}" ;;
        esac
}

# shellcheck disable=SC2155
command -v manpath >/dev/null 2>&1 &&
    export MANPATH="$(manpath -g):${HOME}/.local/share/man"

case "$HOME" in
*termux*) TERMUX=true ;;
*) TERMUX=false ;;
esac

export EDITOR=nvim
export PAGER=less
export BROWSER=brave

add_to_path "${HOME}/.local/bin"
add_to_path "${HOME}/node_modules/.bin"
add_to_path "${HOME}/.cargo/bin"

[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"

$TERMUX && fastfetch
