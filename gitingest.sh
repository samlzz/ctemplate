#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

declare -a INCLUDE_PATTERNS=()
declare -a EXCLUDE_PATTERNS=()
BASE_DIR=""
ONLY_MODE=""

parse_args() {
	local arg
	while [[ $# -gt 0 ]]; do
		arg="$1"
		case "$arg" in
		-i | --include)
			shift
			while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
				INCLUDE_PATTERNS+=("$1")
				shift
			done
			;;
		-e | --exclude)
			shift
			while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
				EXCLUDE_PATTERNS+=("$1")
				shift
			done
			;;
		-o | --only)
			shift
			if [[ $# -eq 0 || "$1" =~ ^- ]]; then
				printf "Error: --only requires argument: archi or content\n" >&2
				return 1
			fi
			case "$1" in
			archi | content)
				ONLY_MODE="$1"
				;;
			*)
				printf "Error: Invalid argument for --only: %s\n" "$1" >&2
				return 1
				;;
			esac
			shift
			;;
		-*)
			printf "Error: Unknown option: %s\n" "$arg" >&2
			return 1
			;;
		*)
			if [[ -n "$BASE_DIR" ]]; then
				printf "Error: Multiple directories specified: %s\n" "$1" >&2
				return 1
			fi
			BASE_DIR="$1"
			shift
			;;
		esac
	done

	if [[ -z "$BASE_DIR" ]]; then
		BASE_DIR="."
	fi
	BASE_DIR="${BASE_DIR%/}"
}

convert_glob_to_regex() {
	local pattern="$1"
	pattern="${pattern//./\\.}"
	pattern="${pattern//\*/.*}"
	pattern="${pattern//\?/.}"
	printf "%s" "$pattern"
}

sanitize_patterns() {
	local i
	for i in "${!INCLUDE_PATTERNS[@]}"; do
		local raw="${INCLUDE_PATTERNS[$i]}"
		raw="${raw//[[:space:]]/}"
		if [[ "$raw" != *['^$.*+?()[]'*'']* ]]; then
			INCLUDE_PATTERNS[$i]=$(convert_glob_to_regex "$raw")
		else
			INCLUDE_PATTERNS[$i]="$raw"
		fi
	done
	for i in "${!EXCLUDE_PATTERNS[@]}"; do
		local raw="${EXCLUDE_PATTERNS[$i]}"
		raw="${raw//[[:space:]]/}"
		if [[ "$raw" != *['^$.*+?()[]'*'']* ]]; then
			EXCLUDE_PATTERNS[$i]=$(convert_glob_to_regex "$raw")
		else
			EXCLUDE_PATTERNS[$i]="$raw"
		fi
	done
}

validate_directory() {
	if [[ ! -d "$BASE_DIR" ]]; then
		printf "Error: Directory does not exist: %s\n" "$BASE_DIR" >&2
		return 1
	fi
}

matches_include() {
	local filename="$1"
	if [[ ${#INCLUDE_PATTERNS[@]} -eq 0 ]]; then
		return 0
	fi
	local pattern
	for pattern in "${INCLUDE_PATTERNS[@]}"; do
		if [[ "$filename" =~ $pattern ]]; then
			return 0
		fi
	done
	return 1
}

matches_exclude() {
	local filename="$1"
	local pattern
	for pattern in "${EXCLUDE_PATTERNS[@]}"; do
		if [[ "$filename" =~ $pattern ]]; then
			return 0
		fi
	done
	return 1
}

print_directory_structure() {
	printf "### Directory Structure ###\n"
	if command -v tree &>/dev/null; then
		tree "$BASE_DIR"
	elif ! find "$BASE_DIR" -type d | sed "s|^$BASE_DIR|.|"; then
		printf "Error: Failed to list directories in %s\n" "$BASE_DIR" >&2
		return 1
	fi
	printf "\n"
}

print_file_contents() {
	local file_list
	if ! file_list=$(find "$BASE_DIR" -type f); then
		printf "Error: Failed to find files in %s\n" "$BASE_DIR" >&2
		return 1
	fi

	printf "### File Contents ###\n"

	local file
	while IFS= read -r file; do
		local is_hidden="0"
		[[ "$file" =~ (^|/)\.[^/]+ ]] && is_hidden="1"
		local filename
		filename=$(basename "$file")

		local allow_hidden="0"
		for pattern in "${INCLUDE_PATTERNS[@]}"; do
			[[ "$pattern" == .* ]] && allow_hidden="1" && break
		done

		if [[ "$is_hidden" -eq 1 && "$allow_hidden" -eq 0 ]]; then
			continue
		fi

		if ! matches_include "$filename"; then
			continue
		fi
		if matches_exclude "$filename"; then
			continue
		fi
		printf '================================================\n'
		printf 'FILE: %s\n' "$filename"
		printf '================================================\n'
		cat "$file" || {
			printf "Error: Failed to read file: %s\n" "$file" >&2
			continue
		}
		printf "\n"
	done <<<"$file_list"
}

main() {
	if ! parse_args "$@"; then return 1; fi
	sanitize_patterns
	if ! validate_directory; then return 1; fi

	if [[ "$ONLY_MODE" == "archi" ]]; then
		if ! print_directory_structure; then return 1; fi
		return 0
	fi

	if [[ "$ONLY_MODE" == "content" ]]; then
		if ! print_file_contents; then return 1; fi
		return 0
	fi

	if ! print_directory_structure; then return 1; fi
	if ! print_file_contents; then return 1; fi
}

main "$@"
