#!/usr/bin/env bash

# Init.
if [ ! -d "./.todos/" ] ; then
	mkdir "$__DIR/.todos"
	echo -e "${__GREEN} Directory initialized: $__FILE${__DEFAULT}"
fi

usage() {
  cat <<EOF
usage: todos [options]
 	-h : show this.
EOF
}

if [[ $# = 0 ]]; then
	usage
	exit 0
fi

declare -r __GREEN="\033[32m"
declare -r __DIR="$(dirname "${BASH_SOURCE[0]}")"
declare -r __FILE="$__DIR/.todos"

# Main.
for option in "$@"; do
	case $option in

		-h | --h | --help)
			usage
			exit 0
		;;

		-o | --o | --open)
			open $__FILE
			exit 0
		;;

	esac
done
