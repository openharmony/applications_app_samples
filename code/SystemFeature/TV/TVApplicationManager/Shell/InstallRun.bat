set application_manager_folder=\product\tv\build\default\outputs\default\tv-default-signed.hap

set hdc_std=hdc_std.exe

%hdc_std% shell mount -o remount,rw /

%hdc_std% shell rm -rf /data/*

%hdc_std% file send %application_manager_folder% /system/app/com.ohos.applicationmanager/ApplicationManager.hap

%hdc_std% shell reboot