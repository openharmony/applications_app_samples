# 相机场景案例

### 介绍

本示例介绍相机场景案例的使用：通过[startAbilityForResult](https://docs.openharmony.cn/pages/v5.1/zh-cn/application-dev/reference/apis-ability-kit/js-apis-inner-application-uiAbilityContext.md#startabilityforresult)接口拉起相机，拍照后获取照片地址，使用[Image](https://docs.openharmony.cn/pages/v5.1/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-image.md)组件展示照片。

### 效果图预览

<img src="entry/src/main/resources/base/media/cameraAbility.png" width="300">

**使用说明**
1. 点击输入框输入评论。
2. 点击相机图标进入拍照。
3. 点击发布按钮发布评论。

### 实现思路

1.点击输入框，输入评论内容。
```typescript
TextInput()
  ...
  .onChange(
    (textInComment: string) => {
      this.commentContent = textInComment;
    } as EditableTextOnChangeCallback)
```
2.点击相机图标拉起相机拍照。
```typescript
cameraCapture(context: common.UIAbilityContext) {
  try {
    let want: Want = {
      action: Constants.ACTION_PICKER_CAMERA,
      parameters: {
        'supportMultiMode': false,
        'callBundleName': context.abilityInfo.bundleName
      } as Record<String,Object>
    };
    context.startAbilityForResult(want,
      (err: BusinessError, result: common.AbilityResult) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', `startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        if(result.resultCode === 0) {
          const param: Record<string, Object> | undefined = result.want?.parameters;
          if (param !== undefined) {
            const resourceUri: string = param[Constants.KEY_RESULT_PICKER_CAMERA] as string;
            this.imagePath = resourceUri;
          }
        }
      });

  } catch (err) {
    let code = (err as BusinessError).code;
    let message = (err as BusinessError).message;
    hilog.error(0x0000, 'testTag', `startAbilityForResult failed, code is ${code}, message is ${message}`);
  }
}
...
Image($r("app.media.icon_comment_camera"))
  ...
  .onClick((e: ClickEvent) => {
    try {
      this.cameraCapture(this.getUIContext().getHostContext() as common.UIAbilityContext);
    } catch (error: BusinessError) {
      hilog.info(0x0000, 'testTag', 'camera capture error：-----------' + error.code);
    }
  })
```
3.使用ForEach展示评论，使用自定义组件ImageListView展示照片。
```typescript
ForEach(this.commentList, (item: Comment) => {
  Column() {
    Row() {
      Image(item.avatar)
      ...
      Column() {
        Text(item.name)
        Text(item.time)
      }
      ...
    }
    Text(item.comment)
    ...
    if (item.images.length > 0) {
      ImageListView({ selectedImages: item.images })
    }
  }
  ...
}
```
### 高性能知识点

不涉及

### 工程结构&模块类型

   ```
  cameraMainAbility
  |---constants
  |   |---Constants.ets                       // 常量类
  |---model
  |   |---CommentModel.ets                    // 评论数据类
  |---components
  |   |---CommentItemView.ets                 // 单个评论组件
  |   |---ImageListView.ets                   // 评论图片List组件
  |   |---CommentInputAndCameraCapture.ets    // 输入框和相机拍照组件
   ```
### 参考资料

[startAbilityForResult参考文档](https://docs.openharmony.cn/pages/v5.1/zh-cn/application-dev/reference/apis-ability-kit/js-apis-inner-application-uiAbilityContext.md#startabilityforresult)
[Image参考文档](https://docs.openharmony.cn/pages/v5.1/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-image.md)