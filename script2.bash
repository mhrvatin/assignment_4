#!/bin/bash

./script1.bash mechani.se /unix/public/cw4a.html > links_db2
$(touch links_visited)

while read line ; do
  #echo "CRAWLING $line"
  domain=$(echo $line | awk '{print $3}')
  path=$(echo $line | awk '{print $4}')

  if grep -q "$domain $path" links_visited ; then
    echo "already visited link: $domain $path"
  else
    echo "DOMAIN: $domain"
    echo "PATH: $path"
    ./script1.bash "$domain" "$path" >> links_db2
    
    $(echo $domain $path >> links_visited)

    $(sort links_db2 | uniq >> links_sorted)
    $(rm links_db2)
    $(mv links_sorted links_db2)
  fi
done < links_db2
