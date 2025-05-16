#!/usr/bin/env bash

set_config_file() {
	local shell config
	echo -n "Which shell do you use? (bash/zsh/fish/other):"
	read -r shell

	case "$shell" in
	bash)
		config="$HOME/.bashrc"
		;;
	zsh)
		config="$HOME/.zshrc"
		;;
	fish)
		config="$HOME/.config/fish/config.fish"
		;;
	other)
		printf "Please enter the path to your configuration file: "
		read -r config
		;;
	*)
		printf "Unrecognized shell type. Please restart and choose one of: bash/zsh/fish/other\n" >&2
		return 1
		;;
	esac

	if [[ ! -f "$config" ]]; then
		printf "Configuration file not found: %s\n" "$config" >&2
		return 1
	fi

	CONFIG_FILE="$config"
}

ensure_local_bin_in_path() {
	local target="$HOME/.local/bin"

	mkdir -p "$target"

	if [[ ":$PATH:" != *":$target:"* ]]; then
		printf '\n# Add ~/.local/bin to PATH\n' >>"$CONFIG_FILE"
		printf 'export PATH="$HOME/.local/bin:$PATH"\n' >>"$CONFIG_FILE"

		printf "Added %s to PATH in '%s'. Restart your shell to apply changes.\n" "$target" "$CONFIG_FILE"
	fi
}

add_source_once() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		printf "Error: cannot source missing file: %s\n" "$file" >&2
		return 1
	fi

	grep -Fq "$file" "$CONFIG_FILE" || printf "\nsource \"%s\"\n" "$file" >>"$CONFIG_FILE"
}

main() {
	template_dir="$HOME/ctemplate"
	[ ! -d "$template_dir" ] && {
		echo "Error: 'ctemplate' not found in HOME directory." >&2
		return 1
	}
	if ! set_config_file; then
		return 1
	fi

	local utils="$template_dir/utils.sh"
	local gitalias="$template_dir/git_alias.sh"
	local completion="$template_dir/custom_completion.sh"

	chmod +x "$utils" "$gitalias" "$completion" "$template_dir"/bin/* || {
		printf "Error: Failed to set execute permissions.\n" >&2
		return 1
	}

	add_source_once "$utils"
	add_source_once "$gitalias"
	add_source_once "$completion"

	ensure_local_bin_in_path

	cp "$template_dir"/bin/* "$HOME/.local/bin/" || {
		echo "Error: fail to add commands to '~/.local/bin" >&2
		return 1
	}

	printf "Utility setup completed. Restart your shell to activate the changes.\n"
}

main "$@"
