#!/bin/bash

# This is a version of the scanning script that inserts records
# into a MySql dbase "box" values, which are prompted for
# otherwise all the other 
# Also, this version allows for change of resolution on each scan

# "start" below is a starting number.  Theory is that if you screw up a
# scan you can pickup where you left off.  Setting geometry up can be an itch.

# updated for V600 scanner unix software epsonscan2, set device: -v EPSON
# calls another script, prepscan.sh to generate a template file for the scan


if [ "$1" == "" ]; then
echo "useage $0 -v -d dir -t format -m mode -n number -o -w "
echo "-u user -p pword -b dbname -c customer -s -f "
echo "-v device Required (EPSON, hp5590  epson2 etc.) " >&2
echo "-d directory (tiff)"
      echo "-t format (tiff, jpg, png, pdf)" >&2
      echo "-m  mode (Color, Gray) " >&2
      echo "-n  start numbering, defaults to lastnumber text file" >&2
      echo "-o  Postcard mode  (scans twice, 2nd time at 150 resolution)" >&2
      echo "-w  Write to MySQL DB" >&2
      echo "-u  DB user" >&2
			echo "-p  DB password" >&2
			echo "-b  DB Name" >&2
			echo "-c  Customer Name" >&2
      echo "-s  source (Flatbed, TMA Slides)*" >&2
      echo "-f  film type (Positive,Negative)* " >&2
      echo "  If device set to EPSON, uses linux epsonscan2 software to newer Epson Scanners  " >&2
      echo "  * Not used in EPSON device  " >&2
exit
fi

#default source dir
SDIR=tiff

#default format 
FORMAT=tiff

#default Write to DB mode 
WRITEDB=0

#default Postcard mode 
POSTCARD=0

#default source
SCANSOURCE=Flatbed

#default Color
MYMODE=Color
#MYMODE=Gray

#default res
RES=150

#default device
DEVICE="EPSON"

FILM=Positive

#default DB User
DBUSER="ya"

#default DB Password
DBPASS="jkluiojkl"

#default DB Name 
DBNAME="yarch"

#default Customer Code 
CUSTCODE="UNKNOWN"


while getopts d:v:f:s:n:t:m:c:l:u:p:b:wo opt; do
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
    t)
      echo "-t format set to: $OPTARG" >&2
      FORMAT=$OPTARG
      ;;
    n)
      echo "-n  start numbering at: $OPTARG" >&2
      STARTNUM=$OPTARG
      ;;
    o)
      echo "-o  Postcard mode : $OPTARG" >&2
      POSTCARD=1
      ;;
    m)
      echo "-m  mode set to : $OPTARG" >&2
      MYMODE=$OPTARG
      ;;
    f)
      echo "-f  film-type set to : $OPTARG" >&2
      FILM=$OPTARG
      ;;
    w)
      echo "-w Write to  DB  : $OPTARG" >&2
      WRITEDB=1
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
      echo "-t format (tiff, jpg) " >&2
      echo "-f film-type (Positive Negative) " >&2
      echo "-v device (hp5590  epson2) " >&2
      echo "-s source (Flatbed, TMA Slides)" >&2
      echo "-r  resolution 100 ?"  >&2
      echo "-n  start numbering " >&2
      echo "-o  Postcard " >&2
      echo "-m  mode Color, Gray" >&2
      echo "-w  Write to DB" >&2
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
#echo Directory:$SDIR
#echo Format:$FORMAT
#echo Device:$DEVICE
#echo Resolution:$RES
#echo FILM:$FILM
#echo Mode:$MYMODE
#echo Postcard:$POSTCARD
#echo Source:$SCANSOURCE
#echo LASTNUMBER:$LASTNUMBER
#echo Starting:$USENUMBER
#echo WRITEDB:$WRITEDB
#
#if [ $POSTCARD = 1 ];then
#  echo "Scanning Postcard"
#fi
#if [ $WRITEDB = 1 ];then
#  echo "Writing to DB"
#fi
#

if [ ! -d "$SDIR" ]; then
mkdir $SDIR
fi

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
			echo Enter box number 
			read box

			if [ $box ]; then
				savebox=$box
			fi

      echo Enter Resolution:
      read res

      if [ $res ]; then
        saveres=$res
      fi

      echo Enter Customer Index
      read cidx

			if [ $x ]; then
				echo scan number:$i x value=$x , y value=$y  box =$savebox  res=$saveres
				savex=$x
				savey=$y
          if [ "$DEVICE" = "EPSON" ]; then
         		USEX=`echo $x*100|bc`
        		USEY=`echo $y*100|bc`

    			  ~/bin/prescan.sh -x $USEX  -y $USEY  -r $saveres -i $FORMAT -d $SDIR -f s$i
            if [ "$POSTCARD" = "Y" ]; then
              sleep 1
       			  ~/bin/prescan.sh -x $USEX  -y $USEY  -r 150 -i $FORMAT -d $SDIR -f Rs$i
            fi
          else
					/usr/bin/scanimage -x $x  -y $y --format=$FORMAT --resolution $saveres --mode $MYMODE --device $DEVICE --source $SCANSOURCE>$SDIR/s$i.tif
            if [ "$POSTCARD" = "Y" ]; then
              sleep 1
    					/usr/bin/scanimage -x $x  -y $y --format=$FORMAT --resolution 150 --mode $MYMODE --device $DEVICE --source $SCANSOURCE>rjpg/Rs${i}.tif
            fi
          fi
				break
			else
				if [ $savex ]; then
					x=$savex
					y=$savey
					echo scan number:$i x value=$x , y value=$y
          if [ "$DEVICE" = "EPSON" ]; then
         		USEX=`echo $x*100|bc`
        		USEY=`echo $y*100|bc`
    			  ~/bin/prescan.sh -x $USEX  -y $USEY  -r $saveres -i $FORMAT -d $SDIR -f s$i
            if [ $POSTCARD = 1 ];then
              sleep 1
      			  ~/bin/prescan.sh -x $USEX  -y $USEY  -r 150 -i $FORMAT -d $SDIR -f Rs$i
            fi
          else
					/usr/bin/scanimage -x $x  -y $y --format=$FORMAT --resolution $res --mode $MYMODE --device $DEVICE --source $SCANSOURCE>$SDIR/s$i.tif
            if [ $POSTCARD = 1 ];then
              sleep 1
    					/usr/bin/scanimage -x $x  -y $y --format=$FORMAT --resolution 150 --mode $MYMODE --device $DEVICE --source $SCANSOURCE>rjpg/Rs${i}.tif
            fi
          fi
					break
				else
					echo "Must enter dimensions"
				fi
			fi
	done
	echo ${i}>${SDIR}lastnumber.txt
  if [ $WRITEDB = 1 ];then
mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME" <<EOF
	INSERT into ya_cat values ("$CUSTCODE","$i","$savebox","$cidx");
EOF
  fi

done

