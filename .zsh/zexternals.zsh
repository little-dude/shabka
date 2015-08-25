if [[ -x $(which brew 2>/dev/null) ]]; then
  # Load autojump
  [[ -s "$(brew --prefix)/etc/profile.d/autojump.sh" ]] && source "$(brew --prefix)/etc/profile.d/autojump.sh"
fi

# Load travis
[[ -r "${HOME}/.travis/travis.sh" ]] && source "${HOME}/.travis/travis.sh"

# Load FZF
[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"

# Lastly, do everything that requires the dotfiles to be unsecure
if grep -q OK "${HOME}/.dotfiles/.encrypted"
then
  # Load SSH agents
  [[ -x "${HOME}/.bin/ssh-agents" ]] && eval `ssh-agents $SHELL`
fi
