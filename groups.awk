#!/usr/bin/nawk -f

# used both by support.bld and by groups.bld, since the formats are similar

# convert data like this (order doesn't matter except 0 at front)
# 0
# C Canada
# P Ontario
# T Palgrave
# A R R # 1
# O Consultant
# I Ian F. Darwin
# M ian@darwinsys.com
# U http://www.darwinsys.com
# N Author of lots of kool stuff.

# into HTML to make nice neat tables.


$1 ~ /^#/ { next; }

$1 == "0" {
	if (FNR != 1)
		dump();
	reset();
	next;
	}

$1 == "C" { country = substr($0, 2);
	if (country != oldCountry) {
		print "<TR><TD BGCOLOR=\"#FFFF00\" COLSPAN=6 ALIGN=CENTER><B>" country "</B>"
	 }
	oldCountry = country
	next
}
$1 == "P" { prov = substr($0, 2); next }
$1 == "T" { city = substr($0, 2); next }
$1 == "A" { addr = substr($0, 2); next }
$1 == "O" { org = substr($0, 2); next }
$1 == "I" { indv = substr($0, 2); next }
$1 == "B" { phone = substr($0, 2); next }
$1 == "F" { fax = substr($0, 2); next }
$1 == "M" { email = substr($0, 2); next }
$1 == "U" { url = substr($0, 2); next }
$1 == "N" { note = substr($0, 2); next }

# left over - must be part of note?
	{
	note = note "\n" $0
	next
	}

function dump() {
	print "<TR>"
	print "<TD>" 
		if (indv != "")
			print indv "<BR>" 
		print org "<BR>" addr
	print "	<TD>" city "<BR>" prov
	print "	<TD>" 
		if (phone != "")
			print phone "<BR>" 
		print fax
	print "	<TD>"
		if (email != "")
			print "<A HREF=\"mailto:" email "\">" email "</A>" "<BR>"
		print "<A HREF=\"" url "\">" url "</A>"
	print "	<TD>" note
}

function reset() {
	prov = ""
	city = ""
	addr = ""
	org = ""
	indv = ""
	email = ""
	phone = ""
	fax = ""
	url = ""
	note = ""
}

END {
	dump();		# don't forget the last guy!
}
