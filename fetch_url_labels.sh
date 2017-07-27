#!/bin/bash
urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
for url in $(cat $1); do
    acro=$(echo "$url" | awk -F'/' '{print $5}'| cut -d'?' -f1)
    durl=$(echo "$url" | cut -d'=' -f3)
    durl=$(urldecode $durl)
    #echo "Processing $durl from $acro"
    ./extract_terms.sh $durl $acro 2> /dev/null
done
