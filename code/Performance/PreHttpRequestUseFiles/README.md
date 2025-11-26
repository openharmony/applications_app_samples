# Image白块解决指导

### 简介

本示例主要解决使用原生Image组件加载大的网络图片时，出现长时间Image白块的问题。

| 正例 | 反例                                                    |
|---|-------------------------------------------------------|
|<img src="screenshots/devices/show.gif" width="300">| <img src="screenshots/devices/show2.gif" width="300"> |


### 使用说明
*注意*：工程运行需要修改代码，需将工程中图片的网络地址替换为真实url路径，修改地址详见[MainPage.ets](entry/src/main/ets/pages/MainPage.ets)，
[NetRequest.ets](entry/src/main/ets/utils/NetRequest.ets)。

1、在父组件里aboutToAppear()中提前发起网络请求，当父页面点击按钮跳转子页面PageOne，此时触发pixMap请求读取应用沙箱中已缓存解码的网络图片并存储在localStorage中。非首次点击时，不再重复调用getPixMap()，避免每次点击都从沙箱里读取文件。

```javascript
import { fileIo as fs } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { httpRequest } from '../utils/NetRequest';
import Logger from '../utils/Logger';

// Obtain the path of the application file
const uiContext: UIContext | undefined = AppStorage.get('uiContext');
let context: common.UIAbilityContext = uiContext?.getHostContext() as common.UIAbilityContext;
let filesDir: string = context.filesDir;
let fileUrl: string = filesDir + '/abc.png'; // The image's network address suffix needs to be replaced by the real url.
let para: Record<string, PixelMap | undefined> = { 'imageData': undefined };
let localStorage: LocalStorage = new LocalStorage(para);
const TAG: string = '[GetPixMapFunc]';

@Entry(localStorage)
@Component
struct MainPage {
  @State childNavStack: NavPathStack = new NavPathStack();
  @LocalStorageLink('imageData') imageData: PixelMap | undefined = undefined;

  getPixMap() { // Read files from the application sandbox
    try {
      let file: fs.File = fs.openSync(fileUrl, fs.OpenMode.READ_WRITE); // Open the file in a synchronous manner
      const imageSource: image.ImageSource = image.createImageSource(file.fd);
      const options: image.InitializationOptions = {
        'alphaType': 0, // transparency
        'editable': false, // Editable or not
        'pixelFormat': 3, // Pixel format
        'scaleMode': 1, // Abbreviated value
        'size': { height: 100, width: 100 }
      };
      fs.close(file)
      imageSource.createPixelMap(options).then((pixelMap: PixelMap) => {
        this.imageData = pixelMap;
      });
    } catch (e) {
      Logger.error(TAG, 'Resource loading error, file or does not exist!');
    }
  }

  aboutToAppear(): void {
    httpRequest(); // Initiate a network request ahead of the parent component
  }

  build() {
    Navigation(this.childNavStack) {
      Column() {
        Button('push Path to pageOne', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin({ bottom: '36vp' })
          .onClick(() => {
            // Do not call getPixMap() repeatedly except for the first click to avoid reading files from the sandbox with each click.
            if (!localStorage.get('imageData')) {
              this.getPixMap();
            }
            this.childNavStack.pushPath({ name: 'pageOne' });
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.End)
    }
    .backgroundColor(Color.Transparent)
    .title('ParentNavigation')
  }
}
```

2、在NetRequest.ets中定义网络请求httpRequest()，通过fs.access()检查文件是否存在，当文件存在时不再重复请求，并写入沙箱中。

```javascript
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';

// Obtain the path of the application file
const uiContext: UIContext | undefined = AppStorage.get('uiContext');
let context: common.UIAbilityContext = uiContext?.getHostContext() as common.UIAbilityContext;
let filesDir: string = context.filesDir;
let fileUrl: string = filesDir + '/abc.png'; // The image's network address suffix needs to be replaced by the real url.

export async function httpRequest() {
  fs.access(fileUrl, fs.AccessModeType.READ).then((res) => { // Check whether files exist
    if (!res) { // If the address does not exist in the sandbox, re-request the network image resource
      http.createHttp()
        // Please fill in a specific network image address here, example: https://raw.gitcode.com/openharmony/applications_app_samples/blobs/59b99cbd79be8c4f540382b3a6161587eecc3cd4/eraser_picture.jpg
        // If you fill in the real address, you need to replace the global fileUrl with the real address suffix.
        .request('https://raw.gitcode.com/openharmony/applications_app_samples/blobs/59b99cbd79be8c4f540382b3a6161587eecc3cd4/eraser_picture.jpg',
          (error: BusinessError, data: http.HttpResponse) => {
            if (error) {
              // If the download fails, no subsequent logic is executed
              return;
            }
            // Processing data returned by network requests
            if (http.ResponseCode.OK === data.responseCode) {
              const imageData: ArrayBuffer = data.result as ArrayBuffer;
              // Save the image to the app sandbox
              readWriteFileWithStream(imageData);
            }
          }
        )
    }
  })
}

// Write to the sandbox
async function readWriteFileWithStream(imageData: ArrayBuffer): Promise<void> {
  let outputStream: fs.Stream = fs.createStreamSync(fileUrl, 'w+');
  await outputStream.write(imageData);
  outputStream.closeSync();
}
```

3、在子组件中通过在子页面的Image中传入被@StorageLink修饰的变量ImageData进行数据刷新，图片送显。

```javascript
@Builder
export function PageOneBuilder() {
  PageOne();
}

@Component
export struct PageOne {
  pageInfo: NavPathStack = new NavPathStack();
  @State name: string = 'pageOne';
  @LocalStorageLink('imageData') imageData: PixelMap | undefined = undefined;

  build() {
    NavDestination() {
      Row() {
        // Positive example: At this time, the Image has obtained the network image that has been loaded in advance,
        // reducing the time for white blocks to appear.
        Image(this.imageData)
          .objectFit(ImageFit.Auto)
          .width('100%')
          .height('100%')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .title(this.name)
  }
}
```


### 工程目录
```
├──entry/src/main/ets
│  ├──entryability
│  │  └──EntryAbility.ets                   // 程序入口类
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets             // 应用数据备份恢复类
│  ├──pages
│  │  ├──MainPage.ets                       // 视图层-父页面
│  │  └──PageOne.ets                        // 视图层-子页面
│  └──utils
│     ├──Logger.ets                         // 日志工具类
│     └──NetRequest.ets                     // 网络请求类
└──entry/src/main/resources                 // 应用静态资源目录
```

### 具体实现

1. 在父组件aboutToAppear()中提前发起网络请求，当父页面点击按钮跳转子页面PageOne，此时触发pixMap请求读取应用沙箱中已缓存解码的网络图片并存储在localStorage中，非首次点击时，不再重复调用getPixMap()，避免每次点击都从沙箱里读取文件。
2. 在NetRequest.ets中定义网络请求httpRequest()，通过fs.access()检查文件是否存在，当文件存在时不再重复请求，并写入沙箱中。
3. 在子组件里：通过在子组件Image中传入被@StorageLink修饰的变量ImageData进行数据刷新，图片送显。
4. 从而通过提前预下载的方式，解决使用Image原生组件加载大的网络图片时，出现长时间Image白块的问题。

### 相关权限

网络权限：ohos.permission.INTERNET

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行;

2. 本示例已适配API20版本SDK，SDK版本号(API Version 20 Release),镜像版本号(5.1.0 Release)。

3. 本示例需要使用DevEco Studio 版本号(5.1.0 Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Performance/PreHttpRequestUseFiles/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
