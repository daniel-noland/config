#!/usr/bin/env bash

# make sure number of input params is correct
if [ $# -neq 1 ]
then
   echo "Takes only one tex file";
   exit 1;
fi
#define latex compiler
texCC="colorpdflatex"
# define latex compiler args
texCCArgs="-shell-escape"
#define bibtex command
bib=bibtex
#define sage command
sage=sage
#define latex file to be compiled (strip tex suffix)
texFile=$(basename $1 .tex)
#define generated sage file
sageFile="$texFile.sagetex.sage"
#define makeglossaries command
makegloss="makeglossaries"
#compile document
#$tex $texFile && $sage $sageFile && $tex $texFile && $bib $texFile && $tex $texFile && $tex $texFile
tex="$texCC $texCCArgs"
$tex $texFile && $tex $texFile && $bib $texFile && $makegloss $texFile && $bib $texFile && $tex $texFile && $tex $texFile
echo "compile complete"
