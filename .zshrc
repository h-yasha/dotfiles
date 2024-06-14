export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode auto # update automatically without asking

plugins=(git z)

source $ZSH/oh-my-zsh.sh

#

export TERM='xterm-256color'
export COLORTERM='truecolor'
export EDITOR='nvim'
export VISUAL='nvim'

#

[ -x "$(command -v batcat)" ] && alias cat="batcat"

# volta start
export VOLTA_HOME="$HOME/.volta"
[ -d $VOLTA_HOME ] && export PATH="$VOLTA_HOME/bin:$PATH"
# volta end

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun start
export BUN_INSTALL="$HOME/.bun"
[ -d $BUN_INSTALL ] && export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
# bun end

# export JAVA_HOME="$HOME/jdk-11.0.2"

# export ANDROID_HOME="$HOME/Android/sdk"
# export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
#
# export PATH="$PATH:/mnt/c/platform-tools"

# export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d' ' -f2)
# export ADB_SERVER_SOCKET=tcp:$WSL_HOST:5037

