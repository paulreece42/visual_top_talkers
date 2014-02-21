#!/bin/bash

. $PREFIX/config

j=0
step=300
output_in="/tmp/in.txt"
output_out="/tmp/out.txt"

rm -rf $output_in
rm -rf $output_out

RESULT_OUT=`psql -U pmacct -t -c "SELECT SUM(bytes) * 8 FROM $MY_TABLE WHERE as_dst = $1 AND as_src = $MY_ASN GROUP BY stamp_inserted ORDER BY stamp_inserted LIMIT 2016;"`
RESULT_IN=`psql -U pmacct -t -c "SELECT SUM(bytes) * 8 FROM $MY_TABLE WHERE as_src = $1 AND as_dst= $MY_ASN GROUP BY stamp_inserted ORDER BY stamp_inserted LIMIT 2016;"`

j=0
for i in $RESULT_IN
do
  echo $j $i >> $output_in
  let j+=$step
done

j=0
for i in $RESULT_OUT
do
  echo $j $i >> $output_out
  let j+=$step
done

