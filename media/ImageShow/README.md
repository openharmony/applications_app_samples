# Image Show

### Introduction

In this sample, you can add images from **Gallery** to the offering review page.

This sample uses the [**\<TextArea>**](https://gitee.com/openharmony/docs/blob/master/en/application-dev/reference/arkui-ts/ts-basic-components-textarea.md) component to implement multi-line text input and the [mediaLibrary](https://gitee.com/openharmony/docs/blob/master/en/application-dev/reference/apis/js-apis-mediaquery.md) class to obtain and select images.

### Usage

1. Touch **Add image**. The page for selecting images is displayed.

2. Select the images to be added. The number of selected images is displayed in the upper right corner, and the thumbnails of selected images are displayed in the lower part. You can select six images at most.

3. Touch **Next**. The home page is displayed, and the images selected are displayed on the home page. You can touch **Add image** again to select other images.

4. Touch the text box to input your comment.

5. Touch the back button to exit the app.

### Display Effect

![](screenshots/devices/en/index.png) ![](screenshots/devices/en/not_choice.png) ![](screenshots/devices/en/choice.png) ![](screenshots/devices/en/show.png)

### Required Permissions

[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/en/application-dev/security/permission-list.md), which allows an app to read media files from the user's external storage.

### Dependency

N/A

### Constraints

1. This sample can only be run on standard-system devices that use the Rockchip RK3568 development board.

2. This sample is based on the stage model, which is supported from API version 9 (SDK version: 3.2.5.5). 

3. DevEco Studio 3.0 Beta4 (Build version: 3.0.0.991, built on July 6, 2022) must be used.
