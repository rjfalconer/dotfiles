# .bashrc is sourced for an interactive shell.

# For some reason, openssh invokes bash as an interactive shell even if we
# are only using scp. Therefore check that we have a terminal before processing
# this file
if test -n "$SSH_CONNECTION"; then
    tty -s || return
fi

# disable XON/XOFF so that we can use readline's forward-search-history command
# by pressing C-s
command -v stty &>/dev/null && stty stop undef && stty start undef

shopt -s cdspell
shopt -s histverify
shopt -s no_empty_cmd_completion

export DJANGO_COLORS="light"

export GREP_OPTIONS='--color=auto'

export EDITOR=vim

if test -n "$DISPLAY"
then
	BROWSER=chromium
	alias vim=gvim
else
	BROWSER=w3m
fi
export BROWSER

export PAGER=less
command -v lesspipe &>/dev/null && eval "$(lesspipe)"
# see termcap(5) for an explanation of these codes
export LESS_TERMCAP_mb=$'\e[01;31m' # start blink
export LESS_TERMCAP_md=$'\e[0;31m' # start bold
export LESS_TERMCAP_me=$'\e[0m' # back to normal
export LESS_TERMCAP_so=$'\e[0;44;33m' # start standout (status line)
export LESS_TERMCAP_se=$'\e[0m' # end standout
export LESS_TERMCAP_us=$'\e[0;32m' # start underline
export LESS_TERMCAP_ue=$'\e[0m' # end underline

command -v dircolors >/dev/null && eval "$(dircolors -b)"

# best prompt ever!
#
function smile {
	if test $? = 0; then
		printf "${csi_green}:)"
	else
		printf "${csi_red}:("
	fi
}
function user_colour {
	if test "$UID" = 0; then
		printf "${csi_red}"
	else
		printf "${csi_green}"
	fi
}
csi_default=$(tput sgr 0)
csi_cyan=$(tput setaf 6)
csi_green=$(tput setaf 2)
csi_red=$(tput setaf 1)
csi_gold=$(tput setaf 3)
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=verbose
PS1="\n\$(smile) ${csi_cyan}\A $(user_colour)\u@\h ${csi_gold}\w${csi_default} \$(type -t __git_ps1 >/dev/null && __git_ps1 '(%s)')\n\\$ "

HISTCONTROL=ignoreboth
HISTSIZE=5000

# xterm/screen title
#
case "$TERM" in
xterm*|rxvt*|screen)
	# http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
	if [[ ! $PROMPT_COMMAND ]]; then
		PROMPT_COMMAND='printf "\033]0;${HOSTNAME%%.*}:${PWD/#$HOME/~}\a"'
	fi
	;;
esac

#function remotesign {
#	set -e
#
#	host="$1"
#
#	while shift; do
#		test -n "$1" || continue
#
#		data=$(ssh "$host" cat "$file")
#		sign=$(gpg --armor --detach-sign <<< "$data")
#		ssh "$host" cat '>' "$file.asc"
#	done
#}

function envof {
	file=/proc/${1:?Usage: $0 pid}/environ
	cmd="cat $file"
	test -r $file || cmd="sudo $cmd"
	$cmd | tr '\0' '\n' | cat -v
}

function physize {
	echo $(( $(stat -c '%B * %b' "$1") / 1024 )) "$1"
}

function block {
	sudo iptables -I OUTPUT -d "$1" -j DROP
}

function batchfg {
	foo="$(awk '{print $1}' /proc/loadavg) < 1.5"
	while test "$(bc <<< "$foo")" = '0'; do
		foo="$(awk '{print $1}' /proc/loadavg) < 1.5"
		sleep 5
	done
	"$@"
}

#function info {
#	gnome-open "http://localhost/cgi-bin/info2www?($1)$2"
#}

function svngrep {
	find -name '.svn' -prune -or -exec grep "$@" {} +
}

function debskew {
	apt-cache showsrc "$1" \
		| grep-dctrl . --show=binary -n \
		| tr ', ' '\n' \
		| sort -u \
		| xargs -r dpkg -l
}

function rb {
	env $(envof $(pgrep rhythmbox) | grep ^DBUS_SESSION_BUS_ADDRESS=) rhythmbox-client "$@"
}

function exaudio {
	ffmpeg -i "$1" -acodec copy -vn "$2"
}

function winbreak {
	~/src/debugbreak/debugbreak $(tasklist //fi "imagename eq $1" | awk "\$1 == \"$1\" { print \$2 }")
}


alias apt='aptitude'
alias dig='dig +multi'
alias dquilt='QUILT_PATCHES=debian/patches QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index" quilt'
alias dstat='dstat --bw'
alias dux='du -xm --max-depth=1'
alias e="$EDITOR"
alias g=git
alias gdb='gdb -silent'
alias gnutls-cli="gnutls-cli --x509cafile /etc/ssl/certs/ca-certificates.crt"
alias la='ls -A'
alias ll='ls -lh'
alias massif='valgrind --tool=massif --depth=5 --alloc-fn={g_malloc,g_realloc,g_try_malloc,g_malloc0,g_mem_chunk_alloc}'
alias mysql='mysql --pager'
alias odh='od -A x -t x1z'
alias ping='ping -n'
alias pol='apt-cache policy'
alias rsync='rsync -h'
alias units='units --verbose'
alias wgoat='wget'
alias whois='whois -H'
alias xc='xclip -selection clipboard -in'
alias xp='xclip -selection clipboard -out'
alias xse='tail --follow=name ~/.xsession-errors -n 0'

command -v gvfs-open &>/dev/null && alias open=gvfs-open

if test -z "$CLICOLOR"; then
	alias cgrep='grep --color --context=9999999'
	alias ls='ls --color=auto'
fi

case $HOSTNAME in
durandal)
	alias nogba='wine ~/nogba/NO\$GBA.EXE'
	;;
lysander)
	alias vim='c:\\Program\ Files\ \(x86\)\\vim\\vim73\\vim.exe'
	alias gvim='c:\\Program\ Files\ \(x86\)\\vim\\vim73\\gvim.exe'
	;;
esac
