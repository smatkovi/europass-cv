#!/usr/bin/env bash
# shellcheck disable=SC2059
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 6)
NC=$(tput sgr 0)
printf "${BLUE}Converting eps files to pdf...${NC}\n"
printf "${BLUE}Removing Existing pdf files.${NC}\n"
rm -f ic_*.pdf
count_files=0
count_files=$(find . -maxdepth 1 -type f -name "*.eps" -exec printf x \; | wc -c)
printf "${BLUE}$count_files${NC} EPS files Found\n"

if [[ $count_files = "0" ]]; then
  printf "${YELLOW}No eps files found.\n${NC}"
  exit 1;
fi
index=1
if command -v epstopdf >&/dev/null; then
  for file in *.eps;
  do
    file_name=$(echo "$file" | cut -d '.' -f1 )
    printf "Converting File $index : ${BLUE}${file}${NC} \n"
    epstopdf "$file" --outfile "$file_name"-eps-converted-to.pdf
  	index=$((index + 1))
  done
else
  printf "${YELLOW}Program epspdf is not installed.\n${NC}";
  exit 1;
fi
unset index count_files
