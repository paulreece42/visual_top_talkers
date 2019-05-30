Update, 2019
============

Don't use this, I wrote it in an afternoon 6 years ago, and you can get all this and
more easily/better by just using logstash's netflow modules

https://www.elastic.co/guide/en/logstash/current/netflow-module.html


visual_top_talkers
==================

Just a proof of concept!

Only does origin AS aggregation right now

This is being tested now, and might be so buggy as to be unusable.

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

There's a lot of them:

- You're someone technical with an ops background, a net- or sysadmin
- You have your own ASN and are looking to see which peering connections you should make
- You have pmacct installed and configured with posgresql monitoring your network border.
- Doing 300 second snapshots
- You want to see the past week
- I *highly* recommend using pg_partman to partition this table, especially as it assumes 5 minute snaps
- You have gnuplot installed
- ip flow-cache timeout set no higher than 5 minutes on your router


Yes, but what IS it?
--------------------

It takes your top $VAR (10 by default) origin ASNs, and graphs them. The idea being, if any of these
are past $x gbit, you might want to give them a call and see about peering


I've included a screenshot so you can see this. Of course, this is a screenshot of my home router,
so you mostly see how many YouTube videos my roommate watches. Not the best example, but you get
the idea.

Right now it just does ASNs, as I find that most interesting, but I want to continue to work down the stack
to IPs, then ports/mac with sflow, etc

You could modify it quite trivially to do this, assuming knowledge of bash and sql



