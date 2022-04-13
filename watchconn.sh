SCRIPT_HOME=/root/bin

while [ "X" = "X" ]
do
        clear
        /opt/sybase/bin/isql -Uomni -Slapis -Plolipop -w10000 -b -i$SCRIPT_HOME/who.sql |grep SklVw_Us|awk  '  { printf("%s\t%s\t%s\n", $8 , $2,$9) }'|sort
        sleep 20
done

