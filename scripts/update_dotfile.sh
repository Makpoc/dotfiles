#!/bin/bash

function echoerr () {
  echo "$@" >&2
}

function check_exit() {
  if [[ $1 != 0 ]]; then
    echoerr "Command failed. Exiting"
    exit 1
  fi
}

function backup_file() {
  bckp_file=${1}_bckp
  cp ${1} $bckp_file
  check_exit $?
  echoerr "File backup stored at ${bckp_file}"
}

file=$1
dotfile=$2

if [[ -z $file  ]] || [[ -z $dotfile ]]; then
  echoerr "usage: $(basename $0) <file> <dotfile>"
  exit 1
fi

backup_file $file

cp $file $dotfile
check_exit $?

ln -f -s $dotfile $file
check_exit $?

echoerr ls -l $file
echo "$file" >> "$dotfile"
update_dotfile.sh
