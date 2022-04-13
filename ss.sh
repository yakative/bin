#!/bin/ksh

# "start" below is a starting number.  Theory is that if you screw up a
# scan you can pickup where you left off.  Setting geometry up can be an itch.
if [ "$1" == "" ]; then
echo useage $0 directory resolution start
exit
fi

SOURCE=Flatbed
#SOURCE="TMA Slides"

MYMODE=Color
#MYMODE=Gray

if [ "$2" == "" ]; then
res=100
else
res=$2
fi

echo Directory:$1
echo Resolution:$2
echo Starting:$3

# get number from file, if not overridden, if no file, set to 1 (first run)
if [ "$3" == "" ]; then
	if [ -f "${1}lastnumber.txt" ]; then
		LASTNUMBER=`cat ${1}lastnumber.txt`
		echo Last Scan Number:$LASTNUMBER
		USENUMBER=`echo $LASTNUMBER+1|bc`
	else
		STARTNUM=1
	fi
else
	STARTNUM=$3
fi

if [ ! -d "$1" ]; then
mkdir $1
fi

for i in `seq -f "%05g" $USENUMBER 9000`

do
echo New Scan Number:$i
echo enter x value, "r" to repeat last, control c to end         res = $res
read x
echo enter y value
read y



if [ "$x" == "" ]; then
	echo scan number:$i x value=$x , y value=$y
	scanimage  --format=tiff --resolution $res --mode $MYMODE --source $SOURCE>$1/s$i.tif
elif  [ "$x" == "r" ]; then
	echo Last values scan number:$i x value=$savex , y value=$savey Last Values
	scanimage -x $savex  -y $savey --resolution $res --format=tiff --mode $MYMODE --source $SOURCE>$1/s$i.tif
else
	echo scan number:$i x value=$x , y value=$y
	savex=$x
	savey=$y
	 scanimage -x $x  -y $y --format=tiff --resolution $res --mode $MYMODE --source $SOURCE>$1/s$i.tif
fi

echo ${i}>${1}lastnumber.txt

done

