#!/bin/bash
set -o nounset                              # Treat unset variables as an error

hashit() {
   input="${1}"
   output="${1}.omnihash"
   outputDir=$(dirname "${input}")

   # Check to make sure this is possible
   [[ -e "${output}" ]] && echo "${output} exists, will not overwrite" && return 1
   [[ -d "${input}" ]] && echo "${input} is a directory.  Will not hash!" && return 1
   [[ ! -f "${input}" ]] && echo "${input} not a regular file.  Will not hash!" && return 1
   [[ ! -r "${input}" ]] && echo "${input} has no read permissions!  Can not hash!" && return 1
   [[ ! -w "${outputDir}" ]] && echo "${outputDir} not writeable.  Can not place ${output}" && return 1

   omnihash "${input}" > "${output}"
}

validateit() {
   echo "Validating"
   input1="${1}"
   input2="${1}.omnihash"

   # Check to make sure this is possible
   [[ ! -e "${input1}" ]] && echo "${output} does not exist, can not check" && return 1
   [[ ! -e "${input2}" ]] && echo "${output} does not exist, can not check" && return 1
   [[ -d "${input1}" ]] && echo "${input} is a directory.  Will not hash!" && return 1
   [[ ! -f "${input1}" ]] && echo "${input} not a regular file.  Will not hash!" && return 1
   [[ ! -f "${input2}" ]] && echo "${input} not a regular file.  Will not hash!" && return 1
   [[ ! -f "${input1}" ]] && echo "${input} not a regular file.  Will not hash!" && return 1
   [[ ! -f "${input2}" ]] && echo "${input} not a regular file.  Will not hash!" && return 1
   [[ ! -r "${input1}" ]] && echo "${input} has no read permissions!  Can not hash!" && return 1
   [[ ! -r "${input2}" ]] && echo "${input} has no read permissions!  Can not hash!" && return 1
   echo "Observed:    |     Provided:"
   colordiff -y <(omnihash "${input1}") "${input2}"
   if [ $? -ne 0 ]; then
      echo "Hashes differ!"
      return 1
   else
      echo "Hashes match!"
      return 0
   fi
}

if [ "${1}" = "-h" ]; then
   hashit "${2}"
else
   validateit "${2}"
fi

