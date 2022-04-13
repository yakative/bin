ipa=`curl ifconfig.me`
echo ' <html> <script language="javascript"> window.location.href = "http://'$ipa':50082/weewx/" </script> </html>' >/home/ksimp/bin/weather/index.html

