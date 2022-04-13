IP=`curl ifconfig.me`

DATE=`date`

echo $DATE $IP

if [ "$IP" = "" ]; then
	echo "NO CONNECT"
	exit
fi
echo "<html><META HTTP-EQUIV="expires" NAME="KEYWORDS" CONTENT="Keith Simpson Norman Simpson Geoffrey Simpson"> $DATE $IP </html>">/tmp/ip.html
ncftpput -v -f /home/ksimp/.ncftp/pmisk  . /tmp/ip.html


#echo "<html><META HTTP-EQUIV="expires" NAME="KEYWORDS" CONTENT="Keith Simpson Norman Simpson Geoffrey Simpson"> <script language=javascript> location.replace(\"http://$IP:8080/ksimp/index.html\"); </script> </html>">/tmp/index.html

#echo "<html><META HTTP-EQUIV="expires" NAME="KEYWORDS" CONTENT="Keith Simpson Norman Simpson Geoffrey Simpson"><h3></h3> </html>">/var/www/html/index.html


#ncftpput -v -f /home/ksimp/.ncftp/bellatlan  public/public_html /tmp/index.html

#echo "<html><META HTTP-EQUIV="expires" NAME="KEYWORDS" CONTENT="Keith Simpson Norman Simpson Geoffrey Simpson"> <script language=javascript> location.replace(\"http://$IP:8080/ksimp/index.html\"); </script> </html>">/tmp/realindex.html

#ncftpput -v -f /home/ksimp/.ncftp/bellatlan  public/public_html /tmp/realindex.html

#echo "<html><META HTTP-EQUIV="expires" NAME="KEYWORDS" CONTENT="Rust Pond North Inlet Watershed"> <script language=javascript> location.replace(\"http://$IP:8080/rpni\"); </script> </html>">/tmp/index.html

#ncftpput -v -f /home/ksimp/.ncftp/bellatlan  public/public_html/rpni /tmp/index.html


#echo "<html><META HTTP-EQUIV="expires" NAME="KEYWORDS" CONTENT="Pearson Ensign"> <script language=javascript> location.replace(\"http://$IP:8080/ksimp/ensign/index.html\"); </script> </html>">/tmp/index.html

#ncftpput -v -f /home/ksimp/.ncftp/bellatlan  public/public_html/ensign /tmp/index.html
#ncftpput -v -f /home/ksimp/.ncftp/bellatlan  public/public_html/boat /tmp/index.html

#echo "<html><META HTTP-EQUIV="expires" CONTENT=0> <script language=javascript> location.replace(\"http://$IP:80/internal/index.html\"); </script> </html>">/tmp/index.html
#ncftpput -v -f /home/ksimp/.ncftp/bellatlan  public_html/internal /tmp/index.html


#echo "<html><META HTTP-EQUIV="expires" CONTENT=0> <script language=javascript> location.replace(\"http://$IP:80/camp/index.html\"); </script> </html>">/tmp/index.html
#ncftpput -v -f /home/ksimp/.ncftp/bellatlan  public_html/camp /tmp/index.html


#SET IP's on all remote counters

SEDTMP=/tmp/sedtmp$$.tmp

#sed s/"SRC=\"http:\/\/*.*.*.*:8080"/"SRC=\"http:\/\/${IP}:8080"/  /home/keiths/personal/dem/web/index.html>$SEDTMP

#cp $SEDTMP /home/keiths/personal/dem/web/index.html

#sed s/"SRC=\"http:\/\/*.*.*.*:8080"/"SRC=\"http:\/\/${IP}:8080"/  /home/keiths/personal/dem/web/readcnt.html>$SEDTMP

#cp $SEDTMP /home/keiths/personal/dem/web/readcnt.html


#sed s/"SRC=\"http:\/\/*.*.*.*:8080"/"SRC=\"http:\/\/${IP}:8080"/  /home/keiths/personal/puag/web/index.html>$SEDTMP

#cp $SEDTMP /home/keiths/personal/puag/web/index.html


#copy counters to webspaces
#ncftpput -f ~/.ncftp/bellatlan public_html/puag  /home/keiths/personal/puag/web/index.html
#ncftpput -f ~/.ncftp/bellatlan public_html/vp  /home/keiths/personal/dem/web/index.html
#ncftpput -f ~/.ncftp/bellatlan public_html/vp  /home/keiths/personal/dem/web/readcnt.html

#-----------------------
#FIX resume  for date at top of page and send it to root of verizon
#sed s/"SRC=\"http:\/\/*.*.*.*:8080"/"SRC=\"http:\/\/${IP}:8080"/  /home/ksimp/personal/resume.html>$SEDTMP

#cp $SEDTMP /home/ksimp/personal/resume.html

#ncftpput -f ~/.ncftp/bellatlan public/public_html/  /home/ksimp/personal/resume.html
#-----------------------

#FIX LOCAL mysite index
#sed s/"SRC=\"http:\/\/*.*.*.*:8080"/"SRC=\"http:\/\/${IP}:8080"/  /usr/local/apache/htdocs/ksimp/realindex.html>$SEDTMP

#cp $SEDTMP /usr/local/apache/htdocs/ksimp/realindex.html

#rm -rf $SEDTMP


#-----------------------


#else
#  echo NOT CONNECTED
#fi
