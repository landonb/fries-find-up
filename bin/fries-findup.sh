#!/bin/bash
# vim:tw=0:ts=2:sw=2:et:ft=sh:

VERSION=0.0.1

print_version_and_exit () {
  # NOTE: If sourced and called, then $(basename -- $0) is 'bash'.
  >&2 echo "fries-findup version ${VERSION}"
  exit 0
}

print_help_and_exit () {
  >&2 echo "Usage: fries-findup [-v|--version] [-h|--help] <name>"
  >&2 echo "See \`man fries-findup\` for more help"
  #>&2 echo ""
  exit 0
}

parse_args () {
  local filepath=""
  local skip_opts=false
  while [[ "$1" != "" ]]; do
    if [[ "$1" == '--' ]]; then
      skip_opts=true
      shift
      continue
    elif ! ${skip_opts}; then
      case $1 in
        -v)
          print_version_and_exit
          ;;
        --version)
          print_version_and_exit
          ;;
        -h)
          print_help_and_exit
          ;;
        --help)
          print_help_and_exit
          ;;
      esac
    fi
    if [[ -n ${filepath} ]]; then
      >&2 echo 'Please specify only 1 name'
      exit 2
    fi
    filepath=$1
    shift
  done
  if [[ -z ${filepath} ]]; then
    >&2 echo 'ERROR: Please specify a file.'
    exit 2
  fi
  echo "${filepath}"
}

# Walk up the path looking for a file with the matching name.
fries-findup () {
  # We want the return value of the subshell, and not the `local`
  # operator, so split the two operations.
  local filepath; filepath=$(parse_args "${@}") || return $?
  [[ -z ${filepath} ]] && return # Only if -v|--version.

  local filename=$(basename -- "${filepath}")
  local dirpath=$(dirname -- "${filepath}")

  # Deal only in full paths.
  # Symlinks okay (hence not `pwd -P` or `readlink -f`).
  pushd ${dirpath} &> /dev/null
  dirpath=$(pwd)
  popd &> /dev/null

  # "Invursive path", i.e., opposite of recursive find.
  local invursive_path=''
  # We don't return things from file system root. Because safer?
  while [[ ${dirpath} != '/' ]]; do
    # FIXME/2018-02-07: Add option to find just file, or just dir?
    # E.g.,
    #   if [[ ! ${files_only} || -f ${dirpath}/${filename} ]]; then ... fi
    if [[ -e ${dirpath}/${filename} ]]; then
      invursive_path="${dirpath}/${filename}"
      break
    fi
    dirpath=$(dirname -- "${dirpath}")
  done

  # Here's how chruby/auto.sh does the same:
  #   local dir="$PWD/"
  #   until [[ -z "$dir" ]]; do
  #       dir="${dir%/*}"
  #       if ... fi
  #   done

  if [[ -n "${invursive_path}" ]]; then
    echo "${invursive_path}"
    return 0
  else
    return 1
  fi
}

main () {
  if [[ ${BASH_SOURCE[0]} != $0 ]]; then
    export -f fries-findup
  else
    fries-findup "${@}"
  fi
}

main "${@}"

