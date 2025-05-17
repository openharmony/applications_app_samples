# Web获取相机拍照图片案例

### 介绍

本示例介绍如何在HTML页面中拉起原生相机进行拍照，并获取返回的图片。

### 效果预览图

![](./entry/src/main/resources/base/media/web_get_camera_image.gif)

**使用说明**
1. 点击HTML页面中的选择文件按钮，拉起原生相机进行拍照。
2. 完成拍照后，将图片在HTML的img标签中显示。

### 实现思路
1. 添加Web组件，设置[onShowFileSelector](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkweb/ts-basic-components-web.md#onshowfileselector9)和[javaScriptProxy](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkweb/ts-basic-components-web.md#javascriptproxy)属性，接收HTML页面中input的点击事件。在onShowFileSelector中调用invokeCamera接口，拉起原生相机进行拍照，并通过callback回调方法获得照片的uri。然后将uri放在[FileSelectorResult](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkweb/ts-basic-components-web.md#fileselectorresult9)中，通过event参数返回给HTML页面。源码参考[MainPage.ets](./webgetcameraimage/src/main/ets/components/mainpage/MainPage.ets)。

    ```typescript
    Web({ src: $rawfile(LOCAL_HTML_PATH), controller: this.controller })
      .onShowFileSelector((event: FileResult) => { 
        this.invokeCamera(((uri: string) => {
          event?.result.handleFileList([uri]);
        }))
        return true;
      })
      .javaScriptProxy({
        object: this.shareObject,
        name: 'shareObject',
        methodList: ['share'],
        controller: this.controller
      })
    ```

2. 实现invokeCamera接口，拉起原生相机，通过callback回调方法返回拍照结果，并保存到应用沙箱中。源码参考[MainPage.ets](./webgetcameraimage/src/main/ets/components/mainpage/MainPage.ets)。

    ```typescript
    invokeCamera(callback: (uri: string) => void) {
      const context = getContext(this) as common.UIAbilityContext;
      let want: Want = {
        action: ACTION_IMAGE_CAPTURE,
        parameters: {
          "callBundleName": context.abilityInfo.bundleName,
        }
      };
      let result: (error: BusinessError, data: common.AbilityResult) => void = (error: BusinessError, data: common.AbilityResult) => {
        if (error && error.code !== 0) {
          logger.error(`${TAG_CAMERA_ERROR} ${JSON.stringify(error.message)}`);
          return;
        }
        let resultUri: string = data.want?.parameters?.resourceUri as string;
        if (callback && resultUri) {
          callback(resultUri);
          this.copyFileToSandBox(pickerResult.resultUri);
        }
      }
      context.startAbilityForResult(want, result);
    }
    ```

3. 实现拉起分享面板接口，源码参考[MainPage.ets](./webgetcameraimage/src/main/ets/components/mainpage/MainPage.ets)。

   ```typescript
   shareObject: ShareClass = {
     share: async () => {
       if (!this.filePath) {
         this.getUIContext().getPromptAction().showToast({
           message: '未选择任何文件'
         });
         return;
       }
       let utdTypeId = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension('.jpg',
         uniformTypeDescriptor.UniformDataType.IMAGE);
       let uri: string = fileUri.getUriFromPath(this.filePath);
       let shareData: systemShare.SharedData = new systemShare.SharedData({
         utd: utdTypeId,
         uri: uri,
         title: 'Picture Title',
         description: 'Picture Description'
       });
       let controller: systemShare.ShareController = new systemShare.ShareController(shareData);
       let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
       controller.show(context, {
         selectionMode: systemShare.SelectionMode.SINGLE,
         previewMode: systemShare.SharePreviewMode.DEFAULT
       }).then(() => {
         console.info('ShareController show success');
       }).catch((error: BusinessError) => {
         console.error(`ShareController show error, code: ${error.code}, message: ${error.message}`);
       })
     }
   };
   ```

4. 在HTML页面中添加input标签，并在onChange属性中添加js方法，通过dom tree返回的描述事件相关信息的event对象接收ArkTS返回的照片，并显示在img标签上。添加sharePic()方法并在button标签上调用，使html可以拉起分享面板。源码参考[camera.html](./webgetcameraimage/src/main/resources/rawfile/camera.html)。

    ```html
    <script>
      function showPic() {
        let event = this.event;
        let tFile = event ? event.target.files : [];
        if (tFile === 0) {
          document.getElementById('image_preview').style.display = 'block';
          document.getElementById('image_preview').innerHTML = "未选择图片";
          return
        }
        document.getElementById('image').setAttribute('src', URL.createObjectURL(tFile[0]));
        document.getElementById('image_preview').style.display = 'block';
        document.getElementById('image').style.display = 'block';
      }
      function sharePic() {
        shareObject.share();
      }
    </script>
    <input ref="camera" type="file" id="upload" name="upload" accept="image/*" capture="upload" onchange="showPic()" />
    <button onclick="sharePic()">分享图片</button>
    <p id="image_preview">图片预览</p>
    <img id="image">
    ```

### 工程结构&模块类型

   ```
   webgetcameraimage                                          // har类型
   |---mainpage
   |   |---MainPage.ets                                       // ArkTS页面
   |---rawfile
   |   |---camera.html                                        // HTML页面
   ```

### 模块依赖

不涉及

### 参考资料

[Web组件](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkweb/ts-basic-components-web.md)

### 相关权限

不涉及

### 约束与限制

1.本示例仅支持在标准系统上运行，支持设备：Phone。

2.本示例为Stage模型，支持API13版本SDK，SDK版本号（API Version 13 Release）。

3.本示例需要使用DevEco Studio 5.0.4 Release 才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Web/WebGetCameraImage/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
