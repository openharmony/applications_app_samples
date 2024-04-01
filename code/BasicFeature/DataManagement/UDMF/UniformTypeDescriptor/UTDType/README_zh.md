#  标准化数据定义与描述 

### 介绍

 本示例主要使用[@ohos.data.uniformTypeDescriptor](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkdata/js-apis-data-uniformTypeDescriptor.md) 展示了标准化数据定义与描述的功能，在新增预置媒体文件后，对媒体文件的utd标准类型获取、utd类型归属类型查询、获取文件对应的utd类型的默认图标、支持自定义数据类型等功能。 实现过程中还使用到[@ohos.file.fs](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-fs.md) 、[@ohos.router](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/js-apis-router.md)等接口。


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

### 具体实现

#### 新增文件夹和媒体文件功能

为本示例新增文件夹和媒体文件功能封装在createPrecastFile，源码参考：[index.ets](entry/src/main/ets/pages/Index.ets)。

  * 使用fs.accessSync来检查文件或文件夹是否已存在;

  * 使用fs.mkdirSync创建文件夹，文件夹在应用的沙箱目录files下创建;

  * 遍历文件名数组precastFiles，使用fs.accessSync检查文件是否已存在;

  * 使用fs.openSync创建上一步检查结果为不存在的文件;

  * 本功能在首页的aboutToAppear接口中调用。
    
#### 查找文件归属类型

选中媒体类型，在所有预置文件中查找归属于该类型的文件功能封装在UpdateSelectedFileList，源码参考：[selectMediaType.ets](entry/src/main/ets/pages/selectMediaType.ets) 。

  * 使用fs.listFileSync获取指定目录下的所有文件保存在数组中;

  * 遍历数组中每个文件，调用函数lastIndexOf获取文件后缀位置，再使用接口substring获取文件的后缀；

  * 使用getUniformDataTypeByFilenameExtension获取文件的utd；

  * 使用getTypeDescriptor获取标准化数据类型；

  * 使用接口belongsTo检查文件是否归属于选中的媒体类型，如果返回值为true，则将改文件名保存在显示数组中；

  * 通过标准化数据类型的属性iconFile，获取标准化数据类型的默认图标资源ID；

  * 上述接口的使用参考[@ohos.data.uniformTypeDescriptor](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkdata/js-apis-data-uniformTypeDescriptor.md)。


### 自定义数据类型的支持
#### 自定义数据类型的实现

- 在dev_eco开发时的资源配置目录中添加自定义数据类型配置文件utd.json5，路径：entry/src/main/resources/rawfile/arkdata/utd;

- utd.json5中新建自定义数据类型数组UniformDataTypeDeclarations；

- 数组中每个对象包含"typeId"，"belongingToTypes"，"FilenameExtensions"，"mimeTypes"，"description"，"referenceURL"6个属性字段。

#### 针对自定义类型各字段的相关要求和限制

+ **typeId：** 定义标准化数据类型的ID，该ID具有唯一性，由应用bundleName + 具体类型名组成，不可缺省，允许包含数字、大小写字母、-和.。

+ **belongingToTypes：** 定义标准化数据类型的归属关系，即该标准化数据类型归属于哪个更高层级的类型，所属类型可以为多个，但是必须为已存在的数据
  类型（标准化数据类型预置类型或其他新增自定义数据类型），不能为应用自定义类型本身，不能为空，且与现有标准化数据类型、其他新增自定义数据类型不能形成环形依赖结构。

+ **FilenameExtensions：** 应用自定义标准化数据类型所关联的文件后缀。可以缺省；可以为多个，每个后缀为以.开头且长度不超过127的字符串。

+ **mimeTypes：** 应用自定义标准化数据类型所关联的web消息数据类型。可以缺省；可以为多个，每个类型为长度不超过127的字符串。

+ **description：** 应用自定义标准化数据类型的简要说明。可以缺省；填写时，长度为不超过255的字符串。

+ **referenceURL：** 应用自定义标准化数据类型的参考链接URL，用于描述类型的详细信息。可以缺省；填写时，长度为不超过255的字符串。

    

### 相关权限

[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionread_media)

[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionwrite_media)

[ohos.permission.FILE_ACCESS_MANAGER](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionfile_access_manager)

[ohos.permission.STORAGE_MANAGER](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionstorage_manager)

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例为Stage模型，仅支持API11版本SDK，SDK版本号(API Version 11 Release),镜像版本号(4.0Release)。
3. 本示例涉及使用系统接口：@ohos.file.fs中的openSync接口，需要手动替换Full SDK才能编译通过，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/) 。
4. 本示例需要使用DevEco Studio 版本号(4.0Release)及以上版本才可编译运行。
5. 本示例涉及调用系统权限的接口，需要配置允许权限列表，可以参考[特殊权限配置方法](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/) ，在配置文件中的“allowed-acls”字段中增加"ohos.permission.READ_MEDIA", "ohos.permission.WRITE_MEDIA", "ohos.permission.FILE_ACCESS_MANAGER", "ohos.permission.STORAGE_MANAGER"四个权限。
### 下载

如需单独下载本工程，执行如下命令：

    git init
    git config core.sparsecheckout true
    echo code/BasicFeature/DataManagement/UDMF/UniformTypeDescriptor/UTDType/ > .git/info/sparse-checkout
    git remote add origin https://gitee.com/openharmony/applications_app_samples.git
    git pull origin master
