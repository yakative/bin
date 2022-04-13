
# this script executed by sudo to change the permissions on scanner

if [ "$1" == "" ]; then
echo useage $0 hp or Epson
exit
fi

echo NEED TO EXEC AS ROOT
USB=`/usr/local/bin/scanimage -L|grep $1`
echo $USB

USB1=`echo $USB|awk -F: ' { print $3 } '`
USB2=`echo $USB|awk -F: ' { print $4 } '`
USBDEV=`echo $USB2|awk -F"'" ' { print $1 } '`
echo $USB1
echo $USB2
echo $USBDEV

echo chmod 777 /dev/bus/usb/$USB1
echo chmod 666 /dev/bus/usb/$USB1/$USBDEV
echo Press any key to continue...
chmod 777 /dev/bus/usb/$USB1
chmod 666 /dev/bus/usb/$USB1/$USBDEV
read wtf
