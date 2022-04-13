# basic scanning script
# "start" below is a starting number.  Theory is that if you screw up a
# scan you can pickup where you left off.  Setting geometry up can be an itch.
if [ "$1" == "" ]; then
echo useage $0 -d directory 
echo "-v device (hp5590  epson2) " >&2
      echo "-s source (Flatbed, TMA Slides)" >&2
      echo "-r  resolution 100 - ? " >&2
      echo "-m  mode (Color, Gray) - ? " >&2
      echo "-n  start numbering, defaults to lastnumber text file" >&2
exit
fi

#default source dir
SDIR=tiff

#default source
SCANSOURCE=Flatbed
#SCANSOURCE="TMA Slides"

#default Color
MYMODE=Color
#MYMODE=Gray

#default res
RES=100

#default device
DEVICE=epson2

FILM=Positive

#default start number
STARTNUM=""



while getopts d:v:f:s:r:n:m: opt; do
  case $opt in
    d)
      echo "-d directory set to: $OPTARG" >&2
      SDIR=$OPTARG
      ;;
    v)
      echo "-v device set to: $OPTARG" >&2
      DEVICE=$OPTARG
      ;;
    s)
      echo "-s source set to: $OPTARG" >&2
      SCANSOURCE=$OPTARG
      ;;
    r)
      echo "-r  resolution set to : $OPTARG" >&2
      RES=$OPTARG
      ;;
    n)
      echo "-n  start numbering at: $OPTARG" >&2
      STARTNUM=$OPTARG
      ;;
    m)
      echo "-m  mode set to : $OPTARG" >&2
      MYMODE=$OPTARG
      ;;
    f)
      echo "-f  mode set to : $OPTARG" >&2
      FILM=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "-d directory (tiff) " >&2
      echo "-f film-type (Positive Negative) " >&2
      echo "-v device (hp5590  epson2) " >&2
      echo "-s source (Flatbed, TMA Slides)" >&2
      echo "-r  resolution 100 ?"  >&2
      echo "-n  start numbering " >&2
      echo "-m  mode Color, Gray" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


# get number from file, if not overridden, if no file, set to 1 (first run)
if [ "$STARTNUM" == "" ]; then
	if [ -f "${SDIR}lastnumber.txt" ]; then
		LASTNUMBER=`cat ${SDIR}lastnumber.txt`
		echo Last Scan Number:$LASTNUMBER
		USENUMBER=`echo $LASTNUMBER+1|bc`
	else
		USENUMBER=1
	fi
else
	USENUMBER=$STARTNUM
fi

echo Directory:$SDIR
echo Device:$DEVICE
echo Resolution:$RES
echo FILM:$FILM
echo Mode:$MYMODE
echo Source:$SCANSOURCE
echo LASTNUMBER:$LASTNUMBER
echo Starting:$USENUMBER

if [ ! -d "$SDIR" ]; then
mkdir $SDIR
fi
for i in `seq -f "%05g" $USENUMBER 90000`
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
        if [ "$DEVICE" = "EPSON Scanner" ]; then
       		USEX=`echo $x*100|bc`
      		USEY=`echo $y*100|bc`
            if [ $RES -lt 300 ]; then
              echo "RESOLUTION must be at least 300 dpi"
            else
  			  ~/bin/prepscan.sh -x $USEX  -y $USEY  -r $RES -v "$DEVICE" -d $SDIR -f s$i
            fi
        else
          /usr/bin/scanimage -x $x  -y $y --format=tiff --resolution $RES --mode $MYMODE --device $DEVICE --source $SCANSOURCE>$SDIR/s$i.tif
        fi
				break
			else
				if [ $savex ]; then
					x=$savex
					y=$savey
					echo scan number:$i x value=$x , y value=$y
          if [ "$DEVICE" = "EPSON Scanner" ]; then
         		USEX=`echo $x*100|bc`
        		USEY=`echo $y*100|bc`
            if [ $RES -lt 300 ]; then
              echo "RESOLUTION must be at least 300 dpi"
            else
              ~/bin/prepscan.sh -x $USEX  -y $USEY  -r $RES -v "$DEVICE" -d $SDIR -f s$i
            fi

          else
  					/usr/bin/scanimage -x $x  -y $y --format=tiff --resolution $RES --mode $MYMODE --device $DEVICE --source $SCANSOURCE>$SDIR/s$i.tif
          fi
					break
				else
					echo "Must enter dimensions"
				fi
			fi
	done
	echo ${i}>${SDIR}lastnumber.txt
	echo $OUTPUTLINE
done

