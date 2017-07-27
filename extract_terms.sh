#!/bin/bash

urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

CLASS_URL=$(urlencode $1)

class=$(curl -H'Authorization:apikey token=907d47d9-3a00-4aa7-9111-090112dfab6a' http://data.bioportal.lirmm.fr/ontologies/$2/classes/$CLASS_URL)

#echo "curl -H'Authorization:apikey token=907d47d9-3a00-4aa7-9111-090112dfab6a' http://data.bioportal.lirmm.fr/ontologies/$2/classes/$CLASS_URL"

descendents=$(curl -H'Authorization:apikey token=907d47d9-3a00-4aa7-9111-090112dfab6a' http://data.bioportal.lirmm.fr/ontologies/$2/classes/$CLASS_URL/descendants)


prefLabels=$(echo $descendents |  jq ".collection[].prefLabel")
synonyms=$(echo $descendents | jq ".collection[].synonym[]")
classpl=$(echo $class | jq ".prefLabel")
classs=$(echo $class | jq ".synonym[]")
#echo $descendents | jq
#echo "Labels $prefLabels"
#echo "Synonyms $synonyms"


final=$(echo $prefLabels $synonyms $classpl $classs |  perl -pe 's/" "/\n/g' | perl -pe 's/"//g' | perl -pe 's/null//g' |sort | uniq )
echo "$final" 

