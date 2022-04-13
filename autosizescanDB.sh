#!/bin/bash
# This is a version of the scanning script that inserts records
# into a MySql dbase "box" values, which are prompted for
# otherwise all the other 
# Also, this version allows for change of resolution on each scan

# "start" below is a starting number.  Theory is that if you screw up a
# scan you can pickup where you left off.  Setting geometry up can be an itch.
#
# SPECIAL also calculates a default resolution based on dimensions
if [ "$1" == "" ]; then
echo useage $0 -d directory 
echo "-v device (hp5590  epson2) " >&2
      echo "-s source (Flatbed, TMA Slides)" >&2
      echo "-r  resolution 100 - ? " >&2
      echo "-m  mode (Color, Gray) - ? " >&2
      echo "-n  start numbering, defaults to lastnumber text file" >&2
      echo "-u  DB user" >&2
			echo "-p  DB password" >&2
			echo "-b  DB Name" >&2
			echo "-c  Customer Name" >&2
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
DEVICE="EPSON Scanner"

FILM=Positive

#default DB User
DBUSER="ya"

#default DB Password
DBPASS="jkluiojkl"

#default DB Name 
DBNAME="yarch"

#default Customer Code 
CUSTCODE="UNKNOWN"


while getopts d:v:f:s:r:n:m:c:l:u:p:b: opt; do
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
      echo "-f  film-type set to : $OPTARG" >&2
      FILM=$OPTARG
      ;;
    u)
      echo "-u  DB user : $OPTARG" >&2
      DBUSER=$OPTARG
      ;;
    p)
      echo "-p  DB password : $OPTARG" >&2
      DBPASS=$OPTARG
      ;;
    b)
      echo "-u  DB Name : $OPTARG" >&2
      DBNAME=$OPTARG
      ;;
    c)
      echo "-c  Customer Code: $OPTARG" >&2
      CUSTCODE=$OPTARG
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
      echo "-b  DB Name" >&2
      echo "-u  DB User" >&2
      echo "-p  DB Password" >&2
      echo "-c  Customer Code" >&2
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

no_error=true;
d_entered=false;

for i in `seq -f "%05g" $USENUMBER 90000`

do
	echo New Scan Number:$i
	while [ -n $x ]
	do
			echo enter x value, CR to repeat last, control c to end         
			read x
			if [ $x ]; then
				echo enter y value
				read y
			fi

# if entered, set default values
			if [ $x ]; then
        d_entered=true;
				savex=$x
				savey=$y
			else
# if not entered, pickup default values
				if [ $savex ]; then
					x=$savex
					y=$savey
				else
#echo "NO dimensions entered"
# Must enter dimensions
          no_error=false;
				fi
			fi
#now calculate default resolution
      z=$((x+y))

    if [ $z -le 200 ]
    then
      cres=600
    fi
    if [ $z -gt 200 ] && [ $z -le 340 ]
      then
        cres=400
      fi
    if [ $z -gt 340 ] && [ $z -le 360 ]
      then
        cres=300
      fi
    if [ $z -gt 360 ] && [ $z -le 400 ]
      then
        cres=240
      fi
    if [ $z -gt 400 ]
      then
        cres=150
      fi

			echo enter box number 
			read box

			if [ $box ]; then
				savebox=$box
			fi

      echo "Calculated Resolution=$cres, enter resolution  (150,200,240,300,400,600)"
      read res

      if [ $res ]; then
        saveres=$res
      else
        saveres=$cres
      fi
      echo enter customer index
      read cidx
			if  $d_entered; then
				echo scan number:$i x=$x, y=$y, box=$savebox, code=$CUSTCODE res=$saveres
          if [ "$DEVICE" = "EPSON Scanner" ]; then
         		USEX=`echo $x*100|bc`
        		USEY=`echo $y*100|bc`
    			  ~/bin/prepscan.sh -x $USEX  -y $USEY  -r $saveres -v "$DEVICE" -d $SDIR -f s$i
          else
/usr/bin/scanimage -x $x  -y $y --format=tiff --resolution $saveres --mode $MYMODE --device $DEVICE --source $SCANSOURCE >$SDIR/s$i.tif
          fi
				break
			else
				if  $no_error  ; then
#echo "dimensions not entered, but defaults were set and can be used"
				echo scan number:$i x value=$x , y value=$y  box =$savebox  res=$saveres
          if [ "$DEVICE" = "EPSON Scanner" ]; then
         		USEX=`echo $x*100|bc`
        		USEY=`echo $y*100|bc`
    			  ~/bin/prepscan.sh -x $USEX  -y $USEY  -r $saveres -v "$DEVICE" -d $SDIR -f s$i
          else
/usr/bin/scanimage -x $x  -y $y --format=tiff --resolution $saveres --mode $MYMODE --device $DEVICE --source $SCANSOURCE >$SDIR/s$i.tif
          fi
					break
				else
					echo "MUST ENTER DIMENSIONS"
          no_error=true;
				fi
			fi
	done

# comment out next 5 for testing
	echo ${i}>${SDIR}lastnumber.txt

#DBUSER="ya"
#DBPASS="jkluiojkl"
#$DBNAME="yarch"

mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME" <<EOF
	INSERT into ya_cat values ("$CUSTCODE","$i","$savebox","$cidx");
EOF

done

