#!/usr/bin/env zsh
# -*- encoding UTF-8 -*-

file=${1}

STARTSSL="http://www.startssl.com/timestamp"
SAFE_CREATIVE="http://tsa.safecreative.org"
COMODOCA="http://timestamp.comodoca.com/authenticode"
STARFIELDTECH="http://tsa.starfieldtech.com"

openssl ts -query -data ${file} | tsget -h ${STARTSSL} -o ${1}.startssl.tsr
openssl ts -query -data ${file} | tsget -h ${SAFE_CREATIVE} -o ${1}.safe_creative.tsr
# openssl ts -query -data ${file} | tsget -h ${COMODOCA} -o ${1}.comodoca.tsr
openssl ts -query -data ${file} | tsget -h ${STARFIELDTECH} -o ${1}.starfieldtech.tsr
