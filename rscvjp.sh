#!/bin/ksh

# To convert "tif" files in source_directory to "jpg" files in dest_directory
# Leaves tif files in source

IFTYPE=tif
OFTYPE=jpg

if [ "$1" == "" ]; then
echo useage $0 source_directory dest_directory
exit
fi


if [ ! -d "$1" ]; then
echo "Dirctory does not exist"
exit 1
fi

if [ ! -d "$2" ]; then
	mkdir $2
fi


for IFILE in `ls -c1 $1/*.$IFTYPE`

do
	echo $IFILE
	FPREFIX=`echo $IFILE|awk -F.  '{ print $1 }'`
	echo $FPREFIX.$OFTYPE
	/usr/bin/convert $IFILE $FPREFIX.$OFTYPE
done

if [ "$2" != "" ]; then
	mv $1/*.$OFTYPE $2
fi
