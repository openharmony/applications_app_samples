# 语言基础类库

### 介绍
本示例集合语言基础类库的各个子模块，展示了各个模块的基础功能，包含：

- [@ohos.buffer (Buffer)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-buffer.md)
- [@ohos.convertxml (xml转换JavaScript)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-convertxml.md)
- [@ohos.process (获取进程相关的信息)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-process.md)
- [@ohos.taskpool (启动任务池)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-taskpool.md)
- [@ohos.uri (URI字符串解析)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-uri.md)
- [@ohos.url (URL字符串解析)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-url.md)
- [@ohos.util (util工具函数)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-util.md)
- [@ohos.util.ArrayList (线性容器ArrayList)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-arraylist.md)
- [@ohos.util.Deque (线性容器Deque)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-deque.md)
- [@ohos.util.HashMap (非线性容器HashMap)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-hashmap.md)
- [@ohos.util.HashSet (非线性容器HashSet)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-hashset.md)
- [@ohos.util.LightWeightMap (非线性容器LightWeightMap)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-lightweightmap.md)
- [@ohos.util.LightWeightSet (非线性容器LightWeightSet)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-lightweightset.md)
- [@ohos.util.LinkedList (线性容器LinkedList)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-linkedlist.md)
- [@ohos.util.List (线性容器List)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-list.md)
- [@ohos.util.PlainArray (非线性容器PlainArray)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-plainarray.md)
- [@ohos.util.Queue (线性容器Queue)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-queue.md)
- [@ohos.util.Stack (线性容器Stack)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-stack.md)
- [@ohos.util.TreeMap (非线性容器TreeMap)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-treemap.md)
- [@ohos.util.TreeSet (非线性容器TreeSet)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-treeset.md)
- [@ohos.util.Vector (线性容器Vector)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-vector.md)
- [@ohos.xml (xml解析与生成)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-xml.md)

### 效果预览

|                   **主页**                |             **Util**             |                 ConvertXml                 |
| :---------------------------------------: | :---------------------------------------: | :--------------------------------------: |
|    ![home](screenshots/devices/home.jpg)    | ![util](screenshots/devices/util.jpg) | ![convertxml](screenshots/devices/convertxml.jpg) |

使用说明

1.首页展示语言基础类库各个子模块菜单，点击进入对应的模块页面。

2.各个子模块界面中点击功能按钮完成各个功能。

3.Util中有二级菜单，点击进入对应的二级界面，包含：

* StringCode：字符串编解码，点击功能按钮完成各个功能。
* RationnalNumber：有理数比较，点击功能按钮完成各个功能。
* LRUCache：LRU缓冲区，点击功能按钮完成各个功能。
* ScopeHelper：范围判断，点击功能按钮完成各个功能。
* Base64Helper：Base64编解码，点击功能按钮完成各个功能。
* TypeCheck：类型检查，点击功能按钮完成各个功能。

4.ArrayList界面中，点击+号添加数据后展示数据，点击删除按钮删除对应的一条数据。

### 工程目录

```
LanguageBaseClassLibrary
├── AppScope                                    
│   └── app.json5                               //APP信息配置文件
├── entry/src/main                              //语言基础类库应用首页
│   ├── ets
│   │   ├── entryability
│   │   ├── pages
│   │   │   ├── Index.ets                       //主页入口
│   │   │   ├── compnents                       
│   │   │   │   └── Capabilities.ets            //根据点击的菜单，展示对应的子界面
│   └── module.json5
│ 
├── common/src/main                             //公共组件及工具类
│   ├── ets
│   │   ├── components
│   │   │   └── CustomDataSource.ets            //自定义DataSource，LazyForEach时使用
│   │   ├── util
│   │   │   ├── Logger.ets                      //日志工具类
│   │   │   └── ResourceUtil.ets                //资源管理工具类
│   └── module.json5
│
├── menuitems/src/main                          //菜单
│   ├── ets
│   │   ├── Index.ets                           //对外提供的接口列表
│   │   ├── menulist                            //菜单组件
│   │   │    └── MenuList.ets                  
│   │   ├── components                          //菜单相关自定义组件
│   └── module.json5
│
├── capabilities/src/main                       //功能集
│   ├── ets
│   │   ├── capabilities                        //各个子模块功能组件
│   │   ├── components                          //子模块相关组件
│   │   │   ├── arraylistcomponents             //arraylist相关组件
│   │   │   └── utilcomponents                  //util相关组件
│   │   │   └── ColumnOperation.ets             //展示一列功能按钮的组件
│   │   │   └── GridOperation.ets               //根据窗口大小展示不同列的功能按钮的组件
│   │   ├── model                               //相关数据模型
│   │   └── utils                               //相关工具类
│   └── module.json5
```

### 具体实现

1.首页菜单展示：使用一个module，menuitems完成菜单组件的实现，传入要展示的菜单的strarray类型的资源和菜单点击对应的组件即可。使用Navigation和NavRouter组件实现菜单点击进入功能界面，使用LocalStorage实现应用内Ability内数据共享，点击菜单时标记selectedLabel，在entry中的Capabilities组件中，通过selectedLabel显示对应的功能组件。

2.Xml & ConvertXml：使用[xml](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-xml.md)和[convertxml](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-convertxml.md)实现xml的解析和生成以及xml转换为js对象，点击按钮实现对应的功能。

3.Process：使用[process](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-process.md)实现获取进程相关信息的功能，点击按钮实现对应的功能。

4.Url：使用[URL](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-url.md)对URL字符串的查找参数进行了增删改查的一系列操作，使得读者对URL的结构用途更加明了，点击按钮实现对应的功能。

5.Util，使用util中不同的功能函数实现以下功能：

* StringCode：字符串编解码。
* RationnalNumber：有理数比较。
* LRUCache：LRU缓冲区。
* ScopeHelper：范围判断。
* Base64Helper：Base64编解码。
* TypeCheck：类型检查。

5.ArrayList：展示线性容器ArrayList的数据类型的使用，包括添加、删除。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例适配API10版本SDK，版本号：4.0.5.1。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.200, built on November 3, 2022)才可编译运行。

###  下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/LaunguageBaseClassLibrary/LanguageBaseClassLibrary/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```