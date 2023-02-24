## 社区共建Sample合入要求

1. 新增Sample功能不能重复于当前已有Sample的功能；
2. 新增Sample的工程推荐使用ArkTS语言编写；
3. 新增Sample的工程推荐使用Stage模型编写；
4. 新增Sample的工程中需要包含UI自动化用例（ohosTest工程模块），覆盖基本的功能场景；
5. 新增Sample需要遵循[代码提交规范](#section1)、[工程结构规范](#section2)、[PR提交格式规范](#section3)、[ReadMe编写规范](#section4)和[UI自动化用例编写规范](#section5)；
6. 新增Sample的UX设计需要符合[一多规范要求](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/key-features/multi-device-app-dev/Readme-CN.md)；
7. 新增Sample推荐使用当前最新版本IDE和SDK版本；
8. 工程合入时，需要提供测试用例报告，包括测试场景、操作步骤和测试结果信息，可以附在提交工程中；

## 代码规范<a name="section1"></a>

1. 所有文件，包括自动生成的编译文件package.json都要格式化（IDE快捷键Ctrl+Alt+L）；
2. 函数命名，C++大驼峰，TS、JS小驼峰，函数命名注意动宾结构；
3. 静态常量需使用全大写，文件目录使用全小写（不建议包含特殊字符如"-"和"_"等）；
4. 类名使用大驼峰，函数的参数、全局变量和局部变量都使用小驼峰，命名要规范化，见名知意；
5. if语句后必须跟“{”，哪怕只有一行代码；
6. 有break或return的条件，先break或return再走其他的逻辑；
7. 条件判断，当一个分支达成条件时及时返回，不需要再走其他分支；
8. 代码中避免出现魔鬼数字，需补上注释，或者用符合语义的名词常量代替，如下：
```ts
  // One minute has 60 seconds.
  let time = 60

  const ONE_MINUTE = 60
  let time = ONE_MINUTE
```
9. 字符串拼接使用模板字符串；
10. 组件使用，除了宽高属性可以在一行，其他的属性必须换行；
11. TS、JS中关于是否添加";"的问题，风格要统一，建议添加";"；
12. 字符串和图片资源等的使用，支持"$r"使用的，全部使用"$r"引用；
13. 新增文件注意开源协议、版权检查；
14. 截图要使用真机效果图；
15. readme中使用“.”，不要用“、”，检查错别字；
16. 异步方法中需要返回方法的返回值，不用声明变量，直接return，如下：
```ts
  return await this.mediaTest.getFileAssets(fetchOp)
```
17. 方法中的参数需要类型声明；
18. import 文件顺序，同类型放一起；
19. string.json中description要写简要描述，zh下要用中文；
20. TS、JS语言缩进为2格，C++语言缩进为4格；
21. 涉及应用截图时，图片不能包含人物、关键信息、网络等有侵权风险的资源；
22. 工程中不要配置签名信息，禁止上传local.properties和package-lock.json等系统自动生成的文件；
23. 规范日志格式，统一用[Sample_包名]开头，如时钟日志，使用[Sample_Clock]，日志打印需要使用Hilog接口，建议封装单独的[Logger类](https://gitee.com/openharmony/applications_app_samples/blob/master/MultiDeviceAppDev/Weather/product/src/main/ets/util/Logger.ts)，示例如下：
```ts
import hilog from '@ohos.hilog'
...
class Logger {
  private domain: number = 0xFF00
  private prefix: string = '[Sample_Clock]'
  private format: string = '%{public}, %{public}'
  ...
  debug(...args: any[]) {
    hilog.debug(this.domain, this.prefix, this.format, args)
  }
  ...
}
```
24. 注释“//”后要加一个空格；如果注释跟在代码后面，则“//”前要加一个空格；
```ts
  // 正确示例
  let a = 10

  let a = 10 // 正确示例
```
25. 代码中避免出现中文字符，要使用资源代替，符合国际化开发标准；
26. 应用包名统一使用“com.samples.xxx”，“xxx”为特性名称；

## ReadMe编写规范<a name="section4"></a>

1. 标题：以特性名称命名；
2. 介绍：介绍sample用了哪些包，具有哪些功能，给出完整包名并附上链接；

3. 效果预览：屏幕截屏或者视频，文件不超过4个；

   3.1 使用说明：介绍应用的使用说明，具体的操作步骤和用法信息，示例如下：

    1. 在主界面，可以点击图片、视频、文档、音频等按钮进入对应目录的文件列表浏览界面；
    2. 在文件列表浏览界面，点击“+”按钮，可以添加文件；
    3. 在文件列表浏览界面，长按列表项会出现删除图片，点击删除图标可以删除文件；
    4. 在图片文件列表界面，点击图片可以进入图片预览界面。


4. 工程目录：给出项目中关键的目录结构并描述它们的作用，示例如下：

   ```
   entry/src/main/ets/
   |---Application
   |---filemanager
   |   |---data
   |   |   |---FileDataSource.ets             // 懒加载数据格式
   |   |---pages
   |   |   |---audio
   |   |   |   |---AudioFileList.ets          // 音频列表页面
   |   |   |---common
   |   |   |   |---FileList.ets               // 同类型文件列表展示页面，接收文件类型，展示特定类型的文件列表
   |   |   |---document
   |   |   |   |---DocumentFileList.ets       // 文档列表页面
   |   |   |---image
   |   |   |   |---ImageFileList.ets          // 图片列表页面
   |   |   |   |---ImagePreview.ets           // 图片预览页面
   |   |   |---video
   |   |   |   |---VideoFileList.ets          // 视频列表页面
   |   |   |---FileManagerHome.ets            // 首页主体内容
   |---MainAbility
   |---pages
   |   |---index.ets                          // 首页
   Library/src/main/ets/
   |---filemanager
   |   |---components
   |   |   |---ThumbnailImage.ets             // 缩略图组件
   |   |---fileio
   |   |   |---FileIoManager.ts               // 文件管理，待开发
   |   |---medialibrary
   |   |   |---MediaLibraryManager.ts         // 主要封装了mediaLibrary库相关的接口，实现相关功能，如：对文件的增、删、查和图片预览功能
   |   |---userfilemanager
   |   |   |---UserFileManager.ts             // 封装userFileManager库相关的接口
   |   |---FileManager.ts                     // 文件管理接口，统一封装了各模块对外提供的功能接口
   |---mock                                   // 本地数据
   |---utils                                  // 日志工具
   ```
5. 具体实现：
   先描述功能都在哪个模块，再具体描述如何实现这些功能的，以及在哪里使用他们，附上文件链接；示例如下：
    * 增添文件、删除文件、查找指定类型文件文件和预览图片的功能接口封装在MediaLibraryManager，源码参考：[MediaLibraryManager.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/FileManager/FileManager/Library/src/main/ets/filemanager/medialibrary/MediaLibraryManager.ts)
        * 使用mediaLibrary.getMediaLibrary来获取MediaLibrary对象;
        * 读取每个文件的数据：使用MediaLibrary.getFileAssets读取满足条件的文件集合FetchFileResult，然后调用FetchFileResult.getFirstObject();
        * 创建模拟文件：使用MediaLibrary.getPublicDirectory()获取系统预定的目录，然后使用MediaLibrary.createAsset();
        * 删除指定路径的文件：使用MediaLibrary.deleteAsset();
        * 获取预览图：使用image.createImageSource()创建指定的文件资源ImageSource，然后调用ImageSource.createPixelMap()，接口参考：[@ohos.multimedia.image](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-image.md) 。

    * 在Library模块中通过封装FileManager向外提供功能接口，如MediaLibraryManager.getPixelMapByFileAsset()，源码参考：[FileManager.ts](https://gitee.com/openharmony/applications_app_samples/blob/master/FileManager/FileManager/Library/src/main/ets/filemanager/FileManager.ts)
        * 如效果预览中的**图片列表**，读取指定类型的文件：在[FileList.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/FileManager/FileManager/entry/src/main/ets/filemanager/pages/common/FileList.ets)
          中调用FileManager.getFileAssets()；
        * 创建模拟文件：在[FileList.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/FileManager/FileManager/entry/src/main/ets/filemanager/pages/common/FileList.ets)
          中调用FileManager.createTxtFileAsset()；
        * 删除指定路径的文件：在[FileList.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/FileManager/FileManager/entry/src/main/ets/filemanager/pages/common/FileList.ets)
          中调用FileManager.deleteFileAsset()；
        * 获取缩略图：在[ThumbnailImage.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/FileManager/FileManager/Library/src/main/ets/filemanager/components/ThumbnailImage.ets) 中调用FileManager.getThumbnail()；
        * 如效果预览中的**图片预览**，获取预览图：在[ImagePreview.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/FileManager/FileManager/entry/src/main/ets/filemanager/pages/image/ImagePreview.ets) 中调用FileManager.getPixelMapByFileAsset()。
6. 相关权限：介绍应用的使用权限，附上链接；
7. 依赖： 介绍对其他sample的依赖，附上sample链接；
8. 约束与限制：

   6.1 支持应用运行的操作系统版本和设备，示例如下：

        本示例仅支持标准系统上运行，支持设备：RK3568;

   6.2 API版本、SDK版本（如果依赖Full SDK，附上替换链接），示例如下：

        本示例仅支持APIXX版本SDK，版本号：3.X.X.X；（如果涉及Full SDK还需加上：本涉及涉及使用系统接口：XXX，需要手动替换Full SDK才能编译通过，具体操作可参考[替换指南]。）

   6.3 支持的IDE版本，示例如下：

        本示例需要使用DevEco Studio 3.0 Beta4 (Build Version: 3.0.0.992, built on July 14, 2022)才可编译运行；

   6.4 高等级APL特殊签名说明，示例如下：

        本示例涉及[相关权限]为system_basic(或者system_core)级别（相关权限级别可通过[权限定义列表]查看），需要配置高权限签名，可参考[特殊权限配置方法]；

9. 下载：给出单独下载本工程的命令，在代码中替换工程目录并以/结尾，如下面示例中的 **FileManager/FileManager**，示例如下：

   如需单独下载本工程，执行如下命令：

    ```
    git init
    git config core.sparsecheckout true
    echo FileManager/FileManager/ > .git/info/sparse-checkout
    git remote add origin https://gitee.com/openharmony/applications_app_samples.git
    git pull origin master
    ```
[ReadMe模板链接](SampleReadTemplate.md)

## 工程结构规范<a name="section2"></a>

Sample工程，应该区分开场景业务逻辑和特性相关封装接口，规则如下：

1. 包名命名规则为"com.samples.特性名"，工程名命名规则为特性名称，与Readme标题保持一致；
2. 特性接口封装放在Library模块下，能够独立编译成har包复用；
3. 场景业务逻辑，展示Library模块中特性接口的使用，放在entry目录中；
4. entry/src/main/ets/目录下的pages目录中，只放一个Index.ets，作为入口页面；
5. entry/src/main/ets/目录下创建场景业务目录，存放该场景相关的业务逻辑和页面代码；
6. Library/src/main/ets/目录下创建特性目录，目录下包括components（对外开放的控件目录）、feature（特性封装逻辑目录）、Feature.ts（对外开放的特性接口）等；

以FileManager特性为例，工程示例结构如下：

```
entry/src/main/ets/ 		// 场景业务逻辑放在entry目录下
|---Application 			// 应用级逻辑
|---MainAbility 			// 元能力组件
|---filemanager 			// 场景业务功能（如果存在多个场景，则放在同级目录下）
|   |---data 				// 场景业务逻辑相关类或数据
|   |---pages 				// 场景业务逻辑相关页面
|---pages 					// UI页面
|   |---Index.ets 			// pages下只保留一个Index.ets，作为入口页面
|---utils 					// 共用的工具类或者模块
Library/src/main/ets/ 		// 特性接口封装放在Library模块下，能够独立编译成har包复用
|---filemanager 			// 特性相关封装类
|   |---components 			// 特性相关UI控件类，需要对外开放（部分特性涉及对外提供复用UI控件）
|   |   |---FileImage.ets
|   |---fileio 				// 封装了特性相关接口，如果存在多个模块，放在多个目录下如fileio、medialibrary、userfilemanager，不对外开放
|   |   |---FileIoManager.ts
|   |---medialibrary
|   |---userfilemanager
|   |---FileManager.ts 		// 对外开放的特性接口，无具体实现（实现在fileio、medialibrary等模块中）
|---mock 					// 模拟数据
|---utils 					// 特性相关工具类
```

## UI自动化用例编写规范<a name="section5"></a>

1. 用例命名规范为：“包名_测试功能_序号”，如“MyApp_StartAbility_001”，序号表示测试StartAbility功能的第1个用例;
2. 用例的开头和结尾都需要有日志打印；
3. 打印必须包括用例名称的关键字，用例中每条断言语句前必须添加日志，打印参数信息；
4. DOMAIN设置为0xF811；
5. 用例名称中的包名和日志中的包名单独用常量表示，方便包名变更整改；
6. 每条用例前需要添加注释；
```ts
  import hilog from '@ohos.hilog';
  ...
  const TAG = '[Sample_MyApp]'
  const DOMAIN = 0xF811
  const BUNDLE = 'MyApp_'
  ...
  
  /**
   * 介绍用例测试的功能和场景等信息
   */
  it(BUNDLE + 'StartAbility_001', function() {
    hilog.info(DOMAIN, TAG, BUNDLE + "StartAbility_001, begin")
    ...
	// 介绍单一步骤的功能
    hilog.info(DOMAIN, TAG, BUNDLE + "StartAbility_001, code:" + code)
    expect(0).asserEqual(code)
    ...
    hilog.info(DOMAIN, TAG, BUNDLE + "StartAbility_001, end")
  })
```

## PR提交格式规范<a name="section3"></a>

示例如下：

```
IssueNo: #I56EH7:关联问题
Description: 描述问题.
Sig: sig-systemapplications
Feature or Bugfix: Bugfix
Binary Source: No

Signed-off-by: jiangwensai <jiangwensai@huawei.com>
```

1. IssueNo管理issue信息；
2. Description描述修改变更内容；
3. Sig统一使用SIG_Sample；
4. Feature or Bugfix，如果是需求选择Feature，问题选择Bugfix；
5. Signed-off-by，注明开发者账号和邮箱；