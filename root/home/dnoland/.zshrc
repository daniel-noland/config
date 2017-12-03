source ~/.shellrc
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory autocd extendedglob nomatch
#Prevent hiostory from containing duplicate lines
setopt histignoredups
#Force user to type exit, xx, or logout instead of just pressing <C-d>
setopt ignoreeof
#Enable interactive comments
setopt interactivecomments
#Turn on spelling correction
#setopt correct
#setopt correctall
#Prevent '' from containing valid new line
#setopt cshjunkiequotes

# load python module
# module_path=($module_path /usr/lib/zpython)
# zmodload zsh/zpython

unsetopt beep notify
bindkey -v
zstyle :compinstall filename '/home/dnoland/.zshrc'

autoload -Uz compinit
compinit
autoload -U colors && colors
if [[ -x $(whence -c powerline) ]]; then
   # powerline-daemon --quiet
   # POWERLINE_COMMAND=powerline-client
   export LANG="en_US.UTF-8"
   source /usr/lib/$(basename $(readlink -f $(whence python)))/site-packages/powerline/bindings/zsh/powerline.zsh
   # source /usr/share/zsh/site-contrib/powerline.zsh
else
   setopt prompt_subst
   autoload -Uz vcs_info
   zstyle ':vcs_info:*' actionformats \
       '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
   zstyle ':vcs_info:*' formats       \
       '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
   zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
   zstyle ':vcs_info:*' enable git cvs svn


   # or use pre_cmd, see man zshcontrib
   vcs_info_wrapper() {
     vcs_info
     if [ -n "$vcs_info_msg_0_" ]; then
       echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
     fi
   }

   curr_dir() {
      echo "%{$fg[yellow]%}%~%{$fg[red]%}$reset_color "
   }
   
   normalized_len() {
      str=$(echo $1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | sed -e 's/\%{//g' -e 's/\%}//g')
      echo ${#str}
   }

   rside=" <%{$fg[green]%}%n%{$reset_color%}@%{$fg[cyan]%}%m$reset_color> %{$fg[yellow]%} "$'$(vcs_info_wrapper)'"$reset_color"
   hbar() {
      totalLines=$(( $(tput cols) - $(normalized_len $(pwd)) - $(normalized_len $rside) ))
      rule=$(printf "―%.0s" {1..$totalLines})
      echo $rule
   }

   PROMPT="%{$fg[red]%}╔ "$'$(curr_dir)'$'$(hbar)'"$rside
%{$fg[red]%}╚ $reset_color"
  RPROMPT=""
   
fi

if [[ -n $TMUX ]]; then
  tmux set-window-option utf8 on &> /dev/null
  tmux set-window-option -g utf8 on &> /dev/null
fi

#enable zsh command line syntax hilighting.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#enable zmv pattern based move command
autoload -U zmv

export KEYTIMEOUT=0

# for gpg agent

gpg-connect-agent updatestartuptty /bye >/dev/null

shred() {
   local iterations="--iterations=1"
   local remove="--remove"
   local verbose="--verbose"
   local random_source=""
   local force=""
   local size=""
   local exact=""
   local help=""
   local version=""
   local keep=""
   local quiet=""
   zparseopts -K -E -D \
      f=force -force=force \
      n:=iterations -iterations:=iterations \
      --random-source:=random_source \
      s:=size -size:=size \
      u::=remove -remove::=remove \
      v=verboxe -verbose=verbose \
      x=exact -exact=exact \
      -help=help \
      -version=version \
      -keep=keep \
      -quiet=quiet 
   [ -n "$help" ] && command shred --help && return;
   [ -n "$version" ] && command shred --version && return;
   [ -n "$quiet" ] && unset verbose;
   [ -n "$keep" ] && unset remove && [ ! -n "$quiet" ] && echo "--keep set: destroying files but not removing them.";
   setRemove=$remove
   iterations=$(echo $iterations | sed 's/ *//g')
   for i in $@; do
      [ ! -e "$i" ] && echo "$i does not exist!" >&2 && continue;
      [ -d "$i" ] && echo "$i is a directory!  Can not shred!" >&2 && continue;
      [ -b "$i" ] && [ -n "$remove" ] && echo "$i is a block device: not removing!" && unset remove
      [ ! -w "$i" ] && echo "$i is not writeable.  Can not shred!" >&2 && continue;
      shredArgs="$force $iterations $random_source $size $remove $verbose $exact";
      [ ! -n "$quiet" ] && echo /usr/bin/shred $shredArgs $i;
      echo "$shredArgs $i" | xargs /usr/bin/shred 
      remove="$setRemove"
   done
}

omni_hash() {
   zparseopts -K -E -D \
      t:=target -target:=target
   [ ! -n "$target[2]" ] && echo "no target given! ${target[2]}" && return 1
   hashes=(md5 sha1 sha224 sha256 sha384 sha512)
   for hash in ${hashes}; do
      [[ -a "$target[2].${hash}" ]] && echo "($target[2].${hash}) exists!" && return 1
   done
   for source in "$@"; do
      for file in $(find "$source"); do
         echo "file ${file}"
         [ -d ${file} ] && continue
         for hash in $hashes; do
            CMD="$hash"sum
            $CMD "$file" >> "${target[2]}.${hash}"
         done
      done
   done
}

omni_verify() {
   hashes=(md5 sha1 sha224 sha256 sha384 sha512)
   for hash_algo in $hashes; do
      echo "$hash_algo"
      for hash_list in "$(pwd)"/omni_hash.${hash_algo}; do
         while read hash_line; do
            file=$(echo "$hash_line" | awk '{print $2}')
            diff -q <(${hash_algo}sum "$file") <(echo "$hash_line") > /dev/null
            if [ $? -ne 0 ]; then
               echo "$file corrupt"
            else
               echo "$file valid"
            fi
         done < <(cat ${hash_list})
      done
   done

}

# Extract the file whatever it is
extract () {
    for i in $@; do
       if [ -e "$i" ]; then
           case "$i" in
               *.tar.bz2)        new=$(basename --suffix .tar.bz2 "$i") && tar xjf "$i"        ;;
               *.tar.gz)         new=$(basename --suffix .tar.gz "$i") && tar xzf "$i"        ;;
               *.bz2)            new=$(basename --suffix .bz2 "$i") && bunzip2 "$i"        ;;
               *.rar)            new=$(basename --suffix .rar "$i") && unrar x "$i"        ;;
               *.gz)             new=$(basename --suffix .gz "$i") && gunzip "$i"         ;;
               *.tar)            new=$(basename --suffix .tar "$i") && tar xf "$i"         ;;
               *.tbz2)           new=$(basename --suffix .tbz2 "$i") && tar xjf "$i"        ;;
               *.tgz)            new=$(basename --suffix .tgz "$i") && tar xzf "$i"        ;;
               *.zip)            new=$(basename --suffix .zip "$i") && unzip "$i"          ;;
               *.Z)              new=$(basename --suffix .Z "$i") && uncompress "$i"     ;;
               *.gpg)            new=$(basename --suffix .gpg "$i") && gpg -d "$i" > "$new" ;;
               *.scrypt)         new=$(basename --suffix .scrypt "$i") && scrypt dec "$i" > "$new" ;;
               *.bundle)         new=$(basename --suffix .bundle "$i") && unbundle "$i" ;;
               *)                new="___--#EXTRACTION COMPLETE#--___" && return 1 ;;
           esac
           retCode=$?
           echo "$new"
           return ${retCode}
       else
           echo "___--#EXTRACTION COMPLETE#--___"
           return 1
       fi
    done
}

# recursively extract files
rxtr() {
   for i in $@; do
      new=$(extract "$i")
      retcode=$?
      echo ${new}
      while (( retcode == 0 )); do
         new=$(extract "$new")
         retcode=$?
         echo ${new}
      done
   done
}

# bundle up a file, and generate checksums
bundle() {
   bundleCommand="tar"
   bundleArgs="czvf"
   bundleSuffix="tar.gz"
   wrapArgs="cvf"
   wrapSuffix="tar"
   hashes=(md5 sha1 sha224 sha256 sha384 sha512)
   for i in $@; do
      if [ -d "$i" ]; then
         echo "Bundling $i"
         dataLoc="$i.$bundleSuffix"
         $bundleCommand $bundleArgs "$dataLoc" "$i"
         bundleLoc="$i".bundle
         mkdir "$bundleLoc"
         dataLoc="$i"."$bundleSuffix"
         mv "$dataLoc" "$bundleLoc"
         dataName="$i.$bundleSuffix"
         dataLoc="$bundleLoc/$i.$bundleSuffix"
         checksumDir="$bundleLoc"
         [ ! -d "$checksumDir" ] && mkdir "$checksumDir"
         currentDir=$(pwd)
         omni_hash --target ${checksumDir}/omni_hash "$i"
         cd "$checksumDir"
         for hash in $hashes; do
            CMD="$hash"sum
            echo "computing $CMD"
            $CMD "$dataName" > "${dataName}.${hash}"
         done
         gpg --detach-sign --armor "$dataName"
         cd "$currentDir"
         wrapName="$i.bundle.$wrapSuffix"
         $bundleCommand $wrapArgs "$wrapName" "$bundleLoc" && rm -r "$bundleLoc"
      fi
   done
}

# bundle and gpg encrypt
gbundle() {
   bundle $@
   for i in $@; do
      gpg --encrypt --sign "$i.bundle.tar"
   done
}

# bundle and scrypt
sbundle() {
   bundle $@
   for i in $@; do
      echo "scrypting $i.bundle.tar:"
      scrypt enc "$i.bundle.tar" > "$i.bundle.tar.scrypt"
   done
}

# sbundle, then gbundle
sgbundle() {
   bundle $@
   for i in $@; do
      scrypt enc "$i.bundle.tar" > "$i.bundle.tar.scrypt"
      gpg --encrypt --sign "$i.bundle.tar.scrypt"
   done
}

# sbundle, then gbundle, then clean up the mess (mostly)
sgbundle_clean() {
   bundle $@
   for i in $@; do
      scrypt enc "$i.bundle.tar" > "$i.bundle.tar.scrypt"
      gpg --encrypt --sign "$i.bundle.tar.scrypt"
      echo "Cleaning $i.bundle.tar and $i.bundle.tar.scrypt"
      shred "$i.bundle.tar" "$i.bundle.tar.scrypt"
   done
}

# undo the bundle process, and check each file
unbundle() {
   green="2"
   red="1"
   bold="bold"
   hashes=(md5 sha1 sha224 sha256 sha384 sha512)
   bFile="$1"
   echo -e "$(tput setaf $green)$(tput $bold)Unbundling $bFile$(tput sgr 0)"
   bundleBasename=$(echo "$bFile" | perl -pe 's|(.*?\.bundle)\..*|\1|')
   rawBasename=$(echo "$bFile" | perl -pe 's|(.*?)\..*|\1|')
   echo "Transforming to $rawBasename"
   [ ! -n "$bundleBasename" ] && echo ".bundle not in file name!" && return 1
   currentDir=$(pwd)
   [ -d "$bundleBasename" ] && cd "$bundleBasename" || return 1
   for hash in $hashes; do
      RESULT=$(${hash}sum -c "$rawBasename.tar.gz.$hash" 2>&1)
      color=${red}
      echo $RESULT | grep -q OK$
      if [ $? = 0 ]; then
         color=${green}
      fi
      echo -e "$(tput setaf $color)$(tput $bold)${hash}sum for $rawBasename.tar.gz: ${RESULT}$(tput sgr 0)"
   done
   file "$rawBasename.tar.gz.asc" | grep -q "PGP signature"
   [ $? = 0 ] && gpgOut=$(gpg -v "$rawBasename.tar.gz.asc" 2>&1)
   echo -e ${gpgOut} | grep -q "Good signature"
   if [ $? = 0 ]; then
      color=${green}
   else
      color=${red}
   fi
   relevantOutput=$(echo -e "${gpgOut}" | grep "Signature made\|Good signature\|aka")
   echo -e "$(tput setaf $color)$(tput $bold)${relevantOutput}$(tput sgr 0)"
   rxtr "$rawBasename.tar.gz"
   [ -e "$rawBasename" ] && mv "$rawBasename" "$currentDir"
   cd "$currentDir"  
}


# Absurd directory shred command.  Mostly served to teach me some more zsh commands
dshred() {
   local startDir=$(pwd)
   local paranoia=""
   local obsecurdirs=""
   zparseopts -K -E -E p=paranoia -obsecuredirs=obsecurdirs
   for i in $@; do
      confirm=""
      if [ -d "$i" ]; then
         vared -p "Utterly destroy the contents of $i?" confirm
         [ "$confirm" = "yes" ] || return 1;
         if [ ! -n "$paranoia" ]; then
            find "$i" -type f -execdir shred -n 1 -u '{}' +
            [ -n "$obsecuredirs" ] && find "$i" -depth -regex '..+' -type d -execdir zsh -c 'mv "${0}" $(openssl rand -hex 64)' '{}' +
         else
            echo "overwriting data files with random data 7 times (paranoia mode)"
            find "$i" -type f -execdir shred -n 7 -u -z '{}' +
            local curDir=$(pwd)
            local newI=""
            for j in {1..7}; do
               echo "paranoia obfuscation round $j"
               cd "$i"
               find -depth -regex '..+' -type d -execdir zsh -c 'mv "${0}" $(openssl rand -hex 64)' '{}' +
               newI=$(openssl rand -hex 64)
               cd "$curDir"
               mv "$i" "$newI"
               i="$newI"
               sync
            done
         fi
         sync
         find "$i" -type d -delete
         confirm=""
      else
         echo "$i not a directory!"
         continue
      fi;
   done
}

# generalized secure remove command
srm() {
   local paranoia=""
   zparseopts -K -E -D \
      p=paranoia
   dirs=()
   files=()
   blocks=()
   for i in $@; do
      [ ! -w "$i" ] && continue
      [ -d "$i" ] && dirs[$(($#dirs + 1))]="$i"
      [ -f "$i" ] && files[$(($#files + 1))]="$i"
      [ -b "$i" ] && blocks[$(($#blocks + 1))]="$i"
   done
   for j in $files; do
      [ -n "$paranoia" ] && command shred --random-source=/dev/urandom -n 7 -z --verbose "$j"
      [ ! -n "$paranoia" ] && shred --quiet -u "$j"
   done
   for j in $dirs; do
      dshred "$j"
   done
   for j in $blocks; do
      shred --keep "$j"
   done
}

#for fasd
eval "$(fasd --init auto)"
# alias a='fasd -a'        # any
#alias s='fasd -si'       # show / search / select
#alias d='fasd -d'        # directory
#alias f='fasd -f'        # file
#alias sd='fasd -sid'     # interactive directory selection
#alias sf='fasd -sif'     # interactive file selection
# alias z='fasd_cd -d'     # cd, same functionality as j in autojump
# alias zz='fasd_cd -d -i' # cd with interactive selection

# For generalized system update: don't forget git packages!
update-system() {
   bb-wrapper --aur -Syu --devel
}

bindkey "^R" history-incremental-search-backward

export WORKON_HOME="$HOME/virtualenvs"
export PYTHON_PATH="."
source $(which virtualenvwrapper.sh)

# if [[ -z "$TMUX" ]] ;then
#     ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
#     if [[ -z "$ID" ]] ;then # if not available create a new one
#         tmux new-session
#     else
#         tmux attach-session -t "$ID" # if available attach to it
#     fi
#     exit
# fi

export MAKEFLAGS=$(( $(nproc) + 1 ))

bindkey '\C-x\C-e' edit-command-line
setopt autopushd
setopt pushdignoredups

autoload -U compinit && compinit
zstyle ':completion:*' menu select=5
zstyle ':completion:*' group-name ''
setopt menu_complete
# format all messages not formatted in bold prefixed with ----
zstyle ':completion:*' format '%B---- %B%d%H%h%b'
# format descriptions (notice the vt100 escapes)
#zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
# bold and underline normal messages
#zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
# format in bold red error messages
#zstyle ':completion:*:warnings' format "%B$fg[red]%}---- no match for: $fg[white]%d%b"
# activate approximate completion, but only after regular completion (_complete)
#zstyle ':completion:::::' completer _complete _approximate

# # Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi
