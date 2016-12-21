#!/bin/bash

./script1.bash mechani.se /unix/public/cw4.html > links_db2
touch links_visited
touch links_db2

while read line ; do
  domain=$(echo $line | awk '{print $3}')
  path=$(echo $line | awk '{print $4}')

  grep -q "$domain $path" links_visited
  if [[ $? != 0 ]]  ; then
    $(./script1.bash "$domain" "$path" >> links_db2)
    rm -f anchors
    rm -f links_db1
    
    echo $domain $path >> links_visited

    sort links_db2 | uniq >> links_sorted
    #rm links_db2
    mv links_sorted result
  fi
done < links_db2

#rm links_visited
