#!/bin/bash
TMP=/tmp/dirtree.$PPID
TMP2=/tmp/dirtree.$PPID.dot
echo "digraph{" >$TMP2
cat result >$TMP
cat $TMP | awk '{print $4}' | sed -e 's!\(.*\)!"\1" [label="\1"];!' >>$TMP2
cat $TMP | awk '{print $2,$4}' | sed -e 's!\(.*\) \(.*\)!"\1" -> "\2"!' >>$TMP2
echo "}" >>$TMP2
dot -Tpdf -oresult.pdf $TMP2
