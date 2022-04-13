for dhcproc in `ps -ef|grep "dhclient klink" |grep -v grep|awk ' { print $2 } '`;do kill -9 $dhcproc; done

