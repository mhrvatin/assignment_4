#!/bin/bash

function clean_up() {
  rm -f anchors
  rm -f links_db1
}

function resolve_relative_paths() {
  local target_path=$(echo "$anchor_element" | sed -e 's!\(/.*/\).*!\1!')
  local _source_path=$(echo "$source_path" | sed -e 's!\(/.*/\).*!\1!')

  #echo "target_path $target_path"
  #echo "_source_path $_source_path"
  #echo "anchor_element $anchor_element"

  while [[ $anchor_element == "../"* ]] ; do 
    #echo "../ exists"
    _source_path=$(echo "$_source_path" | sed -e 's!\(.*/\).*/!\1!')
    anchor_element=$(echo "$anchor_element" | sed -e 's!\.\./\(.*\)!\1!')
  done

  if [[ $target_path != $_source_path ]] ; then
    #echo "target path != _source_path"
    if [[ $target_path != "/"* ]] ; then
      #echo "target_path != /*"
      anchor_element="$_source_path$anchor_element"
    fi
  fi

  #echo "--------------------------------------"
}

function printLinks() {
  anchor_element="$1"
  resolve_relative_paths

	if [[ $anchor_element != *"http"* ]] ; then
    echo "$2 $3 $2 $anchor_element" >> links_db1
  fi
}

source_domain=$1
source_path=$2
curl='/usr/bin/curl'
rvmhttp="$source_domain$source_path"
curlargs="-s -S -k"
output="$($curl $curlargs $rvmhttp)"
clean_up
touch anchors
touch links_db1

while read line ; do
  if grep -q "<a href" <<< $line ; then
    raw_anchor_element=$(echo "$line" | grep -o '<a href="\([^"]*\)"')
    anchor_element=$(echo "$raw_anchor_element" | sed 's!.*"\([^"]*\)".*!\1!')
    #echo "r_ae $raw_anchor_element"
    #echo "-----------------------------"
    #echo "ae $anchor_element"
    #echo "-----------------------------"

    echo "$anchor_element" >> anchors
  fi
done <<< "$output"

tmp=$(grep -v "\(mailto\|ftp\)" anchors)
if [[ $? == 0 ]] ; then
  while read line ; do
    printLinks $line $source_domain $source_path
  done <<< "$tmp"
fi

sort links_db1 | uniq >> links_sorted
rm -f links_db1
mv links_sorted links_db1

cat links_db1
