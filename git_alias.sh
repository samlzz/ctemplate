alias gs="git status"
alias gl="git log | bat"
alias gd="git diff | bat"
alias gcl="git clone"
alias ga="git add"
alias gaa="git add ."
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gp="git push"

git config --global alias.pushall '!git push origin main && git push vogsphere main'
git config --global alias.showall '!git remote show vogsphere && git remote show origin'
