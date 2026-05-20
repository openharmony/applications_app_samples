set entry_folder=entry\build\default\outputs\product\entry-product-signed.hap

set hdc=hdc.exe

%hdc% shell "mount -o remount,rw /"

%hdc% shell "rm -rf /data/*"

%hdc% shell "mkdir /system/app/com.laval.betaclub"

cd ..

%hdc% file send %entry_folder% /system/app/com.laval.betaclub/DeveloperClub.hap

%hdc% shell "reboot"

Pause