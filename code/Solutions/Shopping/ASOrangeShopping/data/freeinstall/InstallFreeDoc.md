### 安装服务中心

1.配置[freeinstall文件夹]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/data/freeinstall )下所有脚本的hdc为本地的hdc路径。

2.执行当前文件夹下[1.pull_install_list.bat]( https://gitee.com/openharmony/applications_app_samples/blob/master/code/Solutions/Shopping/ASOrangeShopping/data/freeinstall/1.pull_install_list.bat )脚本，获取install_list_capability.json文件。

3.将下面的内容补充道json文件的末尾进行保存，再执行[2.push_list.bat]( https://gitee.com/openharmony/applications_app_samples/blob/master/code/Solutions/Shopping/ASOrangeShopping/data/freeinstall/2.push_list.bat )脚本，将json文件push到设备中。
```
{
    "bundleName": "com.ohos.hag.famanager",
    "app_signature": ["8E93863FC32EE238060BF69A9B37E2608FFFB21F93C862DD511CBAC9F30024B5"],
    "allowAppUsePrivilegeExtension": true,
    "allowAppDesktopIconHide": true
}
```

4.等待设备重启后，执行[3.install_haps.bat]( https://gitee.com/openharmony/applications_app_samples/blob/master/code/Solutions/Shopping/ASOrangeShopping/data/freeinstall/3.install_haps.bat )脚本将famager安装到设备。

### 安装Launcher

Launcher的编译安装方法请参看：[Launcher]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/SystemFeature/ApplicationModels/Launcher )



