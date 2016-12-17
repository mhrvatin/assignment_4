#!/bin/bash

domain=''
path=''


#TODO: Make some kind of list so we can check what paths that have been crawled (so it's not crawled twice)
#while loop for getting every domain and path in the links_database file

while read line ; do
	domain=$(echo "$line" | awk '{print $1}')
	path=$(echo "$line" | awk '{print $4}')
	
	$(./script1.bash $domain $path)

done < links_database

