#* Alias part

alias cl="clear"
alias la="ls --all"
alias vl="valgrind"
alias vla="valgrind-s --leak-check=full --track-origins=yes --show-leak-kinds=all --track-fds=yes"

alias ccw="gcc -Wall -Wextra -Werror"
alias mk="make"

#* Functions

exinit() {
	if [ -z "$1" ]; then
        echo "Error: No target dir provided."
        exit 1
	fi
	local target_dir="$1"
	local curr_dir="$PWD"

	while [[ "$curr_dir" != "/" ]];
	do
		if [[ -d "$curr_dir/.exemple" ]];
		then
			mkdir -p "$target_dir"
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
	if [ -z "$1" ]; then
        echo "Error: No function name provided."
        exit 1
	fi
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
	h=$2
	c=$3
	def_name=$(echo "$filename" | tr '[:lower:]' '[:upper:]')_H
	
	touch "$filename.$h" 

	echo "#ifndef $def_name" > "$filename.$h"
	echo "# define $def_name" >> "$filename.$h"
	echo "" >> "$filename.$h"
	echo "#endif" >> "$filename.$h"

	echo -n "Do you want to create the source file $filename.$c? (Y/n):"
	read -r create_source
    create_source=${create_source:-y}
	if [[ "$create_source" =~ ^[yY]$ ]]; then
		echo "#include \"$filename.$h\"" > "$filename.$c"
		echo "Files(.$h, .$c) were created successfully"
	else
		echo "File(.$h) was successfully created"
	fi
}

#? create an .hpp file with is assosiated .cpp
hppcreate() {
	if [ -z "$1" ]; then
        echo "Error: No filename provided."
        exit 1
	fi
	ccreate "$1" hpp cpp
}

#? create an .h file with is assosiated .c
hcreate() {
	if [ -z "$1" ]; then
        echo "Error: No filename provided."
        exit 1
	fi
	ccreate "$1" h c
}

#? init current directory to be a project directory
ftinit() {
	tmp_dir="$HOME/ctemplate"  #? exemples files dir
	curr_dir=$(pwd)

	#? tmp_dir doesn't exist ? reitriving from github
	if [ ! -d "$tmp_dir" ]; then
		echo -n "'ctemplate' folder not found in home directory, retrieving it from github (Y/n):"
		read -r retriev
		retriev=${retriev:-y}
		if [[ "$retriev" =~ ^[yY]$ ]]; then
			git clone git@github.com:samlzz/template.git "$tmp_dir" || {
				echo "Error: Failed to clone repository."
				exit 1
            }
		else
			exit 1
		fi
	fi

	cp "$tmp_dir/.gitignore" "$curr_dir"

	if [[ "$1" =~ ^(--noMake|--nomake|-nm)$ ]]; then
		return
	fi

	echo -n "Did your project will use libft ? (Y/n): "
	read -r include_libft
	include_libft=${include_libft:-y}
	if [[ "$include_libft" =~ ^[yY]$ ]]; then
		cp "$tmp_dir/libftMakefile" "$curr_dir/Makefile"
		make lib
		make fclean
		./libft/features.sh
	else
		cp "$tmp_dir/Makefile" "$curr_dir/Makefile"
	fi
	mkdir src
}

gupdate()
{
	default_repos=("$HOME/ctemplate")
	if [ "$#" -eq 0 ]; then
		echo "[INFO] no dir given, use default directory."
		repos_to_update=("${default_repos[@]}")
	else
		repos_to_update=("${default_repos[@]}" "$@")
	fi
	updated_repos=()

	for repo_path in "${repos_to_update[@]}"; do
		if [ ! -d "$repo_path" ]; then
		    echo "[ERREUR] '$repo_path' doesn't exist."
		    continue
		fi

		cd "$repo_path" || {
		    echo "[ERREUR] fail to navige to $repo_path."
		    continue
		}

		if [ ! -d ".git" ]; then
		    echo "[ERREUR] $repo_path wasn't a Git repository."
		    cd - > /dev/null
		    continue
		fi

		echo "[INFO] Mise à jour du dépôt dans $repo_path..."
		pull_output=$(git pull 2>&1)

		if [[ "$pull_output" != *"Already up to date."* ]]; then
		    updated_repos+=("$repo_path")
		fi

		cd  > /dev/null
	done

	# Affiche les résultats
	echo "\n[RÉSUMÉ] Dossiers mis à jour :"
	if [ ${#updated_repos[@]} -eq 0 ]; then
		echo "Aucun dépôt n'a été mis à jour."
	else
		for updated_repo in "${updated_repos[@]}"; do
	    		echo "- $updated_repo"
		done
	fi
}
