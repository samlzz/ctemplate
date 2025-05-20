#* Alias part

alias cl="clear"
alias la="ls --all"
alias vl="valgrind"
alias vla="valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all --track-fds=yes"

alias ccw="gcc -Wall -Wextra -Werror"
alias mk="make"
alias py="python3"

alias sz="source $HOME/.zshrc"

#* Functions

exinit() {
	if [ -z "$1" ]; then
		echo "Error: No target dir provided."
		exit 1
	fi
	local target_dir="$1"
	local curr_dir="$PWD"

	while [[ "$curr_dir" != "/" ]]; do
		if [[ -d "$curr_dir/.exemple" ]]; then
			mkdir -p "$target_dir"
			cp -r "$curr_dir/.exemple/." "$target_dir/"
			echo "$target_dir was correctly init from $curr_dir"
			return
		fi
		curr_dir="$(dirname "$curr_dir")"
	done

	echo "Error: No $(.exemple) folder founded."
	exit 1
}

#? for get the prototype of a function in man
manproto() {
	if [ -z "$1" ]; then
		echo "Error: No function name provided."
		exit 1
	fi
	local result section
	result=$(man "$1" | grep "$1(" -A 1 | head -5)
	section=$(echo "$result" | grep -oP "$1\(\K[0-9]+")
	if [[ $section =~ ^[0-9]+$ ]]; then
		man "$section" "$1" | grep "$1(" -A 1 | head -5
	else
		echo "$result"
	fi
}

srcs_fill() {
	local search_dir="${1:-.}"

	if [ ! -f "Makefile" ]; then
		echo "Error: Makefile not found in current directory."
		return 1
	fi

	local file_list
	file_list=$(find "$search_dir" -type f \( -name "*.c" -o -name "*.cpp" \) |
		sed 's|.*/||' |
		sort |
		tr '\n' ' ')

	if [ -z "$file_list" ]; then
		echo "No files found in '$search_dir'"
		return 0
	fi

	sed -i -E "/### UFILES_START ###/,/### END ###/c\\
### UFILES_START ###\nFILES     ?= $file_list\n### END ###
" "Makefile"

	echo "'FILES' updated with :"
	echo "$file_list"
}

wlf-copy() {
	if ! command -v wl-copy >/dev/null; then
		echo "Error: wl-copy command not found."
		return 1
	fi
	cat $@ | wl-copy
}

wlf-paste() {
	if ! command -v wl-paste >/dev/null; then
		echo "Error: wl-paste command not found."
		return 1
	fi
	wl-paste | cat >$1
}
