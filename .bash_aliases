#!/bin/bash

#################################### UTILS ####################################

# Update
update () {
	#set -o errexit -o pipefail -o noclobber -o nounset

	echo "Updating..."
	sudo apt-get update
	echo
	echo "Upgrading..."
	sudo apt-get upgrade
	echo
	echo "Removing cache..."
	sudo apt-get clean
	echo
	echo "Upgrading distro..."
	sudo apt-get dist-upgrade

	! getopt --test > /dev/null 
	if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    		echo "I’m sorry, `getopt --test` failed in this environment."
    		exit 1
	fi

	OPTIONS=rs
	LONGOPTS=autoremove,remove-snaps

	! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
	if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
		exit 2
	fi
	eval set -- "$PARSED"

	s=n r=n

	while true; do
	    case "$1" in
        	-s|--remove-snaps)
            		s=y
            		shift
            		;;
        	-r|--autoremove)
            		r=y
            		shift
           		 ;;
        	--)
            		shift
            		break
            		;;
        	*)
            		echo "Programming error"
            		exit 3
            		;;
    		esac
	done

	if test $r = y; then
		echo
		echo "Removing useless packages..."
		sudo apt autoremove
	fi

	if test $s = y; then
		echo
		echo "Removing old snaps..."
		#set -eu

		snap list --all | awk '/disabled/{print $1, $3}' |
    			while read snapname revision; do
        			snap remove "$snapname" --revision="$revision"
    			done
	fi
}

# Perform backup
backup () {
	export GOOGLE_DRIVE_SETTINGS=~/.duply/gdrive
	echo "Backing up /home on Google Drive..."
	duplicity ~ gdocs://ioanaa.alexandru98@gmail.com/LinuxBKP --progress
}

# Asks before deleting
alias rm='rm -I'

# Frees up the cached memory
alias freemem='sync && echo 3 | sudo tee /proc/sys/vm/drop_caches'

# Opens current directory in a file explorer
alias explore='nautilus . & disown'

# Opens current directory in a file explorer with super user privileges
alias suexplore='sudo nautilus . & disown'


# Script to show the colours used for different file types
colors () {
	# This is just a more readable version of the 'eval' code at:
	#     http://askubuntu.com/a/17300/309899

	# A nice description of the colour codes is here:
	#     http://askubuntu.com/a/466203/309899

	IFS=:
	for SET in $LS_COLORS
	do
	    TYPE=$(echo $SET | cut -d"=" -f1)
	    COLOUR=$(echo $SET | cut -d"=" -f2)

	    case $TYPE in
	        no) TEXT="Global default";;
	        fi) TEXT="Normal file";;
	        di) TEXT="Directory";;
	        ln) TEXT="Symbolic link";;
	        pi) TEXT="Named pipe";;
	        so) TEXT="Socket";;
	        do) TEXT="Door";;
	        bd) TEXT="Block device";;
	        cd) TEXT="Character device";;
	        or) TEXT="Orphaned symbolic link";;
	        mi) TEXT="Missing file";;
	        su) TEXT="Set UID";;
	        sg) TEXT="Set GID";;
	        tw) TEXT="Sticky other writable";;
	        ow) TEXT="Other writable";;
	        st) TEXT="Sticky";;
	        ex) TEXT="Executable";;
	        rs) TEXT="Reset to \"normal\" color";;
	        mh) TEXT="Multi-Hardlink";;
	        ca) TEXT="File with capability";;
	        *) TEXT="${TYPE}";;
	    esac

	    printf "Type: %-10s Colour: %-10s \e[${COLOUR}m${TEXT}\e[0m\n" "${TYPE}" "${COLOUR}"
	done
}

############################## CLASSIC SHORTCUTS ##############################

# cd & ls
cl () { cd $@ && ls; }

# Opens file with default program
o () { xdg-open "$@" & disown; }

# Folder shortcuts
alias ..='cd .. && ls'
alias ...='cd ../.. && ls'

# History
alias hs='history | grep'

# Archive aliases
alias unrar='rar e'
alias tgz='tar -xzvf'
alias tbz='tar -jxvf'

# Execute permissions
alias ax='sudo chmod a+x'

#################################### TYPOS ####################################

alias sl='ls'
alias gti='git'

################################### MY STUFF ##################################

hw () { cd ~/Documents/Teme/$1 && ls; }
lab () { cd ~/Documents/Laboratoare/$1 && ls; }
doc () { cd ~/Documents/$1 && ls; }
dow () { cd ~/Downloads/ && ls; }

################################### WEBPAGES ##################################

# Uni
alias vm='o https://vmchecker.cs.pub.ro'
alias cs='o http://cs.curs.pub.ro'
alias ocw='o http://ocw.cs.pub.ro'
alias acs='o http://acs.pub.ro'
alias ppcarte='o https://ocw.cs.pub.ro/ppcarte'

# Email
alias gmail='google-chrome https://mail.google.com & disown'
alias ymail='google-chrome https://mail.yahoo.com & disown'

# Social
alias fb='google-chrome https://www.facebook.com & disown'
alias wapp='google-chrome https://web.whatsapp.com & disown'

# Useful
alias gitlab='o https://gitlab.cs.pub.ro'
alias slack='o https://codettero.slack.com'

# Fun
alias netflix='google-chrome https://www.netflix.com/browse & disown'
alias spotify='google-chrome https://open.spotify.com/browse & disown'


###################################### I3 #####################################

alias i3exit='/home/ioana/.config/i3/i3exit.sh'

##################################### GIT #####################################

alias gcl='git clone'
alias ga='git add'
alias grm='git rm'
alias gap='git add -p'
alias gall='git add -A'
alias gf='git fetch --all --prune'
alias gft='git fetch --all --prune --tags'
alias gfv='git fetch --all --prune --verbose'
alias gftv='git fetch --all --prune --tags --verbose'
alias gus='git reset HEAD'
alias gpristine='git reset --hard && git clean -dfx'
alias gclean='git clean -fd'
alias gm='git merge'
alias gmv='git mv'
alias g='git'
alias get='git'
alias gs='git status'
alias gss='git status -s'
alias gsu='git submodule update --init --recursive'
alias gl='git pull'
alias glum='git pull upstream master'
alias gpr='git pull --rebase'
alias gpp='git pull && git push'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gpo='git push origin'
alias gpu='git push --set-upstream'
alias gpuo='git push --set-upstream origin'
alias gpom='git push origin master'
alias gr='git remote'
alias grv='git remote -v'
alias gra='git remote add'
alias gd='git diff'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcm='git commit -v -m'
alias gcam='git commit -v -am'
alias gci='git commit --interactive'
alias gb='git branch'
alias gba='git branch -a'
alias gbt='git branch --track'
alias gbm='git branch -m'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gco='git checkout'
alias gcom='git checkout master'
alias gcb='git checkout -b'
alias gcob='git checkout -b'
alias gct='git checkout --track'
alias gexport='git archive --format zip --output'
alias gdel='git branch -D'
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gg='git log --graph --pretty=format:"%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset" --abbrev-commit --date=relative'
alias ggs='gg --stat'
alias gsl='git shortlog -sn'
alias gwc='git whatchanged'
alias gt='git tag'
alias gta='git tag -a'
alias gtd='git tag -d'
alias gtl='git tag -l'
alias gnew='git log HEAD@{1}..HEAD@{0}'
alias gcaa='git commit -a --amend -C HEAD'
alias ggui='git gui'
alias gcsam='git commit -S -am'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gst='git stash'
alias gstp='git stash pop'
alias gh='cd "$(git rev-parse --show-toplevel)'
alias gtls='git tag -l | gsort -V'
alias gtls='git tag -l | sort -V'
