#  标准化数据定义与描述 

### 介绍

 本示例主要展示了标准化数据定义与描述的功能 ，使用[@ohos.data.uniformTypeDescriptor](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-data-uniformTypeDescriptor.md) 、[@ohos.file.fs](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-file-fs.md) 、[@ohos.router](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-router.md)等接口，实现了增添预制媒体文件、媒体文件的utd标准类型获取、utd类型归属类型查询、获取文件对应的utd类型的默认图标、支持自定义数据类型等功能。

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
|---pages
|   |---displayMediaFile.ets       // 显示上一页选中文件的归属类型图标和文件名
|   |---Index.ets                  // 首页
|   |---selectMediaType.ets        // 主页面，提供媒体类型下拉列表，显示选中的媒体类型的所有文件
```

### 具体实现：

* 为本示例新增文件夹和媒体文件功能封装在createPrecastFile，源码参考：[index.ets](entry/src/main/ets/pages/Index.ets)。
    * 使用fs.accessSync来检查文件或文件夹是否已存在;
    * 使用fs.mkdirSync创建文件夹，文件夹在应用的沙箱目录files下创建;
    * 遍历文件名数组precastFiles，使用fs.accessSync检查文件是否已存在;
    * 使用fs.openSync创建上一步检查结果为不存在的文件;
    * 本功能在首页的aboutToAppear接口中调用。
    
* 选中媒体类型，在所有预制文件中查找归属于该类型的文件功能封装在UpdateSelectedFileList，源码参考：[selectMediaType.ets](entry/src/main/ets/pages/selectMediaType.ets) 。
  * 使用fs.listFileSync获取指定目录下的所有文件保存在数组中;
  * 遍历数组中每个文件，调用函数lastIndexOf获取文件后缀位置，再使用接口substring获取文件的后缀；
  * 使用getUniformDataTypeByFilenameExtension获取文件的utd；
  * 使用getTypeDescriptor获取统一类型的描述符；
  * 使用接口belongsTo检查文件是否归属于选中的媒体类型，如果返回值为true，则将改文件名保存在显示数组中；
  * 通过统一文件描述符的属性iconFile，获取统一文件类型的图标文件路径；
  * 上述接口的使用参考[@ohos.data.uniformTypeDescriptor](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-data-uniformTypeDescriptor.md)。

* 自定义数据类型的支持。
    * 在dev_eco开发时的资源配置目录中添加自定义数据类型配置文件utd-adt.json，路径：entry/src/main/resources/rawfile/arkdata/utd;
    * utd-adt.json中新建自定义数据类型数组UniformDataTypeDeclarations；
    * 数组中每个对象包含"typeId"，"belongingToTypes"，"FilenameExtensions"，"mimeTypes"，"description"，"referenceURL"6个属性字段；
    * typeId，自定义的统一数据类型，其前缀必须是当前hap包名，例如，"com.example.UDMF.image"，其中"com.example.UDMF"是包名；
    * belongingToTypes，typeId归属的类型数组，可以是自定义的其它数据类型，也可以是标准数据类型，例如，["general.image"]；
    * FilenameExtensions，属于typeId的文件的后缀数组，例如，[".myImage", ".khImage"]；
    * mimeTypes，模仿类型数组，可不填;
    * description，类型描述;
    * referenceURL，参考链接地址，可不填;

### 相关权限

[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionread_media)

[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionwrite_media)

[ohos.permission.FILE_ACCESS_MANAGER](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionfile_access_manager)

[ohos.permission.STORAGE_MANAGER](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionstorage_manager)

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例为Stage模型，仅支持API11版本SDK，SDK版本号(API Version 11 Release),镜像版本号(4.0Release)。
3. 本示例涉及使用系统接口：@ohos.file.fs中的openSync接口，需要手动替换Full SDK才能编译通过，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/) 。
4. 本示例需要使用DevEco Studio 版本号(4.0Release)及以上版本才可编译运行。
### 下载

如需单独下载本工程，执行如下命令：

    git init
    git config core.sparsecheckout true
    echo code/BasicFeature/DataManagement/UDMF/UniformTypeDescriptor/UTDType/ > .git/info/sparse-checkout
    git remote add origin https://gitee.com/openharmony/applications_app_samples.git
    git pull origin master
