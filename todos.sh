#!/usr/bin/env bash

declare -r __DIR="$(dirname "${BASH_SOURCE[0]}")"
declare -r __ITERATOR="$__DIR/.iterator"

declare -r __DATA="$__DIR/.todos"
declare -r __DONE="$__DIR/.done"

# Init.
if [ ! -d "$HOME/dev/todos/.todos" ] ; then
	echo -e "Directory initialized: $__DATA/.todos"
	mkdir "$__DIR/.todos"
fi

if [ ! -d "$HOME/dev/todos/.done" ] ; then
	echo -e "Directory initialized: $__DIR/.done"
	mkdir "$__DONE"
fi

usage() {
  cat <<EOF
usage: todos [options]
 	-h : show this
	-o [idx] : natively open todos dir
	-n : create a new todo
	-l : list todos
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

iterate() {
	# Read from file.
	# if we don't have a file, start at zero
	if [ ! -f "$__ITERATOR" ] ; then
		i=0
	# otherwise read the value from the file
	else
		i=$(cat $__ITERATOR)
	fi
	i=`expr $i + 1`

	echo "${i}" > $__ITERATOR
}

# @param $1 : name of file
new_todo() {
	# make_title defined in util.
	__TITLE=$(make_title $@)

	validate_title $__TITLE || {
		echo bad
		exit 1;
	}

	iterate # imperatively update iterator.
	__TITLE=$(cat $__ITERATOR)'-'$__TITLE

	echo $(date +%F) > "$__DATA/$__TITLE"
	(touch "$__DATA/$__TITLE" && cat) >> "$__DATA/$__TITLE"
}

list_todos() {
	for file in $(ls $__DATA); do
		echo $file
	done
}

open_todos() {
	shift
	for file in $(ls $__DATA); do
		index=$(echo $file | cut -d'-' -f1)
		if [ $@ -eq $index ] ; then
			cat "$__DATA/$file"
		fi
	done
}

delete_todo() {
	shift
	for f in $(ls $__DATA); do
		index=$(echo $f | cut -d'-' -f1)
		if [ $@ -eq $index ] ; then
			echo "$f marked done."
			mv "$__DATA/$f" "$__DONE/$f"
		fi
	done
}

# Main.
for option in "$@"; do
	case $option in

		-h | --H | --help)
			usage
		;;

		-o | --O | --open)
			open_todos "$@"
		;;

		-n | --N | --new)
			new_todo "$@"
		;;

		-l | --L | --list)
			list_todos
		;;

		-d | --D | --done)
			delete_todo "$@"
		;;
	esac
done
