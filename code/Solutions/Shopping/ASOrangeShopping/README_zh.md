# 橘子购物元服务

### 介绍
本示例是一个原子化服务，已适配免安装特性；

本示例借助HSP包共享机制，实现了视频播放、搜索、编辑购物车信息等功能的多包共享；

本示例已适配ArkTs卡片，通过卡片能够拉起应用主页。

### 效果预览

|                   **主页**                |                **用户中心页**             |                 **购物车页**                 |
| :---------------------------------------: | :---------------------------------------: | :--------------------------------------: |
|    ![Home](screenshots/device/Home.jpeg)    | ![UserCenter](screenshots/device/UserCenter.jpeg) | ![ShoppingCart](screenshots/device/ShoppingCart.jpeg)  |
|              **商品详情页**               |                **搜索页**             |              **ArkTs卡片**               |
| ![ProductDetail](screenshots/device/ProductDetail.jpeg) | ![Search](screenshots/device/Search.jpeg) | ![ArkTsCard](screenshots/device/ArkTsCard.jpeg) |

使用说明

1.由于目前服务中心暂未适配免安装特性，所以需要替换预置的预置的服务中心；Launcher目前未适配元服务卡片，所以需要替换安装Launcher。具体替换安装步骤请参看[配置方法]( https://gitee.com/openharmony/applications_app_samples/blob/master/code/Solutions/Shopping/ASOrangeShopping/data/freeinstall/InstallFreeDoc.md )

2.修改```push_hap_hsp.bat```脚本中hdc的路径，使用DevEco Studio，Build App(s)，编译生成hap与hsp包。通过DevEco的Terminal工具，执行```push_hap_hsp.bat```即可将应用文件push到服务中心的的指定目录。

3.通过```hdc shell aa start -b ohos.samples.launcher -a MainAbility```命令启动Launcher。

4.ArkTs卡片：初次打开时，Launcher上会出现一张临时占位图，点击占位图可拉起橘子购物元服务，同时占位图被替换为ArkTs卡片；点击卡片"活动详情"按钮，拉起主页。

5.首页：点击首页上的某一个商品，可直接跳转到具体的商品详情页面；点击用户中心，可跳转到用户中心页；通过底部的导航栏，可以在首页与购物车页之间切换；点击搜索，可以跳转搜索商品信息。

6.搜索页：点击输入内容可触发搜索；点击搜索按钮，会记录本次搜索关键词。

7.购物车页：可以通过具体商品后面的"+"与"-"来更改商品的具体数量，当商品数量为零，删除商品。在下方列表点击具体商品也可以跳转到商品详情。

8.商品详情页：进入页面后会默认开始下载商品视频，下载好后即可播放；用户可以通过点击底部"加入购物车"按钮来将商品添加到购物车当中；可以通过"首页"/"购物车"选项跳转回首页/购物车页

### 工程目录

```
ASOrangeShopping
├── AppScope                                    
│   └── app.json5                               //APP信息配置文件
├── data                                        //商品信息列表与商品图片
├── entry/src/main                              //商品主页
│   ├── ets
│   │   ├── data                                //商品信息
│   │   ├── entryability
│   │   ├── entryformability
│   │   ├── model                               //商品信息数据结构
│   │   ├── pages
│   │   │   ├── Index.ets                       //主页入口
│   │   │   ├── common                          //公共组件，搜索、单个商品、快速选择等
│   │   │   ├── home                            //首页
│   │   │   │   └── Home.ets
│   │   │   └── shoppingcart                    //购物车页
│   │   │       └── ShoppingCart.ets              
│   │   ├── utils
│   │   │   ├── RequestDataUtil.ets             //网络下载工具
│   │   │   └── ShoppingDataUtil.ets            //购物车信息工具
│   │   └── widget
│   │       └── pages
│   │           └── ShoppingCard.ets            //ArkTs卡片
│   └── module.json5
│ 
├── productdetail/src/main                      //商品详情页
│   ├── ets
│   │   ├── mock
│   │   ├── model
│   │   │   └── DetailMode.ets                  //商品信息model
│   │   ├── pages
│   │   │   ├── Index.ets                       //详情页入口
│   │   │   └── common                          //公共组件
│   │   ├── productdetailability
│   │   └── utils                               //工具类
│   └── module.json5
│
├── search/src/main                             //搜索组件
│   ├── ets
│   │   ├── Index.ets                           //对外提供的接口列表
│   │   ├── data
│   │   │    └── GoodsData.ets                  //商品信息列表
│   │   ├── model
│   │   │    └── GoodsModel.ets                 //商品信息数据结构
│   │   ├── pages
│   │   │    ├── SearchPage.ets                 //搜索页
│   │   │    └── common                         //公共组件
│   │   └── utils
│   └── module.json5
│ 
├── shoppingdata/src/main                       //编辑购物车信息模块
│   ├── ets
│   │   ├── Index.ets                           //对外提供的接口列表
│   │   ├── model
│   │   │   └── GoodsModel.ets                  //商品信息数据结构
│   │   ├── utils
│   │   │   ├── DatabaseUtil.ets                //关系型数据库信息交互工具
│   │   │   └── EmitterUtil.ets                 //发布事件工具
│   │   └── pages
│   └── module.json5
│
├── usercenter/src/main                         //用户中心页
│   ├── ets
│   │   ├── data                                //图片信息
│   │   ├── model
│   │   ├── pages
│   │   │   ├── Index.ets                       //用户中心页入口
│   │   │   └── common                          //公共组件
│   │   ├── usercenterability
│   │   └── utils
│   └── module.json5
│
├── video/src/main                              //视频播放模块
│   ├── ets
│   │   ├── Index.ets                           //向外提供的接口
│   │   ├── pages
│   │   │   ├── SmallVideo.ets                  //小窗播放
│   │   │   └── VideoPage.ets                   //轮播图播放
│   │   └── utils
│   └── module.json5
│
├── push_hap_hsp.bat                            //将hsp和hap push到免安装目录下的脚本
└── install.bat                                 //直接安装编译成功的元服务的脚本
```

### 具体实现

1.配置原子化服务：在[app.json5]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/AppScope/app.json5 )文件中配置```"bundleType": "atomicService"```字段

2.配置预加载：

* 在[module.json5]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/entry/src/main/module.json5 )文件中配置```"atomicService"```字段
* 在```"perloads"```标签中添加需要预加载模块的moduleName

2.ArkTs卡片:
* 通过DevEco Studio在需要创建卡片的module上点击鼠标右键选择```New->Service Widget```可进入创建卡片选项卡。在选项卡的```Language```处选择```ArkTs```，按需配置好卡片信息之后，点击```Finish```完成卡片的创建。
* 创建完成后会在对应module的目录下生成对应卡片的[FromAbility]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/entry/src/main/ets/entryformability/EntryFormAbility.ets )与[卡片布局文件]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/entry/src/main/ets/widget/pages/ShoppingCard.ets ).
* 开发者可通过FormAbility来管理卡片的生命周期，响应卡片触发的事件等；通过布局文件快速编辑卡片的外观布局，能够触发的点击事件等。

3.配置Hsp：通过DevEco Studio在项目级目录上点击鼠标右键选择```New->Module```，然后选择```Shared Library```来创建Hsp共享包。

4.依赖Hsp：
* 在需要依赖Hsp的module的[oh-package.json5]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/entry/oh-package.json5 )文件中配置```dependencies```字段，并在其中添加需要依赖的Hsp包的名称与文件位置。
* 在[module.json5]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/entry/src/main/module.json5 )文件中配置```dependencies```字段，其中```moduleName```与上一步中Hspdata包的名称保持一致。
* 在需要使用到Hsp包中页面或者组件的地方直接import来引入对应的文件信息。这里以entry中[ShoppingDataUtil]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/entry/src/main/ets/utils/ShoppingDataUtil.ets )购物车功能为例，通过import引入了[shoppingdata]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/shoppingdata )中的[DatabaseUtil]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/shoppingdata/src/main/ets/utils/DatabaseUtil.ets )与[EmitterUtil]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/shoppingdata/src/main/ets/utils/EmitterUtil.ets )，借助这两个工具实现了添加与删除购物车的功能。
* 也可以通过[router.pushUrl()]( https://docs.openharmony.cn/pages/v3.2Beta/zh-cn/application-dev/reference/apis/js-apis-router.md/ )来跳转到Hsp的某个界面，这里以entry中的[SearchBar]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/entry/src/main/ets/pages/common/SearchBar.ets )为例，在onClick事件中触发跳转到[search]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/search )模块的[SearchPage]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/ASOrangeShopping/search/src/main/ets/pages/SearchPage.ets )界面，来实现商品搜索的功能。

5.免安装的触发：”使用说明“第2步中已经将元服务的hap与hsp文件push到服务中心的免安装路径下。这时开发者可以通过[router.pushUrl()]( https://docs.openharmony.cn/pages/v3.2Beta/zh-cn/application-dev/reference/apis/js-apis-router.md/ )或[startAbility()]( https://docs.openharmony.cn/pages/v3.2Beta/zh-cn/application-dev/application-models/uiability-launch-type.md/ )的方式来触发应用免安装。

### 相关权限

[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissioninternet)

### 依赖

本示例需通过Launcher安装拉起，在编译本示例之前需先安装[Launcher应用]( https://gitee.com/openharmony/applications_app_samples/tree/master/code/SystemFeature/ApplicationModels/Launcher )

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例适配API9版本SDK，版本号：4.0.5.5。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

4.本示例运行时需要连接网络才可以正常加载商品图片与商品视频。

###  下载

如需单独下载本工程，执行如下命令：

```text
git init
git config core.sparsecheckout true
echo code/Solutions/Shopping/ASOrangeShopping/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```