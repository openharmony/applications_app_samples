# 折叠屏扫描二维码方案

### 介绍

本示例介绍使用自定义界面扫码能力在折叠屏设备中实现折叠态切换适配。自定义界面扫码使用系统能力customScan，其提供相机流的初始化、启动扫码、识别、停止扫码、释放相机流资源等能力。支持访问系统图库，选择照片进行识别。折叠屏折叠状态通过监听display的foldStatusChange事件实现。

### 效果图预览

<img src="./entry/src/main/resources/base/media/custom_scan.gif" width="200">

**使用说明**

1. 用户授权相机扫码。
2. 对准二维码即可识别展示，支持多二维码同时出现时的识别，但因为识别速度较快，当相机视野内出现一个二维码时，就会立马识别。
3. 支持打开和关闭相机闪光灯。
4. 折叠态不同，相机流的尺寸也不同，因此折叠态变更时，扫码服务会重新初始化。
5. 支持图库照片识别，当识别多二维码照片时，随机选择一个展示结果。
6. 展示识别结果，如果是可访问的网页，直接打开网页展示，如果不是url，显示识别结果文本。

### 实现思路

1. 相机权限需要用户授权。
```typescript
// 向用户申请授权
let context = getContext() as common.UIAbilityContext;
let atManager = abilityAccessCtrl.createAtManager();
let grantStatusArr = await atManager.requestPermissionsFromUser(context, [ 'ohos.permission.CAMERA' ]);
const grantStatus = grantStatusArr.authResults[0];
```
源码请参考[CustomScanViewModel.ets](./customscan/src/main/ets/viewmodel/CustomScanViewModel.ets)

2. 依赖XComponent展示相机流内容，在加载完相机流后启动相机扫码服务。
```typescript
// TODO：知识点：相机流显示依赖XComponent
XComponent({
  type: XComponentType.SURFACE,
  controller: this.cameraSurfaceController
})
  .onLoad(() => {
    // TODO：知识点：customScan依赖XComponent组件的surfaceId，对图像进行扫描
    this.customScanVM.surfaceId = this.cameraSurfaceController.getXComponentSurfaceId();
    // TODO：知识点：初始化XComponent组件的surface流的尺寸
    this.updateCameraSurfaceSize(this.customScanVM.cameraCompWidth, this.customScanVM.cameraCompHeight);
    // TODO：知识点：XComponent加载完成后，启动相机进行扫码
    this.customScanVM.initCustomScan();
  })
  .clip(true)
```
源码请参考[CustomScanCameraComp.ets](./customscan/src/main/ets/components/CustomScanCameraComp.ets)

3. 二维码识别通过customScan系统能力在启动扫描之后，通过异步任务监控相机图像，对识别到的内容直接返回customScanCallback处理。
```typescript
try {
  const viewControl: customScan.ViewControl = {
    width: this.cameraCompWidth,
    height: this.cameraCompHeight,
    surfaceId: this.surfaceId
  };
  // TODO：知识点 请求扫码结果，通过Promise触发回调
  customScan.start(viewControl).then((result) => {
    // 处理扫码结果
    this.customScanCallback(result);
  }).catch((error: BusinessError) => {
    logger.error('start failed error: ' + JSON.stringify(error));
  })
} catch (error) {
  logger.error('start fail, error: ' + JSON.stringify(error));
}
```
源码请参考[CustomScanViewModel.ets](./customscan/src/main/ets/viewmodel/CustomScanViewModel.ets)

4. 在customScanCallback回调中，处理相机返回的扫码结果，用于在屏幕上标记二维码位置。如果扫码结果为空，重启扫码。
```typescript
customScanCallback(result: scanBarcode.ScanResult[]): void {
  if (!this.isScanned) {
    this.scanResult.code = 0;
    this.scanResult.data = result || [];
    let resultLength: number = result ? result.length : 0;
    if (resultLength) {
      // 停止扫描
      this.stopCustomScan();
      // 标记扫描状态，触发UI刷新
      this.isScanned = true;
      this.scanResult.size = resultLength;
    } else {
    // 重新扫码
    this.reCustomScan()
    }
  }
}
```
源码请参考[CustomScanViewModel.ets](./customscan/src/main/ets/viewmodel/CustomScanViewModel.ets)

5. 如果扫描结果只有一个二维码，那么在指定位置上标记图片，并弹窗展示二维码内容
```typescript
Image($rawfile('scan_selected.svg'))
  // TODO: 知识点: 在扫描结果返回的水平坐标和纵坐标位置上展示图片
  .selected(true, this.singleCodeX, this.singleCodeY)
  .scale({ x: this.singleCodeScale, y: this.singleCodeScale })
  .opacity(this.singleCodeOpacity)
  .onAppear(() => {
    this.singleCodeBreathe();
  })
```
源码请参考[CommonCodeLayout.ets](./customscan/src/main/ets/components/CommonCodeLayout.ets)

6. 如果扫描结果只有多个二维码，那么需要在这些二维码的位置上都标记图片，等待用户点击
```typescript
Row() {
  Image($rawfile('scan_selected2.svg'))
    .width(40)
    .height(40)
    .visibility((this.isMultiSelected && this.multiSelectedIndex !== index) ? Visibility.None : Visibility.Visible)
    .scale({ x: this.multiCodeScale, y: this.multiCodeScale })
    .opacity(this.multiCodeOpacity)
    .onAppear(() => {
      // 展示动画，因为共用状态变量，只需要第一次执行
      if (index === 0) {
        this.multiAppear();
      }
    })
    .onClick(() => {
      // 点击打开二维码信息弹窗
      this.openMultiCode(arr, index);
    })
}
// TODO: 知识点: 预览流有固定比例，XComponent只能展示部分，返回的扫码结果和当前展示存在一定偏移量
.position({
  x: this.getOffset('x', arr),
  y: this.getOffset('y', arr)
})
```
源码请参考[CommonCodeLayout.ets](./customscan/src/main/ets/components/CommonCodeLayout.ets)

7. 选中二维码后，读取二维码内容，然后跳转路由展示
```typescript
async showScanResult(scanResult: scanBarcode.ScanResult): Promise<void> {
  // 码源信息
  const originalValue: string = scanResult.originalValue;
  // 二维码识别结果展示
  this.subPageStack.pushPathByName(CommonConstants.SUB_PAGE_DETECT_BARCODE, originalValue, true);
}
```
源码请参考[CommonCodeLayout.ets](./customscan/src/main/ets/components/CommonCodeLayout.ets)

8. 通过系统picker拉起系统相册选择需要进行二维码识别的照片，通过系统二维码识别库detectBarcode进行二维码识别
```typescript
async detectFromPhotoPicker(): Promise<string> {
  const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
  photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
  photoSelectOptions.maxSelectNumber = 1;
  const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
  const photoSelectResult: photoAccessHelper.PhotoSelectResult = await photoViewPicker.select(photoSelectOptions);
  const uris: string[] = photoSelectResult.photoUris;
  if (uris.length === 0) {
    return '';
  }
    
  // 识别结果
  let retVal = CommonConstants.DETECT_NO_RESULT;
  const inputImage: detectBarcode.InputImage = { uri: uris[0] };
  try {
    // 定义识码参数options
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.QR_CODE],
      enableMultiMode: true,
      enableAlbum: true,
    }
    // 调用图片识码接口
    const decodeResult: scanBarcode.ScanResult[] = await detectBarcode.decode(inputImage, options);
    if (decodeResult.length > 0) {
      retVal = decodeResult[0].originalValue;
    }
    logger.error('[customscan]', `Failed to get ScanResult by promise with options.`);
  } catch (error) {
    logger.error('[customscan]', `Failed to detectBarcode. Code: ${error.code}, message: ${error.message}`);
  }
    
  // 停止扫描
  this.stopCustomScan();
  return retVal;
}
```
源码请参考[CustomScanViewModel.ets](./customscan/src/main/ets/viewmodel/CustomScanViewModel.ets)

9. 折叠屏设备上，依赖display的屏幕状态事件，监听屏幕折叠状态变更，通过对折叠状态的分析，更新XComponent尺寸并重新启动扫码服务。
```typescript
// 监听折叠屏状态变更，更新折叠态，修改窗口显示方向
display.on('foldStatusChange', async (curFoldStatus: display.FoldStatus) => {
  // 无视FOLD_STATUS_UNKNOWN状态
  if (curFoldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN) {
    return;
  }
  // FOLD_STATUS_HALF_FOLDED状态当作FOLD_STATUS_EXPANDED一致处理
  if (curFoldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
    curFoldStatus = display.FoldStatus.FOLD_STATUS_EXPANDED;
  }
  // 同一个状态重复触发不做处理
  if (this.curFoldStatus === curFoldStatus) {
    return;
  }

  // 缓存当前折叠状态
  this.curFoldStatus = curFoldStatus;

  // 当前没有相机流资源，只更新相机流宽高设置
  if (!this.surfaceId) {
    this.updateCameraCompSize();
    return;
  }

  // 关闭闪光灯
  this.tryCloseFlashLight();
  setTimeout(() => {
    // 重新启动扫码
    this.restartCustomScan();
  }, 10)
})
```
源码请参考[CustomScanViewModel.ets](./customscan/src/main/ets/viewmodel/CustomScanViewModel.ets)

### 高性能知识点

不涉及

### 工程结构&模块类型

   ```
   customscan                           // har类型
   |---common
   |   |---constants
   |   |    |---BreakpointConstants.ets // 设备大小枚举常量
   |   |    |---CommonConstants.ets     // 通用常量
   |   |---utils
   |   |    |---FunctionUtil.ets        // 功能函数工具
   |   |    |---GlobalUtil              // global工具
   |---components
   |   |---CommonCodeLayout.ets         // 自定义组件-二维码位置标记
   |   |---CommonTipsDialog.ets         // 自定义组件-未开通相机权限引导弹框
   |   |---MaskLayer.ets                // 自定义组件-二维码位置标记蒙层
   |   |---ScanLine.ets                 // 自定义组件-二维码扫码的扫描线
   |   |---ScanTitle.ets                // 自定义组件-二维码扫码的标题
   |   |---CustomScanCameraComp.ets     // 自定义组件-二维码扫描相机流组件
   |   |---CustomScanCtrlComp.ets       // 自定义组件-二维码扫描控制菜单组件
   |---model
   |   |---PermissionModel.ets          // 模型层-权限控制管理器
   |   |---WindowModel.ets              // 模型层-窗口管理器 
   |---pages
   |   |---CustomScanPage.ets           // 展示层-二维码扫描页面 
   |   |---DetectBarcodePage.ets        // 展示层-二维码扫描结果页面 
   |---viewmodel
   |   |---CustomScanViewModel.ets      // 控制层-二维码扫描控制器
   ```

### 参考资料

- [属性动画](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-animatorproperty.md)
- [程序访问控制管理](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-ability-kit/js-apis-abilityAccessCtrl.md)

### 相关权限

[ohos.permission.CAMERA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md)
[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md)

### 依赖

不涉及

### 约束和限制

1. 本示例仅支持标准系统上运行。
2. 本示例已适配API version 12版本SDK。
3. 本示例需要使用DevEco Studio 5.0.0 Release及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```shell
git init
git config core.sparsecheckout true
echo /code/BasicFeature/Media/CustomScan/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```