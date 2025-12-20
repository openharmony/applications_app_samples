# ArkWeb使用非同层渲染

### 介绍

将原生组件内容使用H5实现，直接用Web组件加载页面。但是，用H5开发页面时，需要使用到JS和CSS，甚至一些前端框架进行页面的开发，并且动效和体验都不如原生组件。本篇使用非同层渲染方案。

### 效果图预览

![](./screenshot/device/nonsame.PNG)

### 使用说明

点击打开应用页面显示两列卡片，卡片内容包括图片文字，卡片及其包含的图片文字正常显示。

### 工程目录

``` 
├──entry/src/main/ets                          
│  ├──entryability
│  │  └──EntryAbility.ets               // 程序入口类
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets         // 自定义应用数据转换和迁移模板类
│  ├──mock                              
│  │  └──GoodsMock.ets                  // 构造页面脏数据
│  ├──model
│  │  └──GoodsModel.ets                 // 商品数据结构
│  └──pages        
│     └──Index.ets                      // 应用首页同层渲染
└──entry/src/main/resources             // 应用资源目录
```
### 具体实现

1. 底层使用空白的H5页面，用任意标签进行占位，然后在H5页面上方层叠一个原生组件。原生组件需要在Web组件加载完成后，获取到标签大小位置后，在对应位置展示。 需要在H5侧添加getEmbedSize()方法来获取元素大小，代码详见[nativeembed_view.html](entry/src/main/resources/rawfile/nativeembed_view.html)：

```html
function getEmbedSize() {
    let doc = document.getElementById('nativeSearch');
    return {
      width: doc.offsetWidth,
      height: doc.offsetHeight,
    }
}
```
2. 使用Stack层叠Web组件和SearchComponent组件，代码详见[Index.ets](entry/src/main/ets/pages/Index.ets)：

```javascript
build() {
  Stack() {
    Web({ src: $rawfile('nativeembed_view.html'), controller: this.browserTabController })
      .backgroundColor('#F1F3F5')
      .onPageEnd(() => {
        this.browserTabController.runJavaScript('getEmbedSize()',
          (error, result) => {
          if (result) {
            interface EmbedSize {
              width: number,
              height: number
            }
            let embedSize = JSON.parse(result) as EmbedSize;
            this.searchWidth = embedSize.width;
            this.searchHeight = embedSize.height;
            this.isWebInit = true;
          }
        });
      })
  if (this.isWebInit){
    Column() {
      // Because it needs to be displayed according to the actual size of the Web, it needs to wait for the width and height to be obtained after the Web is initialized, and then it needs to be layered on the Web
      SearchComponent({ searchWidth: this.searchWidth, searchHeight: this.searchHeight })
    }
    .zIndex(10)
  }
  }
}
```

### 相关权限

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行;

2. 本示例已适配API20版本SDK，SDK版本号(API Version 20 Release),镜像版本号(5.1.0 Release)。

3. 本示例需要使用DevEco Studio 版本号(5.1.0 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Performance/NonSameLayerRendering/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```