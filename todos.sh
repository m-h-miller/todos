#!/usr/bin/env bash

usage() {
	cat <<EOF
  cat <<EOF
usage: todos [-h]
EOF
}

Usage: todos -l	: list todos.
       todos -h : show this.
       todos -o : open todos in editor.
       todos -n : add a new todo.

EOF
}


if [[ $# = 0 ]]; then
	usage
fi

# Main.
for option in "$@"; do
	case $option in

		-h | --h | --help)
			usage
			exit 0
		;;

	esac
done
