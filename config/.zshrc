ZSH_THEME="powerlevel10k/powerlevel10k"
#ZSH_THEME="robbyrussell"

plugins=(fast-syntax-highlighting zsh-autosuggestions)

...

alias francinette="$HOME/francinette/tester.sh"

source /home/sliziard/ctemplate/utils.sh
source "$HOME/ctemplate/git_alias.sh"
export PATH=$HOME/.local/bin:$HOME/.local/funcheck/host:$HOME/.cargo/bin:$PATH

export LESS='--mouse --wheel-lines=3'

export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH

if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh --cmd cd)"
fi

if command -v bat &>/dev/null; then
	export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
fi

export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--multi"

# Editor
if command -v nvim &>/dev/null; then
	export EDITOR=nvim
elif command -v vim &>/dev/null; then
	export EDITOR=vim
else
	export EDITOR=vi
fi
