#!/bin/bash

#Declaring of functions

function clean_up() {
  $(rm anchors)
  $(rm links_db1)
}

function removeDotDot()
{
	if [[ $1 == "../"* ]] ; then
		path=$(echo $1 | awk '{print substr($0,4)}' )
    removeDotDot $path
	fi
}

function printLinks()  
{
  removeDotDot $1
  local full_output="$2 $3"
  #local path=$(echo "$3" | sed -e 's!\(/.*/\).*!\1!')
  #local file=$(echo "$1" | sed -e 's!.*\(/.*/\)\(.*\)!\2!')

	if [[ $1 != *"http"* ]] ; then
    local external_domain="$2"

		if [[ $1 != /* ]] ; then
      #full_output+=" $external_domain $path$file"
      full_output+=" $external_domain $path"
		fi

		if [[ $1 == /* ]] ; then
      #full_output+=" $external_domain $path$file"
      full_output+=" $external_domain $path"
		fi
  else
    external_domain="" # parse external domain from string
  fi

  $(echo "$full_output" >> links_db1)
}

domain=$1
path=$2
curl='/usr/bin/curl'
rvmhttp="$domain$path"
curlargs="-s -S -k"
output="$($curl $curlargs $rvmhttp)"

while read line ; do
  if grep -q "<a" <<< $line ; then
    if grep -q "href" <<< $line ; then
      anchor_element=$(echo "$line" | sed 's/.*"\([^"]*\)".*/\1/')
      $(echo "$anchor_element" >> anchors)

		if [[ $anchor_element != mailto*  ]] ; then	# TEMPORARY SOLUTION TO GET RID OF MAILTO
			printLinks $anchor_element $domain $path     
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
