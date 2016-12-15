#!/bin/bash

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

      if $(cat anchors | grep -q "\.html$") ; then
        echo "html-file found"
        $(echo $(cat anchors | grep "\.html$") > links)
      fi
    fi
  fi

done <<< "$output"

$(cat links | tr [:space:] '\\n')
