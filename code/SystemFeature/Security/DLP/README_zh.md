# DLP

### 介绍

本示例是一个安全类App，使用[@ohos.dlpPermission](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-data-protection-kit/js-apis-dlppermission-sys.md) 接口展示了在eTS中普通文件加密受限的过程。

### 效果预览
| Index                                     | Encryption                                           | Encryptied                                       | FileEdit                                           |
|-----------------------------------------|-----------------------------------------------|---------------------------------------------|----------------------------------------------------|
| ![Index](screenshots/devices/Index.jpeg) | ![Encryption](screenshots/devices/Encryption.jpeg) | ![Encryptied](screenshots/devices/Encrypted.jpeg) | ![FileEdit](screenshots/devices/FileEditPage.jpeg) |

使用说明:
1. 启动应用后点击“**+**”按钮可以添加一个普通文件;
2. 长按点击加密按钮，出现加密权限弹窗，选择需要设置的权限并点击确定;
3. 点击加密文件，跳转到文本编辑应用，如果设置的权限是只读权限，页面置灰，不可编辑。
4. 长按点击删除按钮，删除文件;

### 工程目录
```
entry/src/main/ets/
|---component
|   |---CustomDialog.ets                        // 权限弹窗
|---feature
|   |---DlpManager.ets                          // Dlp管理
|   |---FileManager.ets                         // 文件管理
|   |---PreferencesManager.ets                  // 持久化存储
|---pages
|   |---Index.ets                               // 首页
|---util
|   |---Logger.ts                               // 日志
|   |---ResourceUtils.ets                       // 资源转换
```
### 具体实现

+ 文件的添加和文件列表的获取分别在Index和MediaFileUri中，源码参考[Index.ets](entry/src/main/ets/pages/Index.ets) 和 [FileManager.ets](entry/src/main/ets/feature/FileManager.ets):
  + 文件的添加：首先通过[@ohos.file.picker](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-picker.md)接口的DocumentSaveOptions()方法自定一个参数，然后通过new picker.DocumentViewPicker()方法拉起文件管理应用去新建一个普通文件。
  + 文件列表的获取：首先使用[@ohos.file.fileAccess](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-fileAccess-sys.md) 接口的createFileAccessHelper()方法来创建连接指定wants的helper对象，然后通过getRoots()方法来获取helper对象连接的文件管理服务类的设备根节点信息，并获取到目录url，最后通过getFileInfoFromUri()方法得到文件的信息。
+ 文件的加密操作在DlpManager中，源码参考[DlpManager.ets](entry/src/main/ets/feature/DlpManager.ets):
    + 加密操作：使用dlpPermission接口的generateDLPFile方法获得一个相关的操作型关系数据库RdbStore，将明文文件加密生成权限受控文件。

### 相关权限

允许文件管理类应用通过FAF框架访问公共数据文件：[ohos.permission.FILE_ACCESS_MANAGER](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionfile_access_manager)

允许应用调用storage manager服务中对空间统计以及卷信息的查询接口：[ohos.permission.STORAGE_MANAGER](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionstorage_manager)

允许查询应用的基本信息和其他敏感信息：[ohos.permission.GET_BUNDLE_INFO_PRIVILEGED](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionget_bundle_info_privileged)

允许对DLP文件进行权限配置和管理：[ohos.permission.ACCESS_DLP_FILE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionaccess_dlp_file)

允许应用管理系统分布式帐号信息：[ohos.permission.MANAGE_DISTRIBUTED_ACCOUNTS](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionmanage_distributed_accounts)

允许应用管理系统本地帐号：[ohos.permission.MANAGE_LOCAL_ACCOUNTS](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionmanage_local_accounts)

允许应用查询系统本地帐号信息：[ohos.permission.GET_LOCAL_ACCOUNTS](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionget_local_accounts)

### 依赖

需要依赖三方应用文本编辑FileEdit的[hap](screenshots/haps)。

### 约束与限制

1. 本示例仅支持标准系统上运行;
2. 本示例仅支持API10版本SDK，SDK版本号(4.0.10.10), 镜像版本号(4.0 Release)。
3. 本示例需要使用DevEco Studio 4.0 Beta2 (Build Version: 4.0.0.400, built on August 2, 2023)才可编译运行;
4. 本示例需要使用@ohos.dlpPermission系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/faqs/full-sdk-switch-guide.md)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/Security/DLP/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
## samples代码运行及其环境配置
1.克隆samples代码到本地<br>
&nbsp;&nbsp;&nbsp;&nbsp;开发板上需要烧入日构建版本（dayu200）和最新的SDK（ohos-sdk-full）：https://dcp.openharmony.cn/workbench/cicd/dailybuild/dailylist<br>
&nbsp;&nbsp;&nbsp;&nbsp;具体操作为：https://blog.csdn.net/nanzhanfei/article/details/121951919<br>
2.在".\DLP\entry\src\main"下新增syscap.json文件，文件内容为：
```
{
  "devices": {
    "general": [
      "default",
      "tablet"
    ]
  },
  "development": {
    "addedSysCaps": [
      "SystemCapability.ArkUI.ArkUI.Circle"
    ]
  }
}
```
3.配置build-profile.json5 （.\DLP\build-profile.json5）
```
    "products": [
      {
        "name": "default",
        "signingConfig": "default",
        "compileSdkVersion": 22,
        "compatibleSdkVersion": 22,
        "runtimeOS": "OpenHarmony",
        "targetSdkVersion": 22
      }
    ],
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;若出现sync failed,可以尝试点击Migrate Assistant <br>
![Index](screenshots/devices/syn出错.png)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;配置另外一个build-profile.json5 (.\DLP\entry\src\main\module.json5)
4.添加签名<br>
（1）在cmd中输入如下指令，获取DLP samples应用指纹<br>
hdc shell "bm dump -n com.samples.dlp | grep finger"<br>
（2）拉出配置文件install_list_capability.json(该文件在打开cmd的目录下)<br>
hdc file recv /system/variant/phone/base/etc/app/install_list_capability.json<br>
（3）打开install_list_capability.json文件，将DLP samples应用设置为系统应用,文件最下面添加（可以直接复制其它应用的配置，再改签名和包名）
```
{
  {
	{
    	"bundleName": "com.sample.dlp",
        "app_signature": {
        	"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        },
        "allowAppUsePrivilageExtension": true,
        "allowAppDesktopIconHide":true
	}
  }
}
```
（4）推送配置文件（在install_list_capability.json所在目录打开cmd）<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hdc file send install_list_capability.json /system/variant/pc/base/etc/app/<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hdc shell reboot<br>
（5）下载签名工具（clone下来）
https://gitee.com/openharmony/developtools_hapsigner
（6）在下载好的文件夹中，修改文件  .\developtools_hapsigner-master\dist\UnsgnedReleasedProfileTemplate.json<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;修改如下所示
```
{
    "version-name": "2.0.0",
    "version-code": 2,
    "app-distribution-type": "os_integration",
    "uuid": "5027b99e-5f9e-465d-9508-a9e0134ffe18",
    "validity": {
        "not-before": 1594865258,
        "not-after": 1689473258
    },
    "type": "release",
    "bundle-info": {
        "developer-id": "OpenHarmony",
        "distribution-certificate": "-----BEGIN CERTIFICATE-----\nMIICMzCCAbegAwIBAgIEaOC/zDAMBggqhkjOPQQDAwUAMGMxCzAJBgNVBAYTAkNO\nMRQwEgYDVQQKEwtPcGVuSGFybW9ueTEZMBcGA1UECxMQT3Blbkhhcm1vbnkgVGVh\nbTEjMCEGA1UEAxMaT3Blbkhhcm1vbnkgQXBwbGljYXRpb24gQ0EwHhcNMjEwMjAy\nMTIxOTMxWhcNNDkxMjMxMTIxOTMxWjBoMQswCQYDVQQGEwJDTjEUMBIGA1UEChML\nT3Blbkhhcm1vbnkxGTAXBgNVBAsTEE9wZW5IYXJtb255IFRlYW0xKDAmBgNVBAMT\nH09wZW5IYXJtb255IEFwcGxpY2F0aW9uIFJlbGVhc2UwWTATBgcqhkjOPQIBBggq\nhkjOPQMBBwNCAATbYOCQQpW5fdkYHN45v0X3AHax12jPBdEDosFRIZ1eXmxOYzSG\nJwMfsHhUU90E8lI0TXYZnNmgM1sovubeQqATo1IwUDAfBgNVHSMEGDAWgBTbhrci\nFtULoUu33SV7ufEFfaItRzAOBgNVHQ8BAf8EBAMCB4AwHQYDVR0OBBYEFPtxruhl\ncRBQsJdwcZqLu9oNUVgaMAwGCCqGSM49BAMDBQADaAAwZQIxAJta0PQ2p4DIu/ps\nLMdLCDgQ5UH1l0B4PGhBlMgdi2zf8nk9spazEQI/0XNwpft8QAIwHSuA2WelVi/o\nzAlF08DnbJrOOtOnQq5wHOPlDYB4OtUzOYJk9scotrEnJxJzGsh/\n-----END CERTIFICATE-----\n",
        "bundle-name": "com.samples.dlp",
        "apl": "normal",
        "app-feature": "hos_system_app"
    },
    "acls": {
        "allowed-acls": [
            "ohos.permission.FILE_ACCESS_MANAGER",
            "ohos.permission.STORAGE_MANAGER",
            "ohos.permission.GET_BUNDLE_INFO_PRIVILEGED",
            "ohos.permission.ACCESS_DLP_FILE",
            "ohos.permission.MANAGE_DISTRIBUTED_ACCOUNTS",
            "ohos.permission.MANAGE_LOCAL_ACCOUNTS",
            "ohos.permission.MANAGE_LOCAL_ACCOUNTS",
            "ohos.permission.GET_LOCAL_ACCOUNTS"
        ]
    },
    "permissions": {
        "restricted-permissions": []
    },
    "issuer": "pki_internal"
}
```
（7）签名应用（需要配置java环境）
hdc uninstall com.samples.dlp<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;新建一个记事本文件，命名为签名证书.bat，bat内容为：
```
java -jar hap-sign-tool.jar sign-profile -keyAlias "openharmony application profile release" -signAlg "SHA256withECDSA"  -mode "localSign" -profileCertFile "OpenHarmonyProfileRelease.pem" -inFile "UnsgnedReleasedProfileTemplate.json" -keystoreFile "OpenHarmony.p12" -outFile "app1-profile.p7b" -keyPwd "123456" -keystorePwd "123456"
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;新建一个记事本文件，命名为签名证书.bat，bat内容为：
```
java -jar hap-sign-tool.jar sign-app -keyAlias "openharmony application release" -signAlg "SHA256withECDSA"  -mode "localSign" -appCertFile "OpenHarmonyProfileRelease.pem" -profileFile "app1-profile.p7b" -inFile "entry-default-unsigned.hap" -keystoreFile "OpenHarmony.p12" -outFile "app1-signed.hap" -keyPwd "123456" -keystorePwd "123456"
```
（8）依次运行签名证书.bat和签名应用.bat，当前目录会产生一个文件app1.signed.hap<br>
（9）执行Build Hap(s)，顺利编译后，产生entry-default-unsigned.hap；将entry-default-unsigned.hap移到目录 .\developtools_hapsigner-master\dist下<br>
（10）安装应用<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hdc install app1-signed.hap<br>
（11）如果之后更改了DLP samples项目，再次执行Build Hap(s)，然后将entry-default-unsigned.hap移到目录 .\developtools_hapsigner-master\dist下，运行签名应用.bat，执行hdc install app1-signed.hap