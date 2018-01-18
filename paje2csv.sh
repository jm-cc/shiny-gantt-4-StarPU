#!/bin/sh
TMPDIR=/tmp

#Usage
if [ "$#" -ne 2 ]; then
  echo "usage: $0 <paje_input_file> <output_prefix>"
  echo
  echo "Takes a <paje_input_file> and generate a ordered paje trace, a csv trace and a .sched file with nsubmitted/nready events."
  echo
  echo "Files are named <output_prefix>.paje, <output_prefix>.csv and <output_prefix>.sched."
  echo "pj_dump must be available. (see : https://github.com/schnorr/pajeng)"
  exit
fi

#Recover useful lines (headers & events)
awk '{ if ($1==3 && $2~/Ctx/) print $1"       "$2"    W       "$4; else if ($1<8 || $1~/%/) print $0}' $1 > $TMPDIR/header.$$
grep "^10\s" $1 > $TMPDIR/events.$$

#Generate the trace with event in chronological order
sort $TMPDIR/events.$$ -nk2 > $TMPDIR/sorted_events.$$
cat $TMPDIR/header.$$ $TMPDIR/sorted_events.$$ > $2.paje

#Collect nsubmitted/nready events in another file
grep "^13\s" $1 | grep "nsubmitted\|nready" > $2.sched

#Clean
rm $TMPDIR/header.$$ $TMPDIR/events.$$ $TMPDIR/sorted_events.$$

#generate csv trace
pj_dump $2.paje > $2.csv
sed -i '/^Container/ d' $2.csv
sed -i '1i Nature,ResourceId,Type,StartTime,EndTime,Duration,Depth,Value' $2.csv