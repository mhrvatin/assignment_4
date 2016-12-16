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
	
	echo "Links to work with $1"	
	

	# 
	if [[ $1 != *"http"* ]] ; then

		if [[ $1 != /* ]] ; then
			#echo "Not starting with a slash, adding a a slash" DEBUGGING ONLY
			echo "$2/$1"
		fi

		if [[ $1 == /* ]] ; then
			#echo "Already got a slash, no need to add another" DEBUGGING ONLY
			echo "$2$1"

		fi
		
		#echo "Found a ingoing link: $1i" DEBUGGING ONLY
		#echo "Adding domain.." DEBUGGING ONLY
		#echo "$2$1" DEBBUGING ONLY

	
	fi	
}

domain=$1
path=$2
curl='/usr/bin/curl'
rvmhttp="$domain$path"
curlargs="-s -S -k"
output="$($curl $curlargs $rvmhttp)"
anchor_element=""

$(rm anchors)
$(rm links)


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




