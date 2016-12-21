#!/bin/bash

./script1.bash mechani.se /unix/public/cw4.html > links_db2
touch links_visited

while read line ; do
  domain=$(echo $line | awk '{print $3}')
  path=$(echo $line | awk '{print $4}')


  if [[ $path == *".html" ]] ; then
    grep -q "$domain $path" links_visited
    if [[ $? != 0 ]]  ; then
      if [[ $path != *"private"* ]] ; then
        $(./script1.bash "$domain" "$path" >> links_db2)
        cat links_db2 >> log

        #echo "----------------------------------" >> log
        #echo "DOMAIN: $domain" >> log
        #echo "PATH:   $path" >> log
        #echo "LINE:   $line" >> log
        #echo "----------------------------------" >> log
        echo $domain $path >> links_visited
      fi
    fi
  fi
done < links_db2

sort links_db2 | uniq >> links_sorted
rm anchors ; rm links_db1 ; rm links_db2 ; rm links_visited
mv links_sorted result
