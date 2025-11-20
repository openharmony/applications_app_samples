# 接入ArkTS页面指南文档示例

### 介绍

本示例通过使用[ArkUI开发文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接:

1. [连接ArkTS页面](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ndk-access-the-arkts-page.md)。

### 效果预览

| 首页                        | 
|---------------------------|
| ![](pictures/image01.gif) | 

### 使用说明

1. 在主界面，点击按钮，会出现多行文本组件，且该界面可以滑动。

### 工程目录
```
entry/src/main/cpp/
|---types
|   |---index.d.ts                         //应用启动页，加载承载Native的容器。。
|---ArkUIBaseNode.h                        //节点封装扩展类。
|---ArkUIListItemNode.h                    //节点封装扩展类。
|---ArkUIListNode.h                          //节点封装扩展类。
|---ArkUINode.h                          //节点封装扩展类。
|---ArkUITextNode.h                         //节点封装扩展类。
|---CMakeLists.txt                          //C语言库引用文件。
|---napi_init.cpp                            //与index.d.ts对应的桥接方法对接Native侧的定义处。
|---NativeEntry.cpp                           //桥接方法的Native侧实现。
|---NativeEntry.h                         //桥接方法的Native侧定义。
|---NativeModule.h                          
|---NormalTextListExample.h                    //示例代码文件。

entry/src/main/ets/
|---entryability
|---entrybackupability
|---pages
|   |---index.ets                             //应用启动页，加载承载Native的容器。  
entry/src/ohosTest/
|---ets
|   |---index.test.ets                       // 对应页面测试代码
```

### 具体实现

一、ArkTS侧占位组件配置与Native交互触发
1. 初始化占位组件依赖：创建NodeContent对象（rootSlot），作为Native组件挂载的桥梁；
2. 状态控制显示逻辑：用@State @Watch('changeNativeFlag')修饰showNative变量，变量变化时触发回调；
3. 绑定占位组件：通过ContentSlot(rootSlot)在UI中声明占位区域，与NodeContent绑定；
4. 交互触发Native操作：changeNativeFlag回调中，根据showNative值调用Native接口（createNativeRoot/destroyNativeRoot），传递NodeContent用于挂载/卸载Native组件。

二、Native侧UI组件封装（基类+列表/文本组件）
1. 基类封装通用能力：ArkUIBaseNode封装节点生命周期（析构时移除子节点、释放资源）和树操作（AddChild/RemoveChild）；ArkUINode继承基类，封装通用属性设置（SetWidth/SetBackgroundColor等）；
2. 具体组件封装：ArkUIListNode创建ARKUI_NODE_LIST类型节点，封装滚动条状态设置（SetScrollBarState）；ArkUITextNode创建ARKUI_NODE_TEXT类型节点，封装字体大小、颜色、文本内容等属性设置；

三、Native侧文本列表组件创建与挂载
1. 列表组件初始化：创建ArkUIListNode实例，设置宽高占比（SetPercentWidth(1)/SetPercentHeight(1)）和滚动条显示（SetScrollBarState(true)）；
2. 列表项批量创建：循环生成30个ListItem，每个ListItem中创建TextNode，设置文本内容（std::to_string(i)）、字体大小（16）、颜色（0xFFff00ff）、背景色（0xFFfffacd）等属性；
3. 组件树组装：将TextNode插入ListItem，再将ListItem添加到List，形成完整列表树；
4. 挂载到ArkTS：返回List组件实例，通过NativeEntry::SetRootNode将其添加到NodeContent，完成Native组件挂载。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：Mate70Pro、RK3568。

2.本示例为Stage模型，支持API20版本full-SDK，版本号：5.1.0.107，镜像版本号：OpenHarmony_5.1.0 Release。

3.本示例需要使用DevEco Studio 5.0.5 Release (Build Version: 5.0.13.200， built on May 13, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ButtonList > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````