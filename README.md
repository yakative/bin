# bin

Scripts for scanning

rscan.sh    save resolution of last scan, saves to DB, 
            extra option -t to save as tiff or jpg also -o postcard mode 
rss.sh      save resolution of last scan, saves to DB 
mss.sh      saves to DB
p3s.sh      Special postcard, saves resolution, 300 dpi should be good, 
            2nd scan saves to an "R" named file, 150 res, saves to DB
autosize    Both of these attempt to compute a reasonable resolution.  The one that
scanjpg.sh  Saves res, saves to jpg not tiff

rscvjp      These copy tiffs to jpg - check types at top of script - tiff or tif
            The 180 version flips 180
            The geo version will scale files, see source, also adds a prefix



nss.sh      No save to db.  Not yet updated to new software (epson_scan linux)
nodbsavres  No save to db.  saves resolution.  Not yet updated
mmss        Saves to DB, saves res, not yet updated
            says DB saves to DB

prescan.sh  This script is called from other scripts when EPSON is the device 
            being used to scan.  It creates a template file and then it calls 
            the epsonscan2 executable, which needs to be installed on a host
            and located as indicated below:

            template file created in calling directory:  template.sf2

            call to scan:  /usr/bin/epsonscan2 --scan  "EPSON Scanner" template.sf2



