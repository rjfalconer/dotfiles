# This is sourced by .xsessionrc, which is processed by /bin/sh (e.g., dash).
# So, even though this is Bash's profile, we can't use Bash-only constructs!

# <http://lists.gnu.org/archive/html/bug-bash/2005-01/msg00263.html> is a good
# explanation of this insanity. Also <http://lkml.org/lkml/2005/4/25/205>.

export DEBEMAIL=sam@robots.org.uk
export DEBNAME='Sam Morris'
export PATH=$PATH:$HOME/bin:$HOME/.local/bin

test -f ~/.pythonrc && export PYTHONSTARTUP=$HOME/.pythonrc

case "$(uname -s)" in
CYGWIN_*)
	# Received wisdom from Cygwin's default .bashrc
	unset TMP
	unset TEMP
	;;
Darwin)
	export CLICOLOR=1
	;;
esac

if test -z "$HOSTNAME"; then
	HOSTNAME=$(hostname)
fi
case "${HOSTNAME%%.*}" in
traxus)
	export TZ=Europe/London
	;;
esac

if test -n "$SSH_AUTH_SOCK" && -n "$TMUX" && ! -L "$SSH_AUTH_SOCK"; then
	ln -sfr  "$SSH_AUTH_SOCK" "$TMUX.ssh"
	SSH_AUTH_SOCK="$TMUX.ssh"
fi

MALLOC_PERTURB_=$(od -A n -t u -N 1 /dev/urandom)
export MALLOC_PERTURB_

# Source .bashrc if this is an interactive shell
case $- in
*i*)
	. ~/.bashrc
	;;
esac