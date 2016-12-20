#!/bin/bash

function clean_up() {
  $(rm anchors)
  $(rm links_db1)
}

function resolve_relative_paths() {
  local target_path=$(echo "$anchor_element" | sed -e 's!\(/.*/\).*!\1!')
  local _source_path=$(echo "$source_path" | sed -e 's!\(/.*/\).*!\1!')

  while [[ $anchor_element == "../"* ]] ; do 
    _source_path=$(echo "$_source_path" | sed -e 's!\(.*/\).*/!\1!')
    anchor_element=$(echo $anchor_element | sed -e 's!\.\./\(.*\)!\1!')
  done

  if [[ $target_path != $_source_path ]] ; then
    anchor_element="$_source_path$anchor_element"
  fi
}

function printLinks() {
  resolve_relative_paths
  local full_output="$2 $3"

	if [[ $1 != *"http"* ]] ; then
    local external_domain="$2"

    full_output+=" $external_domain $anchor_element"
  else
    #TODO parse external domain from string
    external_domain="" 
  fi

  $(echo "$full_output" >> links_db1)
}

source_domain=$1
source_path=$2
curl='/usr/bin/curl'
rvmhttp="$source_domain$source_path"
curlargs="-s -S -k"
output="$($curl $curlargs $rvmhttp)"

while read line ; do
  if grep -q "<a" <<< $line ; then
    if grep -q "href" <<< $line ; then
      anchor_element=$(echo "$line" | sed 's/.*"\([^"]*\)".*/\1/')
      $(echo "$anchor_element" >> anchors)

		if [[ $anchor_element != mailto*  ]] ; then	# TODO TEMPORARY SOLUTION TO GET RID OF MAILTO
			printLinks $anchor_element $source_domain $source_path     
		fi	
    fi
  fi
done <<< "$output"

$(sort links_db1 | uniq >> links_sorted)
$(rm links_db1)
$(mv links_sorted links_db1)

links_db=$(cat links_db1)
echo "$links_db"

#clean_up
