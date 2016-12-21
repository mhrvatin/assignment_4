#!/bin/bash

./script1.bash mechani.se /unix/public/cw4a.html > links_db2
touch links_visited
cp links_db2 links_db_tmp

while read line ; do
  domain=$(echo $line | awk '{print $3}')
  path=$(echo $line | awk '{print $4}')

  if [[ $path == *".html" ]] ; then
    grep -q "$domain $path" links_visited
    if [[ $? != 0 ]]  ; then
      $(./script1.bash "$domain" "$path" >> links_db_tmp)
      echo $domain $path >> links_visited
    fi
  fi
done < links_db2

sort links_db_tmp | uniq >> links_sorted
rm anchors ; rm links_db1 ; rm links_db2 ; rm links_db_tmp ; rm links_visited
mv links_sorted result
