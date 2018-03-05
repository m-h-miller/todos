#!/usr/bin/env bash

declare -r __GREEN="\033[32m"
declare -r __DIR="$(dirname "${BASH_SOURCE[0]}")"
declare -r __DATA="$__DIR/.todos"

# Init.
if [ ! -d "./.todos/" ] ; then
	mkdir "$__DIR/.todos"
	echo -e "${__GREEN} Directory initialized: $__FILE${__DEFAULT}"
fi

usage() {
  cat <<EOF
usage: todos [options]
 	-h : show this.
	-o : natively open todos dir.
	-n : create a new todo
EOF
}

# Early exit.
if [[ $# = 0 ]]; then
	usage
	exit 0
fi

join_by() {
	local IFS="$1"
	shift
	echo "$*"
}

make_title() {
	echo $(date +%F)-$(shift; join_by - "$@")
}

validate_title() {
	# Alphanumeric incl. dashes, 61 char max.
	[[ "$@" =~ ^[a-zA-Z0-9][-a-zA-Z0-9]{0,61}[a-zA-Z0-9]$ ]]
}

# @param $1 : name of file
new_todo() {
	# make_title defined in util.
	__TITLE=$(make_title $@)

	validate_title $__TITLE || {
		echo bad
		exit 1;
	}

	(touch "$__DATA/$__TITLE" && cat) >> "$__DATA/$__TITLE"
}

# Main.
for option in "$@"; do
	case $option in

		-h | --h | --help)
			usage
			exit 0
		;;

		-o | --o | --open)
			open $__DATA
			exit 0
		;;

		-n | --new)
			new_todo "$@"
			exit 0
		;;
	esac
done
