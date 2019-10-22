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

info "Converting eps files to pdf..."
info "Removing Existing pdf files."

rm -f ic_*.pdf

count_files=0
count_files=$(find . -maxdepth 1 -type f -name "*.eps" -exec printf x \; | wc -c)

if [[ $count_files = "0" ]]; then
  error "No eps files found."
  exit 1;
else
  success "$count_files EPS files Found"
fi
index=1
if command -v epstopdf >&/dev/null; then
  for file in *.eps;
  do
    file_name=$(echo "$file" | cut -d '.' -f1 )
    info "Converting File $index : ${file}"
    epstopdf "$file" --outfile "$file_name"-eps-converted-to.pdf
  	index=$((index + 1))
  done
else
  error "Program epspdf is not installed.";
  exit 1;
fi
unset index count_files
