#!/bin/bash
#
# Visual Top Talkers
#
# Proof of concept, run in production at own risk! 
#
# Runs on top of pmacct with pgsql plugin. I [highly] recommend 
# partitoning the tables using pg_partman or something else, unless
# you like filled disks and cronjobs stacking on themselves
#
# Author: Paul Reece
# paul@reece.cc
# http://github.com/paulreece42
#

# Where am I installed? All other values set in $PREFIX/config
PREFIX=/opt/top_talkers

. $PREFIX/config

TOP_TALKERS=`psql -U pmacct -t -c "CREATE TEMPORARY TABLE tt_temp AS \
    SELECT SUM(bytes),as_src AS asn \
    FROM $MY_TABLE \
    WHERE stamp_inserted BETWEEN LOCALTIMESTAMP - INTERVAL '7 days' AND LOCALTIMESTAMP AND as_src != $MY_ASN \
    GROUP BY as_src \
    ORDER BY sum DESC \
    LIMIT $NUM_TT; \
INSERT INTO tt_temp \
    SELECT SUM(bytes),as_dst AS asn \
    FROM $MY_TABLE \
    WHERE stamp_inserted BETWEEN LOCALTIMESTAMP - INTERVAL '7 days' AND LOCALTIMESTAMP \
    GROUP BY as_dst \
    ORDER BY sum DESC \
    LIMIT $NUM_TT; \
CREATE TEMPORARY TABLE tt_temp_2 AS \
    SELECT SUM(sum),asn \
    FROM tt_temp \
    GROUP BY asn \
    ORDER BY sum DESC \
    LIMIT $NUM_TT; \
SELECT asn FROM tt_temp_2 WHERE asn != 0;"`

cd $PREFIX

# One day I'll re-code this using Bootstrap and some fancy pants
# web framework that completely wrecks my database schema using ORM and 
# makes everything slow to a crawl... but ever so pretty.
#
# Until that day, please deal with my hacky, horrifically non-compliant HTML
#
echo "<div align='center'>" > $HTML_PATH/index.html

for ASN in $TOP_TALKERS
do
    # Look up using the data from ARIN or Potaroo
    # You can also pull this from Team Cymru via DNS with dig,
    # I just happened to already have it in the DB
    AS_NAME=`psql -U postgres -t -d pmacct -c "SELECT as_name FROM asn_info WHERE as_number = $ASN;"`

    PREFIX=$PREFIX $PREFIX/graph_asn.sh $ASN

    # Hacky hack hack. I said it was a proof of concept :P
    rm -f /tmp/graph.script    
    sed s~AS_SEDME~"$AS_NAME"~g $PREFIX/last_week.script > /tmp/graph.script
    gnuplot /tmp/graph.script $ASN > $HTML_PATH/$ASN.png

    echo "<img src=\"$ASN.png\" /><br>" >> $HTML_PATH/index.html
done

echo "</div>" >> $HTML_PATH/index.html


