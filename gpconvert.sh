
# general purpose  graphical image conversion tool
# convert types at a given scale
# First param needs to be in quotes, typically a wildcard file spec
# Second param is destination directory, will create
# Third is destination file type
# Fourth is desired pixel width

OFTYPE=$3

if [ "$1" == ""  ]; then
echo useage $0 source_dir_type dest_dir type scale
echo \"big/*tif\" small jpg 2400
exit
fi
if [ "$2" == ""  ]; then
echo useage $0 source_dir_type dest_dir type scale
exit
fi
if [ "$3" == ""  ]; then
echo useage $0 source_dir_type dest_dir type scale
echo \"big/*tif\" small jpg 2400
exit
fi
if [ "$4" == ""  ]; then
echo useage $0 source_dir_type dest_dir type scale
echo \"big/*tif\" small jpg 2400
exit
fi


#if [ ! -f "$1" ]; then
#echo "Files do not exist"
#exit 1
#fi

if [ ! -d "$2" ]; then
	echo mkdir $2
	mkdir $2
fi

dest_dir=$2
SCALE=$4

for IFILE in `ls -c1 $1`

do
	echo input: $IFILE
	FPREFIX=`echo input:$IFILE|awk -F.  '{ print $1 }'`
#  echo $FPREFIX
	FCORE=`echo $FPREFIX|awk -F/  '{ print $NF }'`
#  echo $FCORE
	echo output: $dest_dir/$FCORE.$OFTYPE
	/usr/bin/convert -scale $SCALE $IFILE $dest_dir/$FCORE.$OFTYPE
echo	/usr/bin/convert -scale $SCALE $IFILE $dest_dir/$FCORE.$OFTYPE
done

#if [ "$2" != "" ]; then
#	mv $1/*.$OFTYPE $2
#fi
