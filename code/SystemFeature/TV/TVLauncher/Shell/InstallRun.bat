set power_dialog_replace_folder=\entry\build\default\outputs\default\entry-default-signed.hap

set hdc_std=hdc_std.exe

%hdc_std% shell mount -o remount,rw /

%hdc_std% shell rm -rf /data/*

%hdc_std% file send %power_dialog_replace_folder% /system/app/com.ohos.powerdialog/power_dialog.hap

%hdc_std% shell reboot