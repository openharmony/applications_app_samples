# Gallery Project

### Introduce

The application uses interfaces such
as[@ohos.file.photoAccessHelper](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)
to implement functions like viewing pictures in the system album, classifying albums, and deleting them.

Instructions for Use:

1. On the home page, there are two menus, namely "Photos" and "Albums". The focus is initially on the "Albums" menu, and
   you can switch between them by moving left or right. 1. The "Photos" option displays all photos and videos. 2. The "
   Albums" option contains photos, screen recordings, screenshots, videos, and recently deleted items.
2. When the focus is on a photo, clicking the "OK" button allows you to view the photo or video. Clicking on a video
   will play it, and clicking again will close it.
3. When the focus is on the "Albums" menu, clicking the "OK" button on a photo enables you to view the photo or video.
   Clicking on a video will play it, and clicking again will close it.
4. On the home page, click the menu button, and a menu (Share, Delete, Select) will pop up below. Click "Select" to
   enter the editing page, where you can select photos. Click the "Share" menu to share pictures and videos to other
   devices. Click "Delete" to delete the selected photos.

### Project Directory

```
entry/src/main/ets/
|---base
|	|---PhotoFileUri.ets                // System docking encapsulation module
|---common  
|	|---Constants.ets                   // Enumeration string encapsulation
|	|---GlobalContext.ets               // GlobalContext encapsulation
|	|---Logger.ets                      // Logging tool encapsulation
|	|---Common.ets                      // Permission character conversion encapsulation
|	|---TraceControllerUtils.ets        // Time slice tracking module encapsulation
|	|---Utils.ets                       // Tip pop-up window, logging encapsulation
|	|---WifiManager.ets                 // Wi-Fi management module encapsulation
|---entryability
|	|---MainAbility.ets                 // ability class
|---model
|	|---AlbumModel.ets                  // Album model encapsulation
|	|---FileSendModel.ets               // File sharing model encapsulation
|	|---IDataSource.ets                 // LazyForeach model encapsulation
|	|---PhotoModel.ets                  // Photo model encapsulation
|---pages
|	|---Index.ets                       // Home page (photos and albums)
|	|---PhotoList.ets                   // Photo deletion list
|	|---PhotoList.ets                   // Photo list
|	|---PhotoWatch.ets                  // Interface for viewing pictures and videos
```

### Specific Implementation

- The function of obtaining photo lists and album categories is encapsulated in Index.ets, source code
  reference:[Index.ets](entry/src/main/ets/pages/Index.ets)
    * The default focus is on the photo, and you can take photos left and right. To switch between albums, use
      phAccessHelper.getAlbums to obtain an instance of the album, which is used to access video and image categories;
    * Use phAccessHelper.getFileAssets to retrieve file resources; Use to fetch FileResult.getAllObject to retrieve all
      file retrieval results. Interface reference:[@ohos.file.photoAccessHelper](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)
    * Click the menu button to bring up the menu function, select photos, and use MediaAssetChangeRequest.deleteAssets
      to delete file instances.
- The function of the photo list is encapsulated in PhotoList.ets, source code
  reference:[PhotoList.ets](entry/src/main/ets/pages/PhotoList.ets)
    * Use phAccessHelper. getAlbums (photoAccessHelper. AlbumType.SYSTEM, albumSubtype, albumFetchOptions)
      Method to obtain photo classification. You can switch the focus, click the menu button, select the photo, and
      delete it.
- The functionality of the photo list is encapsulated in PhotoDeleteList.ets, source code
  reference:[PhotoDeleteList.ets](entry/src/main/ets/pages/PhotoDeleteList.ets)
    * Use phAccessHelper. getAlbums (photoAccessHelper. AlbumType.SYSTEM, albumSubtype, albumFetchOptions)
      Method to obtain photo classification.
- The function of viewing images or videos and viewing them is encapsulated in ViewMedia.ets, source code
  reference:[PhotoWatch.ets](entry/src/main/ets/pages/PhotoWatch.ets)
    * Click the OK button to enter the photo viewing page, use the left and right buttons to view the previous and next
      photos, click the OK button on the video page to play the video, and click again to stop playing.

### Related permissions

| Permission Name                  | Permission Description                                              | Level       |
|----------------------------------|---------------------------------------------------------------------|-------------|
| ohos.permission.MEDIA_LOCATION   | Accessing the geographical location of user media files             | normal      |
| ohos.permission.READ_MEDIA       | The application reads media files from the user's external storage  | normal      |
| ohos.permission.WRITE_IMAGEVIDEO | Modify images or videos in the user's public directory              | system_core |
| ohos.permission.READ_IMAGEVIDEO  | Read images or video files from the user's public directory         | system_core |

### Be dependent on

not involved

### Constraints and limitations

1.This example only runs on the standard system and supports the device: RK3568,V900。

2.This example is a Stage model, supports the API10 version SDK, with the SDK version number (API Version 12 Release)
and the mirror version number (5.0 Release).

3.This example requires DevEco Studio with a version number (5.0 Release) or above to compile and run.

4.This example involves some interfaces that require configuring the system application signature. You can refer to
the [Special Permission Configuration Method](https://gitcode.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md)
and change the "apl" field information in the configuration file to "system_core".

### Download

If you need to download this project separately, execute the following commands:

```
git init
git config core.sparsecheckout true
echo code/SystemFeature/FileManagement/FileShare/Picker > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```

### Additional Document

- ohosTest.md
