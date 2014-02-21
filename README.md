visual_top_talkers
==================

Just a proof of concept!

A few bash scripts that build on an example from pmacct for turning pmacct data into graphs

Builds heavily upon the script gnuplot-example.sh found in the examples directory of the
pmacct tarball, from http://www.pmacct.net

Included a snapshot of the http://bgp.potaroo.net/cidr/autnums.html in postgres format too,
this is from Feb 2014 and *does not include* asdot AS names! I plan on fixing this one day

I will not include a dump of the internet routing table, because it's always changing.

For your very own dump of the internet's current routing table to map things to ASN, see:
https://gist.github.com/paulreece42/9002883

Assumptions
-----------


- You're someone technical with an ops background, a net- or sysadmin
- You have your own ASN and are looking to see which peering connections you should make
- You have pmacct installed and configured with posgresql monitoring your network border.
- Doing 300 second snapshots
- You want to see the past week
- I *highly* recommend using pg_partman to partition this table, especially as it assumes 5 minute snaps
