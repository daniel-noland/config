#!/usr/bin/zsh
set -o nounset                              # Treat unset variables as an error

# function to convert human readable size values to bytes.
# source:
# http://stackoverflow.com/questions/26621647/convert-human-readable-to-bytes-in-bash
dehumanise() {
  for v in "$@"
  do
    echo $v | awk \
      'BEGIN{IGNORECASE = 1}
       function printpower(n,b,p) {printf "%u\n", n*b^p; next}
       /[0-9]$/{print $1;next};
       /K(iB)?$/{printpower($1,  2, 10)};
       /M(iB)?$/{printpower($1,  2, 20)};
       /G(iB)?$/{printpower($1,  2, 30)};
       /T(iB)?$/{printpower($1,  2, 40)};
       /KB$/{    printpower($1, 10,  3)};
       /MB$/{    printpower($1, 10,  6)};
       /GB$/{    printpower($1, 10,  9)};
       /TB$/{    printpower($1, 10, 12)}'
  done
}

random_seed() {

   dd if=/dev/random
}
