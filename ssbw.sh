#!/bin/ksh

# "start" below is a starting number.  Theory is that if you screw up a
# scan you can pickup where you left off.  Setting geometry up can be an itch.
if [ "$1" == "" ]; then
echo useage $0 directory resolution start
exit
fi

SOURCE=Flatbed
#SOURCE="TMA Slides"

#MYMODE=Color
MYMODE=Gray

if [ $2 ]; then
RES=$2
else
RES=100
fi

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

echo Directory:$1
echo Resolution:$RES
echo Starting:$STARTNUM

if [ ! -d "$1" ]; then
mkdir $1
fi

for i in `seq -f "%05g" $USENUMBER 9000`

do
	echo New Scan Number:$i
	while [ -n $x ]
	do
			echo enter x value, CR to repeat last, control c to end         RES = $RES
			read x
			if [ $x ]; then
				echo enter y value
				read y
			fi

			if [ $x ]; then
				echo scan number:$i x value=$x , y value=$y
				savex=$x
				savey=$y
					/usr/local/bin/scanimage -x $x  -y $y --format=tiff --resolution $RES --mode $MYMODE --source $SOURCE>$1/s$i.tif
				break
			else
				if [ $savex ]; then
					x=$savex
					y=$savey
					echo scan number:$i x value=$x , y value=$y
					/usr/local/bin/scanimage -x $x  -y $y --format=tiff --resolution $RES --mode $MYMODE --source $SOURCE>$1/s$i.tif
					break
				else
					echo "Must enter dimensions"
				fi
			fi
	done
	echo ${i}>${1}lastnumber.txt
done

