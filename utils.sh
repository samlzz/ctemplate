#* Alias part

alias cl="clear"
alias la="ls --all"
alias vl="valgrind"
alias ccw="gcc -Wall -Wextra -Werror"

#* Functions

function exinit {
	local target_dir="$1"
	local curr_dir="$PWD"

	while [[ "$curr_dir" != "/" ]];
	do
		if [[ -d "$curr_dir/.exemple" ]];
		then
			mkdir "$target_dir"
            cp -r "$curr_dir/.exemple/." "$target_dir/"
			echo "$target_dir was correctly init from $curr_dir"
			return
		fi
		curr_dir="$(dirname "$curr_dir")"
	done

	echo "Error: No `.exemple` folder founded."
	exit 1
}

#? for get the prototype of a function in man
manproto() {
	result=$(man "$1" | grep "$1(" -A 1 | head -5)
	section=$(echo "$result" | grep -oP "$1\(\K[0-9]+")
	if [[ $section =~ ^[0-9]+$ ]]; then
		man "$section" "$1" | grep "$1(" -A 1 | head -5
	else
		echo "$result"
	fi
}

ccreate() {
	filename=$1
	c=$2
	h=$3
	def_name=$(echo "$filename" | tr '[:lower:]' '[:upper:]')_H
	
	touch "$filename.$h"
	touch "$filename.$c"

	echo "#ifndef $def_name" > "$filename.$h"
	echo "# define $def_name" >> "$filename.$h"
	echo "" >> "$filename.$h"
	echo "#endif" >> "$filename.$h"

	echo "#include \"$filename.$h\"" > "$filename.$c"
    echo "Les fichiers(.$h, .$c) ont bien ete creer"
}

#? create an .hpp file with is assosiated .cpp
hppcreate() {
	ccreate $1 cpp hpp
}

#? create an .h file with is assosiated .c
hcreate() {
	ccreate $1 c h
}

#? init current directory to be a project directory
ftinit() {
	tmp_dir="$HOME/ctemplate"  #? exemples files dir
	curr_dir=$(pwd)

	#? tmp_dir doesn't exist ? reitriving from github
	if [ -d "$tmp_dir" ]; then
		echo -n "'ctemplate' folder not found in home directory, retrieving it from github (y/n) [y]:"
		read retriev
		if [ -z "$retriev" ]; then
			retriev="y"
		fi
		if [ "$include_libft" = "y" ] || [ "$include_libft" = "Y" ]; then
			git clone git@github.com:samlzz/template.git "$tmp_dir"
		else
			exit 1
		fi
	fi
	cp "$tmp_dir/.gitignore" "$curr_dir"

	if [ "$1" = "--noMake" ] || [ "$1" = "--nomake" ] || ["$1" = "-nm" ]; then
		return
	fi

	echo -n "Did your project will use libft ? (y/n) [y]: "
	read include_libft		
	if [ -z "$include_libft" ]; then
        include_libft="y"
    fi
	if [ "$include_libft" = "y" ] || [ "$include_libft" = "Y" ]; then
		cp "$tmp_dir/libftMakefile" "$curr_dir/Makefile"
	else
		cp "$tmp_dir/Makefile" "$curr_dir/Makefile"
	fi
}