#!/usr/bin/env bash

usage() {
  cat <<EOF
usage: todos [options]
 	-h : show this.
EOF
}

declare -r __GREEN="\033[32m"

declare -r __DIR="$(dirname "${BASH_SOURCE[0]}")"

declare -r __FILE="$__DIR/.todos"
# Init.
if [ ! -f "$__FILE" ] ; then
	touch "$__DIR/.todos"
	echo -e "${__GREEN} File initialized: $__FILE${__DEFAULT}"
fi

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

		-o | --o | --open)
			open $__FILE
			exit 0
		;;

	esac
done
