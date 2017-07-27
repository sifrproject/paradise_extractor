#!/bin/bash

for i in $(ls -1 *_urls.txt); do
    name=$(echo $i | cut -d'_' -f1)
    ./fetch_url_labels.sh $i | tr '[:upper:]' '[:lower:]' | sort | uniq > "$name"_labels.txt
done
