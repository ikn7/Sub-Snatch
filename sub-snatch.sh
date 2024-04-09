#!/bin/bash

echo -e "\033[31m _____       _           _____             _       _ \033[0m"
echo -e "\033[31m/  ___|     | |         /  ___|           | |     | |\033[0m"
echo -e "\033[31m\ \`--. _   _| |__ ______\ \`--. _ __   __ _| |_ ___| |__\033[0m"
echo -e "\033[31m \`--. \ | | | '_ \______|\`--. \ '_ \ / _\` | __/ __| '_ \ \033[0m"
echo -e "\033[31m/\__/ / |_| | |_) |     /\__/ / | | | (_| | || (__| | | |\033[0m"
echo -e "\033[31m\____/ \__,_|_.__/      \____/|_| |_|\__,_|\__\___|_| |_|\033[0m"
echo -e "\nBy: Ism8el (https://github.com/ism8el)\n"

# Check if a domain name or file was specified as input
if [ -z "$1" ]; then
  echo "Usage: $0 <domain|file>"
  exit 1
fi

# Check if the entry is a file or a domain name
if [ -f "$1" ]; then
  # Input is a file, read domain list from file
  while read -r domain; do
    # Find the CNAME record of the specified domain
    cname=$(dig +short CNAME "$domain")

    # Check if a CNAME record was found
    if [ -z "$cname" ]; then
      # No CNAME found, display error message in red
      echo -e "\033[31m[NO CNAME]\033[0m - $domain"
    else
      # CNAME found, display success message in green
      echo -e "\033[32m[CNAME FOUND]\033[0m - $domain --> $cname"
      new=$(echo "$cname" | sed 's/\.$//' | awk -F. '{if (NF>1) {print $(NF-1)"."$NF}}' )
      whois "$new" | grep -i "NOT FOUND" && echo -e "\034[m[VULN]\033[0m - CNAME $new available for purchase" || echo -e "\033[33m[+]\033[0m - CNAME $new unavailable for purchase" 
    fi
  done < "$1"
else
  # The entry is a domain name, check the CNAME record of the specified domain
  cname=$(dig +short CNAME "$1")

  # Check if a CNAME record was found
  if [ -z "$cname" ]; then
    # No CNAME found, display error message in red
    echo -e "\033[31m[NO CNAME]\033[0m - $1\033"
  else
    # CNAME found, display success message in green
    echo -e "\033[32m[CNAME FOUND]\033[0m - $1 --> $cname"
    new=$(echo "$cname" | sed 's/\.$//' | awk -F. '{if (NF>1) {print $(NF-1)"."$NF}}' )
    whois "$new" | grep -i "NOT FOUND" && echo -e "\034[m[VULN]\033[0m - CNAME $new available for purchase" || echo -e "\033[33m[+]\033[0m - CNAME $new unavailable for purchase" 
  fi
fi
