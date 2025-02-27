# 多图片预览效果实现

### 介绍

图片预览在应用开发中是一种常见场景，这里实现了对于图片的 缩放、移动、旋转、多图片预览功能做了处理。

### 效果图预览

| 图片预览                                                             |
|------------------------------------------------------------------|
| <img src="screenshots/picturepreview_example.gif" width="300" /> |


**使用说明：**

1. 双指捏合对图片进行缩放
2. 双击图片进行图片的大小切换，在放大状态下，双击可恢复默认状态
3. 图片在放大模式下，滑动图片查看图片的对应位置
4. 点击切换图片底图颜色
5. 双指旋转对图片进行旋转

### 工程目录

```
|entry/src/main/ets                  
|   |---entryablity
|   |   |---EntryAbility.ts                         // 程序入口类             
|   |---constants                                   // 常量
|   |---model                                       // 自定义数据模型
|   |---utils                                       // 工具类
|   |---picturepreviewsample                        // 示例使用
|   |   |---PicturePreviewSample.ets                // 场景构建案例
|   |---view                                        // 图片预览方案涉及的主要组件
|   |   |---PicturePreview.ets                      // 图片预览组件
|   |   |---PicturePreviewImage.ets                 // 单张图片的显示组件
```

### 实现思路

1. 使用matrix实现图片的缩放。详情见[PicturePreviewImage.ets](entry/src/main/ets/view/PicturePreviewImage.ets)。
    ```typescript
    @State matrix: matrix4.Matrix4Transit = matrix4.identity().copy();
    Image(this.imageUrl)
      .transform(this.matrix)
    ```
2. 使用offset属性对图片进行偏移。详情见[PicturePreviewImage.ets](entry/src/main/ets/view/PicturePreviewImage.ets)。
    ```typescript
    @State imageOffsetInfo: OffsetModel = new OffsetModel(0, 0);
    Image(this.imageUrl)
      .offset({
          x: this.imageOffsetInfo.currentX,
          y: this.imageOffsetInfo.currentY
      })
    ```
3. Image的objectFit属性设置为Cover，锁定图片宽高比，并使其能够超出父组件边界显示。详情见[PicturePreviewImage.ets](entry/src/main/ets/view/PicturePreviewImage.ets)。
   ```typescript
   Image(this.imageUrl)
     .objectFit(ImageFit.Cover)
   ```
4. 提前计算图片信息，并通过Image的宽或高配合aspectRatio设置默认尺寸。详情见[PicturePreviewImage.ets](entry/src/main/ets/view/PicturePreviewImage.ets)。
   ```typescript
   Image(this.imageUrl)
    .width(this.fitWH === "width" ? $r("app.string.image_default_width") : undefined)
    .height(this.fitWH === "height" ? $r("app.string.image_default_height") : undefined)
    .aspectRatio(this.imageWHRatio)
    .onComplete((event) => {
        if (event) {
          let imageW = event.width;
          let imageH = event.height;
          let windowSize = windowSizeManager.get();
          // 图片宽高比
          this.imageWHRatio = imageW / imageH;
          // 图片默认大小
          this.imageDefaultSize = this.calcImageDefaultSize(this.imageWHRatio, windowSize);
          // 图片宽度 等于 视口宽度 则图片使用宽度适配 否则 使用 高度适配
          if (this.imageDefaultSize.width === windowSize.width) {
            this.imageWH = ImageWH.width;
          } else {
            this.imageWH = ImageWH.height;
          }
          /**
           * 1.5 的基本倍数上添加 撑满全屏需要多少倍数
           * 1.5 是初始化时候给的值
           *      在1.5上面加是为了让图片可以放的更大
           */
          this.imageScaleInfo.maxScaleValue += this.imageWH === ImageWH.width ?
            (windowSize.height / this.imageDefaultSize.height) :
            (windowSize.width / this.imageDefaultSize.width);
        }
    })
   ```
5. 通过滑动手势来处理图片位置和边界判定。详情见[PicturePreviewImage.ets](entry/src/main/ets/view/PicturePreviewImage.ets)。
   ```typescript
   Image(this.imageUrl)
    .gesture(
      GestureGroup(
        GestureMode.Exclusive,
        // TODO：知识点：滑动图片
        PanGesture({ fingers: 1 })
          .onActionUpdate((event: GestureEvent) => {
            if (this.imageWH != ImageWH.default) {
              this.setCrossAxis(event);
              this.setPrincipalAxis(event);
            }
          })
          .onActionEnd((event: GestureEvent) => {
            this.imageOffsetInfo.stash();
            this.evaluateBound();
          })

      )
    )
   ```
6. 通过旋转手势来处理图片旋转方向。详情见[PicturePreviewImage.ets](entry/src/main/ets/view/PicturePreviewImage.ets)。
   ```typescript
   Image(this.imageUrl)
    .gesture(
      GestureGroup(
        GestureMode.Exclusive,
        // TODO：知识点：双指旋转图片
        RotationGesture({ angle: this.imageRotateInfo.startAngle })
          .onActionUpdate((event: GestureEvent) => {
            let angle = this.imageRotateInfo.lastRotate + event.angle;
            if (event.angle > 0) {
              angle -= this.imageRotateInfo.startAngle;
            } else {
              angle += this.imageRotateInfo.startAngle;
            }
            this.matrix = matrix4.identity()
              .scale({
                x: this.imageScaleInfo.scaleValue,
                y: this.imageScaleInfo.scaleValue
              })
              .rotate({
                x: 0,
                y: 0,
                z: 1,
                angle: angle,
              }).copy();
            this.imageRotateInfo.currentRotate = angle;
          })
          .onActionEnd((event: GestureEvent) => {
            let rotate = simplestRotationQuarter(this.imageRotateInfo.currentRotate);
            runWithAnimation(() => {
              this.imageRotateInfo.currentRotate = rotate;
              this.matrix = matrix4.identity()
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  angle: this.imageRotateInfo.currentRotate,
                }).copy();
              this.imageRotateInfo.stash();
              this.imageScaleInfo.reset();
              this.imageOffsetInfo.reset();
            })
          })

      )
    )
   ```

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行。

2. 本示例为Stage模型，从API version 12开始支持。SDK版本号：5.0.0.71 Release，镜像版本号：OpenHarmony 5.0.1.107。

3. 本示例需要使用DevEco Studio 5.0.2 Release (Build Version: 5.0.7.200, built on January 23, 2025)编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```shell
git init
git config core.sparsecheckout true
echo code/UI/ImageViewer/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

### 参考资料

1. [image](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-image.md)

2. [gesture](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-gesture-settings.md)

3. [list](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-container-list.md)

4. [window](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/js-apis-window.md)

5. [matrix4](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/js-apis-matrix4.md)