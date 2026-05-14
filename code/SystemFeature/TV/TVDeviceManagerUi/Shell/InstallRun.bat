set device_manager_replace_folder=\entry\build\default\outputs\default\entry-default-signed.hap

set hdc_std=hdc_std.exe

%hdc_std% shell mount -o remount,rw /

%hdc_std% shell rm -rf /data/*

hdc file send entry-default-signed.hap /system/app/com.ohos.devicemanagerui/DeviceManager_UI.hap

%hdc_std% shell reboot