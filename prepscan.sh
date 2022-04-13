# This is called from existing scripts that worked using the "scanimage" program.
# here is an example call:
#  prepscan.sh -v "EPSON Scanner" -x 200 -y 250  -f testscan -d "./tiff" -r 150

if [ "$1" == "" ]; then
echo useage $0 -d directory 
echo "-v device epsonscan2 -l " >&2
      echo "-x  width" >&2
      echo "-y  length" >&2
      echo "-r  resolution 100 - ? " >&2
      echo "-m  mode (Color, Gray) - ? " >&2
      echo "-f  filename" >&2
exit
fi

# There are file format options 1=jpg 2=tif 4=png 6=pdf  (and some more)
# May be of use in future, for now use tiff
IMAGEFORMAT=2

while getopts x:y:d:v:f:r:m:i: opt; do
  case $opt in
    x)
#      echo "-x width set to: $OPTARG" >&2
      XIN=$OPTARG
      ;;
    y)
#      echo "-y length set to: $OPTARG" >&2
      YIN=$OPTARG
      ;;
    d)
#      echo "-d directory set to: $OPTARG" >&2
      SDIR=$OPTARG
      ;;
    v)
#      echo "-v device set to: $OPTARG" >&2
      DEVICE=$OPTARG
      ;;
    r)
#      echo "-r resolution set to : $OPTARG" >&2
      RES=$OPTARG
      ;;
    m)
#      echo "-m  mode set to : $OPTARG" >&2
      MYMODE=$OPTARG
      ;;
    f)
#      echo "-f File name set to : $OPTARG" >&2
      FILENAME=$OPTARG
      ;;
    i)
#      echo "-i Image Format set to : $OPTARG" >&2
      IMAGEFORMAT=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "-d directory (tiff) " >&2
      echo "-f file name " >&2
      echo "-v device (hp5590  epson2) " >&2
      echo "-r  resolution 100 ?"  >&2
      echo "-x  width  " >&2
      echo "-y  length  " >&2
      echo "-m  mode Color, Gray" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

#set all dimensions
XDIM="$XIN"
YDIM="$YIN"
#echo "TP1 $RES"
case $RES in
  150)
    FACTOR=16.94
    ;;
  200)
    FACTOR=16.94
    ;;
  240)
    FACTOR=10.58
    ;;
  300)
    FACTOR=8.47
    ;;
  400)
    FACTOR=6.53
    ;;
  600)
    FACTOR=4.23
    ;;
  600)
    FACTOR=16.94
    ;;
  \?)
      echo "Invalid resolution entered" >&2
      exit 1
      ;;
    :)
      echo "Resolution must be entered" >&2
      exit 1
      ;;
  esac

#echo "TP2 $FACTOR"

XS=`/usr/bin/bc <<< "$XDIM/$FACTOR"`
XEXTRA=`printf "%.0f" $XS`
YS=`/usr/bin/bc <<< "$YDIM/$FACTOR"`
YEXTRA=`printf "%.0f" $YS`


#XS=`/usr/bin/bc <<< "$XDIM*.118/2"`
#XEXTRA=`printf "%.0f" $XS`
#YS=`/usr/bin/bc <<< "$YDIM*.118/2"`
#YEXTRA=`printf "%.0f" $YS`


#default mode to color
if [ "$MYMODE" = "Gray" ]; then
  COLORMODE=1
else
COLORMODE=0
fi


##echo XDIM=$XDIM
#echo YDIM=$YDIM
#echo XEXTRA=$XEXTRA
#echo YEXTRA=$YEXTRA
#echo COLORMODE: $COLORMODE
#echo IMAGEFORMAT: 2
#echo RES=$RES

# There are file format options 1=jpg 2=tif 4=png 6=pdf  (and some more)
# May be of use in future, for now use tiff
IMAGEFORMAT=2

#Output settings file

#CALL -x $x  -y $y --format=tiff --resolution $RES --mode $MYMODE --device $DEVICE >$SDIR/s$i.tif

echo '{
    "Preset": [
        {
            "0": [
                {
                    "AFMMode": {
                        "int": 0
                    },
                    "AFMTimeout": {
                        "int": 180
                    },
                    "AddPages": {
                        "int": 0
                    },
                    "AutoSize": {
                        "int": 0
                    },
                    "BackgroundColor": {
                        "int": 1
                    },
                    "BackgroundRemoval": {
                        "int": 0
                    },
                    "BlankPageSkip": {
                        "int": 0
                    },
                    "BlankPageSkipLevel": {
                        "int": 10
                    },
                    "Brightness": {
                        "int": 0
                    },
                    "ColorType": {
                        "int": '$COLORMODE'
                    },
                    "Contrast": {
                        "int": 0
                    },
                    "DNShow_LongPaperWarning_dialog": {
                        "int": 0
                    },
                    "DNShow_PlasticCard_dialog": {
                        "int": 0
                    },
                    "DoubleFeedDetection": {
                        "int": 1
                    },
                    "DoubleFeedDetectionAreaLength": {
                        "int": 1550
                    },
                    "DoubleFeedDetectionAreaMin": {
                        "int": 0
                    },
                    "DoubleFeedDetectionLevel": {
                        "int": 0
                    },
                    "DropoutColor": {
                        "int": 0
                    },
                    "DuplexType": {
                        "int": 0
                    },
                    "FileNameCounter": {
                        "int": 0
                    },
                    "FileNameOverWrite": {
                        "int": 0
                    },
                    "FileNamePrefix": {
                        "string": "'$FILENAME'"
                    },
                    "FixedDocumentSize": {
                        "int": 101
                    },
                    "Folder": {
                        "int": 101
                    },
                    "FunctionalUnit": {
                        "int": 0
                    },
                    "FunctionalUnit_Auto": {
                        "int": 0
                    },
                    "Gamma": {
                        "int": 22
                    },
                    "ImageFormat": {
                        "int": '$IMAGEFORMAT'
                    },
                    "ImageOption": {
                        "int": 0
                    },
                    "JpegQuality": {
                        "int": 0
                    },
                    "JpegQualityForJpeg": {
                        "int": 85
                    },
                    "JpegQualityForPdf": {
                        "int": 85
                    },
                    "MultiTiffCompression": {
                        "int": 0
                    },
                    "MultiTiffEnabled": {
                        "int": 0
                    },
                    "NearDurationAlert": {
                        "int": 0
                    },
                    "Orientation": {
                        "int": 0
                    },
                    "OverDurationAlert": {
                        "int": 0
                    },
                    "PDFAllPages": {
                        "int": 1
                    },
                    "PDFSelectPage": {
                        "int": 1
                    },
                    "PagesTobeScanned": {
                        "int": 0
                    },
                    "PaperDeskew": {
                        "int": 1
                    },
                    "PaperEndDetection": {
                        "int": 0
                    },
                    "PaperEndDetectionMemory": {
                        "int": 0
                    },
                    "Resolution": {
                        "int": '$RES'
                    },
                    "ScanAreaHeight": {
                        "int": '$YEXTRA'
                    },
                    "ScanAreaOffsetX": {
                        "int": 0
                    },
                    "ScanAreaOffsetY": {
                        "int": 0
                    },
                    "ScanAreaWidth": {
                        "int": '$XEXTRA'
                    },
                    "Threshold": {
                        "int": 110
                    },
                    "TransferCompression": {
                        "int": 1
                    },
                    "UserDefinePath": {
                        "string": "'$SDIR'"
                    },
                    "UserScanAreaHeight": {
                        "int": '$YDIM' },
                    "UserScanAreaWidth": {
                        "int":'$XDIM' },
                    "jpegProgressive": {
                        "int": 0
                    }
                }
            ]
        }
    ]
}'>template.sf2

/usr/bin/epsonscan2 --scan  "$DEVICE" template.sf2
