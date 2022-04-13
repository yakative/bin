echo "To:root
From:PPPthing
Subject:ppp stat
-----------
">~/Mail/pppmail
cat ~/pppout2>>~/Mail/pppmail
echo "
">>~/Mail/pppmail
/usr/bin/send pppmail
