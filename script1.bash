#!/bin/bash

#Declaring of functions

function removeDotDot()
{
	if [[ $1 == ..* ]] ; then
		$1 = $(echo $1 | awk{print substr($0,3)})
	fi

}

function printLinks()  
{
	
	#echo "Links to work with $1"	
  #echo "\$1 is: $1"
  #echo "\$2 is: $2"
  #echo "\$3 is: $3"
  full_output="$2 $3"
  _path=$(echo "$3" | sed -e 's!\(/.*/\).*!\1!')
  _file=$(echo "$1" | sed -e 's!.*\(/.*/\)\(.*\)!\2!')

	if [[ $1 != *"http"* ]] ; then
    external_domain="$2"

		if [[ $1 != /* ]] ; then

      full_output+=" $external_domain $_path$_file"
		fi

		if [[ $1 == /* ]] ; then
      full_output+=" $external_domain $_path$_file"
		fi
  else
    external_domain="" # parse external domain from string
  fi

  #echo "$full_output"
  $(echo "$full_output" >> links_database)
  #echo "-------------------------"
}

domain=$1
path=$2
curl='/usr/bin/curl'
rvmhttp="$domain$path"
curlargs="-s -S -k"
output="$($curl $curlargs $rvmhttp)"
anchor_element=""

$(rm anchors)
$(rm links_database)

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

# TODO fix sorting!
$(sort links_database | uniq >> links_sorted)
$(rm links_database)
$(mv links_sorted links_database)
#echo $(cat links_database)
