#!/usr/bin/env zsh
# -*- encoding UTF-8 -*-
repoName="config"
super=false
install_config() {
   local target=${HOME}
   local exclude=""
   local super=false
   zparseopts -K -E -D \
      t:=target -target:=target \
      e:=exclude -exclude:=exclude \
      s:=super -super:=super
   target=("${(s/--target /)target}")
   target=$target[2]
   excludeArray=(${=exclude})
   excludeArray=("${(s/:/)excludeArray[2]}")
   cd ${target} || return 1
   setopt globdots
   for file in ${HOME}/${repoName}/root/${target}/*; do
      excludeNumber=${excludeArray[(i)$(basename $file)]}
      if [ ${excludeNumber} -le ${#excludeArray} ]; then
         echo "Skipping $file" && continue
      fi
      echo "installing ${file}"
      j=${target}/$(basename ${file})
      [[ -a ${j} ]] && [[ ! -h ${j} ]] && mv ${j} ${j}.$(date +%s).old && echo ${j}: backed up
      [[ ! -h ${j} ]] && ln -s -r ${file} . && echo ${file}: link created
   done
   cd /
}
install_config --target "${HOME}" --exclude ".config:.ssh"
install_config --target "${HOME}/.ssh"
install_config --target "${HOME}/.config"
