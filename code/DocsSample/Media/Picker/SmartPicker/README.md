# 基于PhotoPicker实现图片推荐功能

### 介绍

本示例旨在解决特殊场景需要相册picker提供图片推荐功能的问题，主要使用接口与组件两种方式，拉起系统photoPicker，并分别实现了基于recommendationType配置完成特定服务类型的图片推荐，以及基于textContextInfo配置完成文案的图片推荐 ，帮助开发者通过PhotoPicker实现图片推荐功能。

### 效果预览
![](screenshots/Devices/smartPhotoPicker.png)

#### 使用说明：

1. 点击首页的两个按钮，分别进入通过组件实现与通过接口实现的页面。
2. 点击不使用图片推荐能力，仅拉起一个普通的picker界面。
3. 下拉框选择身份证或二维码，点击基于特定服务推荐图片按钮，若相册中存在该类型的图片，会拉起对应类型图片的picker界面。
4. 输入文案（例如：人像、银行卡等），会识别并拉起特殊文案推荐picker进行推荐。
5. 当前TextContextInfo仅支持250字以内的简体中文，输入英文字符无法进行图片推荐。

### 工程目录
```
├──entry/src/main/ets                                  // 代码区
│  ├──commons                                  
│  │  └──utils          
│  │     └──SmartPhotoPickerUtils.ets                   // picker接口工具类
│  ├──entryability  
│  │  └──EntryAbility.ets 
│  ├──entrybackupability  
│  │  └──EntryBackupAbility.ets
│  ├──pages                                
│  │  └──Index.ets                                      // 首页
│  └──view  
│     ├──ComponentImplPage.ets                          // 组件实现页
│     └──InterfaceImplPage.ets                          // 接口实现页    
└──entry/src/main/resources                             // 应用资源目录

```

### 具体实现
* 基于接口实现特定服务类型的图片推荐，需要将recommendationType配置到recommendationOptions，随后配置到PhotoSelectOptions中。
```typescript
// SmartPhotoPickerUtils.ets
let recommendationOptions: photoAccessHelper.RecommendationOptions = {
  recommendationType: recommendType
};
let option: photoAccessHelper.PhotoSelectOptions = {
  recommendationOptions: recommendationOptions,
  isPhotoTakingSupported: true,
  maxSelectNumber: 1,
  MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
};
photoPicker.select(option).then(() => {
  hilog.info(0x0000, TAG, 'Create photoPicker success');
});
```
* 基于接口实现文案的图片推荐，需要将textContextInfo配置到recommendationOptions，随后配置到PhotoSelectOptions中。
```typescript
// SmartPhotoPickerUtils.ets
let textInfo: photoAccessHelper.TextContextInfo = {
  text: content
};
let recommendationOptions: photoAccessHelper.RecommendationOptions = {
  textContextInfo: textInfo
};
let option: photoAccessHelper.PhotoSelectOptions = {
  recommendationOptions: recommendationOptions,
  isPhotoTakingSupported: true,
  maxSelectNumber: 1,
  MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
};
photoPicker.select(option).then(() => {
  hilog.info(0x0000, TAG, 'Create photoPicker success');
});
```
* 基于组件实现特定服务类型推荐，仅需要将recommendationType配置到recommendationOptions，随后将其配置到PhotoPickerComponent组件的pickerOptions参数中。
```typescript
// ComponentImplPage.ets
this.pickerOptions.recommendationOptions = {
  recommendationType: this.recommendationType
};

PhotoPickerComponent({
  pickerOptions: this.pickerOptions,
  pickerController: this.pickerController
})
```
* 基于组件实现文案的推荐，仅需要将textContextInfo配置到recommendationOptions，随后将其配置到PhotoPickerComponent组件的pickerOptions参数中。
```typescript
// ComponentImplPage.ets
let textInfo: photoAccessHelper.TextContextInfo = {
  text: this.content
};
this.pickerOptions.recommendationOptions = {
  textContextInfo: textInfo
};

PhotoPickerComponent({
  pickerOptions: this.pickerOptions,
  pickerController: this.pickerController
})
```


### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。

2. 本示例为Stage模型，支持API18版本SDK，镜像版本号：5.1.0.107。

3. DevEco Studio版本：DevEco Studio 5.0.5 Release及以上。

4. PhotoPicker推荐图片的功能依赖于图片分析的结果，只有在媒体库中的图片分析完成后，系统才会进行推荐。
当设备在灭屏充电时，在电量充足、温度正常的情况下，系统将自动进行图片分析。

5. 如果图片带有地理位置信息，设备需要联网才可以正常解析图片中的位置信息。

6. 当前仅支持推荐图片类型的文件。
