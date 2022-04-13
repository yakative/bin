#!/bin/ksh

# To convert "tif" files in source_directory to "jpg" files in dest_directory
# Leaves tif files in source
# this is a version that scales all files starting with "fileprefix"

IFTYPE=jpg
OFTYPE=jpg

if [ "$1" == ""  ]; then
echo useage $0 source_directory dest_directory fileprefix
exit
fi

if [ "$2" == ""  ]; then
echo useage $0 source_directory dest_directory fileprefix
exit
fi
if [ "$3" == ""  ]; then
echo useage $0 source_directory dest_directory fileprefix
exit
fi


if [ ! -d "$1" ]; then
echo "Dirctory does not exist"
exit 1
fi

if [ ! -d "$2" ]; then
	mkdir $2
fi

fileprefix=$3

for IFILE in `ls -c1 $1/${fileprefix}*.$IFTYPE`

do
	echo $IFILE
	FPREFIX=`echo $IFILE|awk -F.  '{ print $1 }'`
	echo $FPREFIX.$OFTYPE
	/usr/bin/convert -scale 800 $IFILE $FPREFIX.$OFTYPE
done

if [ "$2" != "" ]; then
	mv $1/${fileprefix}*.$OFTYPE $2
fi
