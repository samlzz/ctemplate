#* Alias part

alias la="ls --all"
alias cl="clear"
alias vl="valgrind"
alias ccw="gcc -Wall -Wextra -Werror"

#* func
mkcd() {
    if [ -n "$1" ]; then
        mkdir -p "$1" && cd "$1"
    else
        echo "Erreur : aucun nom de répertoire spécifié."
    fi
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

#? create an .h file with is assosiated .c
hcreate() {
	if [ -z "$1" ]; then
		echo "Erreur : aucun nom de fichier specifie"
		exit 1
	fi
	filename=$1
	def_name=$(echo "$filename" | tr '[:lower:]' '[:upper:]')_H
	
	touch "$filename.h"
	echo "#ifndef $def_name" > "$filename.h"
	echo "# define $def_name" >> "$filename.h"
	echo "" >> "$filename.h"
	echo "#endif" >> "$filename.h"
	
	echo "#include \"$filename.h\"" > "$filename.c"
	echo "Le fichier $filename.h a bien ete creer"
}

#? init current directory to be a project directory
pinit() {
	tmp_dir="$HOME/template"  #? exemples files dir
	curr_dir=$(pwd)

	#? tmp_dir doesn't exist ? reitriving from github
	if [ -d "$tmp_dir" ]; then
		git clone git@github.com:samlzz/template.git "$tmp_dir"
	fi
	cp "$tmp_dir/.gitignore" "$curr_dir"

	if [ "$1" = "noMake" ] || [ "$1" = "nomake" ] || ["$1" = "no" ]; then
		return 0
	fi

	echo -n "Votre projet utilisera-t-il la libft ? (y/n) [y]: "
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
