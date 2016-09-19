#!/bin/bash -
set -o nounset                              # Treat unset variables as an error

keybase login || exit 1
kbfsfuse "${HOME}/keybase"
