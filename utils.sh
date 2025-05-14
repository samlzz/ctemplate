#* Alias part

alias cl="clear"
alias la="ls --all"
alias vl="valgrind"
alias vla="valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all --track-fds=yes"

alias ccw="gcc -Wall -Wextra -Werror"
alias mk="make"
alias py="python3"

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

ccreate() {
	local filename=$1
	local h=$2
	local c=$3
	local def_name=$(echo "$filename" | tr '[:lower:]' '[:upper:]')_H

	touch "$filename.$h"

	echo "#ifndef $def_name" >"$filename.$h"
	echo "# define $def_name" >>"$filename.$h"
	echo "" >>"$filename.$h"
	echo "#endif" >>"$filename.$h"

	echo -n "Do you want to create the source file $filename.$c? (Y/n):"
	read -r create_source
	create_source=${create_source:-y}
	if [[ "$create_source" =~ ^[yY]$ ]]; then
		echo "#include \"$filename.$h\"" >"$filename.$c"
		echo "Files(.$h, .$c) were created successfully"
	else
		echo "File(.$h) was successfully created"
	fi
}

#? create an .h file with is assosiated .c
hcreate() {
	if [ -z "$1" ]; then
		echo "Error: No filename provided."
		exit 1
	fi
	ccreate "$1" h c
}

hppcreate() {
	if [ -z "$1" ]; then
		echo "Usage: hppcreate <ClassName>"
		return 1
	fi

	local class_name="$1"
	local hpp_file="${class_name}.hpp"
	local cpp_file="${class_name}.cpp"
	local include_guard
	include_guard=$(echo "${class_name}_HPP" | tr '[:lower:]' '[:upper:]')

	if [[ -e "$hpp_file" || -e "$cpp_file" ]]; then
		echo "[ERROR] $hpp_file or $cpp_file already exists."
		return 1
	fi

	# Create .hpp
	cat >"$hpp_file" <<EOF
#ifndef ${include_guard}
# define ${include_guard}

# include <iostream>

class ${class_name} {
public:
	${class_name}();
	${class_name}(const ${class_name}& other);
	${class_name}& operator=(const ${class_name}& other);
	~${class_name}();

private:
	// Attributes
};

#endif
EOF

	# Create .cpp
	cat >"$cpp_file" <<EOF
#include "${hpp_file}"

${class_name}::${class_name}() {
	std::cout << "${class_name} default constructor called" << std::endl;
}

${class_name}::${class_name}(const ${class_name}& other) {
	std::cout << "${class_name} copy constructor called" << std::endl;
	*this = other;
}

${class_name}& ${class_name}::operator=(const ${class_name}& other) {
	std::cout << "${class_name} assignment operator called" << std::endl;
	if (this != &other) {
		// Copy attributes here
	}
	return *this;
}

${class_name}::~${class_name}() {
	std::cout << "${class_name} destructor called" << std::endl;
}
EOF
}

#? init current directory to be a project directory
ftinit() {
	local tmp_dir="$HOME/ctemplate" #? exemples files dir
	local curr_dir=$(pwd)

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

	cp "$tmp_dir/newMakefile" "$curr_dir/Makefile"
	mkdir src
}

srcs_fill() {
	local search_dir="${1:-.}"

	if [ ! -f "Makefile" ]; then
		echo "Makefile not found in current directory."
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

	sed -i.bak -E "/### UFILES_START ###/,/### END ###/c\\
### UFILES_START ###\nFILES     ?= $file_list\n### END ###
" "Makefile"

	echo "[OK] 'FILES' updated with :"
	echo "$file_list"
}

gupdate() {
	local curr_dir=$(pwd)
	local default_repos repos_to_update updated_repo
	default_repos=("$HOME/ctemplate")
	if [ "$#" -eq 0 ]; then
		echo "[INFO] no dir given, use default directory."
		repos_to_update=("${default_repos[@]}")
	else
		repos_to_update=("$@" "${default_repos[@]}")
	fi
	updated_repos=()

	local repo_path
	for repo_path in "${repos_to_update[@]}"; do
		if [[ "$repo_path" != /* ]]; then
			repo_path="$curr_dir/$repo_path"
		fi

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
			continue
		fi

		echo "[INFO] Mise à jour du dépôt dans $repo_path..."
		git fetch --all
		local pull_output
		pull_output=$(git pull 2>&1)

		if [ $? -eq 0 ] && [[ "$pull_output" != *"Already up to date."* ]]; then
			updated_repos+=("$repo_path")
		fi
	done

	cd "$curr_dir" >/dev/null

	# Affiche les résultats
	echo -e "\n[RÉSUMÉ] Dossiers mis à jour :"
	if [ ${#updated_repos[@]} -eq 0 ]; then
		echo "Aucun dépôt n'a été mis à jour."
	else
		for updated_repo in "${updated_repos[@]}"; do
			echo "- $updated_repo"
		done
	fi
}

managedns() {
	case "$1" in
	off)
		echo "[INFO] Désactivation de la gestion DNS par NetworkManager..."
		sudo mkdir -p /etc/NetworkManager/conf.d
		echo -e "[main]\ndns=none" | sudo tee /etc/NetworkManager/conf.d/dns.conf >/dev/null
		cat /etc/myresolv.conf | sudo tee /etc/resolv.conf >/dev/null
		sudo chattr +i /etc/resolv.conf
		sudo systemctl restart NetworkManager
		echo "[OK] Gestion DNS désactivée. Utilisation de Cloudflare et Google."
		;;

	on)
		echo "[INFO] Réactivation de la gestion DNS par NetworkManager..."
		sudo rm -f /etc/NetworkManager/conf.d/dns.conf
		sudo chattr -i /etc/resolv.conf
		sudo systemctl restart NetworkManager
		echo "[OK] Gestion DNS réactivée par NetworkManager."
		;;

	state)
		if [[ -f /etc/NetworkManager/conf.d/dns.conf ]]; then
			echo "[STATUS] Gestion DNS : ❌ Désactivée (NetworkManager ne gère pas le DNS)"
		else
			echo "[STATUS] Gestion DNS : ✅ Activée (NetworkManager gère le DNS)"
		fi
		;;

	*)
		echo "Usage: manage_dns on|off|state"
		return 1
		;;
	esac
}
