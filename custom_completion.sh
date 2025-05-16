#!/usr/bin/env bash

# Autocompletion for ftinit
_ftinit_completions() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    COMPREPLY=( $(compgen -W "--noMake --nomake -nm" -- "$cur") )
    return 0
}

# Autocompletion for gupdate
_gupdate_completions() {
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -d -- "$cur") )
    return 0
}

# Autocompletion for gitingest
_gitingest_completions() {
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -d -- "$cur") )
    return 0
}

# Autocompletion for hcreate
_hcreate_completions() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    if [[ "$prev" == "hcreate" ]]; then
        COMPREPLY=( $(compgen -f -- "$cur") )
    else
        COMPREPLY=( $(compgen -W "--c" -- "$cur") )
    fi
    return 0
}

# Autocompletion for managedns
_managedns_completions() {
    local opts="on off state"
    COMPREPLY=( $(compgen -W "${opts}" -- "${COMP_WORDS[COMP_CWORD]}") )
    return 0
}

# Register autocompletions
complete -F _ftinit_completions ftinit
complete -F _gupdate_completions gupdate
complete -F _gitingest_completions gitingest
complete -F _hcreate_completions hcreate
complete -F _managedns_completions managedns

