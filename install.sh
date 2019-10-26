#!/usr/bin/env bash
# shellcheck disable=SC2059
set -eo pipefail

info()
{
  printf "➜ %s\n" "$@"
}

success()
{
  printf "✔ %s\n" "$@"
}

error()
{
  printf "✖ %s\n" "$@"
}

readonly TEX_DIR="/home/$USER/texmf/tex/latex"

function convert_eps_files()
{
  local exit_status
  if [ -e eps2pdf.sh ]; then
    bash -c "./eps2pdf.sh"
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      error "Failed to convert eps to pdf"
      exit 2;
    fi
  else
    error "File eps2pdf.sh is missing. Did you clone the repository properly?"
    exit 1;
  fi
}

function copy_files()
{
  mkdir -p "$TEX_DIR"
  if command -v rsync >&/dev/null; then
    info "Copying files to  ${TEX_DIR}/europass-cv..."
    rsync -Ea --recursive --exclude='*.md*' \
      --exclude='*.MD*' \
      --exclude='*.git*' \
      --exclude='*.gitignore' \
      --exclude='*.sh' \
      --exclude='*.eps' \
      --exclude='*.yml' \
      --exclude='.dependabot' \
      --exclude='.github' \
      --exclude='templates' \
      --exclude europass-cv-compact.cls \
      ./ "${TEX_DIR}/europass-cv" && success "Copied Files"
    info "Copying files to  ${TEX_DIR}/europass-cv-compact..."
    rsync -Ea --recursive --exclude='*.md*' \
      --exclude='*.MD*' \
      --exclude='*.git*' \
      --exclude='*.gitignore' \
      --exclude='*.sh' \
      --exclude='*.eps' \
      --exclude='*.yml' \
      --exclude='.dependabot' \
      --exclude='.github' \
      --exclude europass-cv.cls \
      --exclude europass-cv.cls ./ "${TEX_DIR}/europass-cv-compact" && success "Copied Files"

  else

    error "Program rsync is not installed. Please install rsync"
    errot "This script requires rsync."
    exit 1
  fi
}

function  change_branch()
{
  if [ $# -eq 0 ]; then
    info "No arguments found. Chosing current branch."
  else
    info "Chosing branch: ${1}"
    git checkout "$1" && success "Done"
  fi
}

function main ()
{
  change_branch "$@"
  convert_eps_files
  copy_files
  success "Updating Texhash $TEX_DIR"
  info "Removing generated PDF files..."
  rm -f *converted-to.pdf
}

main "$@"
