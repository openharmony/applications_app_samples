#  剪贴板Sample 

### 介绍

 本示例主要使用[@ohos.pasteboard](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-basic-services-kit/js-apis-pasteboard.md) 展示了剪贴板的能力，包括基础功能、支持查询剪贴板数据类型、支持查询剪贴板数据是否来自跨设备、使用系统安全控件读取剪贴板、通过ctrl v访问剪贴板数据。 


### 效果预览

|首页|选择媒体类型|显示文件信息|
|--------------------------------|--------------------------------|--------------------------------|
|![image](screenshots/first.png)|![image](screenshots/select_type.png)|![image](screenshots/display_file.png)|

使用说明
1. 在主界面，点击“Please select a media file”进入选择媒体类型的主页面；
2. 在选择媒体类型界面，点击“下拉列表”，在展开的列表中可以选择一种媒体类型，如“Audios”，下面的列表中显示预制文件夹中所有归属于Audio的文件；
3. 在选择媒体类型界面，点击文件列表中某个文件，跳转到“显示文件信息”界面，该界面中显示文件归属类型的图标和文件名；
4. 在选择媒体类型界面，点击返回箭头图标，返回到“选择媒体类型”界面。

### 工程目录

```
entry/src/main/ets/
|---entryAbility
|---pages|   
|   |---Index.ets                  // 首页
```

### 具体实现

#### 场景一：基础功能场景

为本示例新增文件夹和媒体文件功能封装在createPrecastFile，源码参考：[index.ets](entry/src/main/ets/pages/Index.ets)。

  * 使用fs.accessSync来检查文件或文件夹是否已存在;

  * 使用fs.mkdirSync创建文件夹，文件夹在应用的沙箱目录files下创建;

  * 遍历文件名数组precastFiles，使用fs.accessSync检查文件是否已存在;

  * 使用fs.openSync创建上一步检查结果为不存在的文件;

  * 本功能在首页的aboutToAppear接口中调用。
    
#### 场景二：查询剪贴板数据类型

选中媒体类型，在所有预置文件中查找归属于该类型的文件功能封装在UpdateSelectedFileList，源码参考：[selectMediaType.ets](entry/src/main/ets/pages/selectMediaType.ets) 。

  * 使用fs.listFileSync获取指定目录下的所有文件保存在数组中;

  * 遍历数组中每个文件，调用函数lastIndexOf获取文件后缀位置，再使用接口substring获取文件的后缀；

  * 使用getUniformDataTypeByFilenameExtension获取文件的utd；

  * 使用getTypeDescriptor获取标准化数据类型；

  * 使用接口belongsTo检查文件是否归属于选中的媒体类型，如果返回值为true，则将改文件名保存在显示数组中；

  * 通过标准化数据类型的属性iconFile，获取标准化数据类型的默认图标资源ID；

  * 上述接口的使用参考[@ohos.data.uniformTypeDescriptor](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkdata/js-apis-data-uniformTypeDescriptor.md)。

#### 场景三：查询剪贴板数据是否来自跨设备

#### 场景四：通过安全控件的粘贴按钮访问剪贴板数据

#### 场景五：通过ctrl v访问剪贴板数据

    

### 相关权限

[ohos.permission.READ_PASTEBOARD](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionread_pasteboard) 允许应用访问剪贴板

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例为Stage模型，仅支持API12版本SDK，SDK版本号(API Version 12 Release),镜像版本号(OpenHarmony 5.0.0.25及更高版本)。
3. 本示例需要使用DevEco Studio 版本号(4.1Release)及以上版本才可编译运行。
4. 本示例涉及调用系统权限的接口，需要配置允许权限列表，可以参考[特殊权限配置方法](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/) ，在配置文件中的“allowed-acls”字段中增加"ohos.permission.READ_PASTEBOARD"权限，ohos.permission.REQUIRE_FORM为system_basic级别。

### 下载

如需单独下载本工程，执行如下命令：

    git init
    git config core.sparsecheckout true
    echo code/BasicFeature/DataManagement/pasteboard/ > .git/info/sparse-checkout
    git remote add origin https://gitee.com/openharmony/applications_app_samples.git
    git pull origin master
