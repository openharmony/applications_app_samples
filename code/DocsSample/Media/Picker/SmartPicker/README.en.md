# Implementing Image Recommendation with PhotoPicker

### Overview

This sample introduces how to implement image recommendation by interface or component with PhotoPicker. It provides the **recommendationType** configuration to support image recommendation for a specific service type and the **textContextInfo** configuration to support image recommendation based on given text.

### Preview
![](screenshots/Devices/smartPhotoPicker_en.png)

#### How to Use

1. By tapping a button on the home page, you can access the page for implementing image recommendation by component or interface.
2. By tapping the button for disabling image recommendation, you can only open a common picker page.
3. Select an ID card or QR code from the drop-down list box and tap the button for recommending images based on a specific service. If images of this type exist in the album, the corresponding picker page is displayed.
4. If you enter content (for example, description of a profile image or bank card), the system will identify the content and start recommendation with a special picker.
5. TextContextInfo only supports simplified Chinese within 250 characters, and is unable to recommend images based on input English characters.

### Project Directory
```
├──entry/src/main/ets                                  // Code area
│  ├──commons
│  │  └──utils
│  │     └──SmartPhotoPickerUtils.ets                   // Picker interface utilities
│  ├──entryability
│  │  └──EntryAbility.ets
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets
│  ├──pages
│  │  └──Index.ets                                      // Home page
│  └──view
│     ├──ComponentImplPage.ets                          // Component implementation page
│     └──InterfaceImplPage.ets                          // Interface implementation page
└──entry/src/main/resources                             // App resource directory

```

### How to Implement
* To implement service-based image recommendation by interface, you need to configure **recommendationType** in **recommendationOptions** and then configure **recommendationOptions** in **PhotoSelectOptions**.
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
* To implement text-based image recommendation by interface, you need to configure **textContextInfo** in **recommendationOptions** and then configure **recommendationOptions** in **PhotoSelectOptions**.
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
* To implement service-based image recommendation by component, you need to configure **recommendationType** in **recommendationOptions** and then configure **recommendationOptions** in the **pickerOptions** parameter of **PhotoPickerComponent**.
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
* To implement text-based image recommendation by component, you need to configure **textContextInfo** in **recommendationOptions** and then configure **recommendationOptions** in the **pickerOptions** parameter of **PhotoPickerComponent**.
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


### Permissions

N/A

### Dependencies

N/A

### Constraints

1. The sample can only run on Huawei phones with standard systems.

2. This example uses the Stage model, supports SDK for API version 18, and has an image version number of 5.1.0.107.

3. The DevEco Studio version: DevEco Studio 5.0.5 Release or later required.

4. The PhotoPicker's image recommendation feature relies on the results of image analysis. The system will only make recommendations after image analysis in the media library is completed.

5. When the device is charging with the screen off, and provided that the battery level is sufficient and the temperature is normal, the system will automatically perform image analysis.

6. If images contain geographic location information, the device must be connected to the internet to properly parse the location data embedded in the images.
Currently, only image-type files are supported for recommendations.