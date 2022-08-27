# Gallery Widget

### Introduction

This sample demonstrates the display of **Gallery** images in a widget and periodic update of the widget. The display effect is as follows:

![](screenshots/device/gallery.png) ![](screenshots/device/gallery_form.png)

### Concepts

Media library management: You can use **getAllObject** of the media library instance to query the paths of all images in **Gallery**, and use **open** to obtain the file descriptor (FD) of an image in the specified path. This FD will be used as a key parameter for creating a widget.

Widget update: You can use **formProvider.setFormNextRefreshTime** to set the next refresh time (5 minutes at minimum) for a widget. After the specified time elapsed, the **onUpdate** callback is invoked to update the widget.

### Required Permissions

**ohos.permission.MEDIA_LOCATION**, which allows an app to access geographical locations in the user's media file.

**ohos.permission.READ_MEDIA**, which allows an app to read media files from the user's external storage.

**ohos.permission.WRITE_MEDIA**, which allows an app to read media files from and write media files into the user's external storage.

### Usage

1. When you start the app for the first time, you must grant the app the permission to access the geographical location information in your media file.

2. Touch and hold the app icon to create a widget and add the widget to the home screen. The widget displays images in **Gallery** properly.

3. Touch the image displayed on the widget to start the app.

### Constraints

1. This sample can only be run on standard-system devices.

2. This sample is based on the stage model, which is supported from API version 9.

3. DevEco Studio 3.0 Beta3 (Build version: 3.0.0.992, built on July 6, 2022) must be used.

4. Before creating a widget, ensure that there are images in **Gallery**. Otherwise, the widget will not be updated.

5. The update takes place 5 minutes after the widget is created when the device screen is on.
