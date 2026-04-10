# Photo Gallery Project

### Introduction

This application uses APIs such as [@ohos.file.photoAccessHelper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)
to provide image viewing, album categorization, and deletion capabilities for the system gallery.

Instructions:

1. The home page provides two menus, **Photos** and **Albums**. The default focus is on **Albums**, and users can switch between them. The **Photos** page displays all photos and videos, while the **Albums** page includes categories such as photos, screen recordings/screenshots, videos, and recently deleted items.
2. When the focus is in the photo area, press the OK button to enter preview mode. If a video resource is selected, the app enters the playback page.
3. When the focus is on the album menu, press the OK button to enter the selected album and browse its photos and videos. If a video resource is selected, the app enters the playback page.
4. The home page button opens the bottom action menu.

### Project Structure

```text
entry/src/main/ets/
|---MainAbility
|   |---EntryAbility.ets             // Entry ability
|   |---MainAbility.ets              // Main ability
|   |---PickerAbility.ets            // Picker ability
|---common
|   |---Constants.ets                // Constant definitions
|   |---GlobalContext.ets            // Global context
|   |---Logger.ets                   // Logging wrapper
|   |---PhotoPositionUtils.ets       // Media location utilities
|   |---TraceControllerUtils.ets     // Time cost tracing utilities
|   |---Util.ets                     // Common utilities
|   |---WifiManager.ets              // Wi-Fi management
|---component
|   |---DistributedPhotoView.ets     // Distributed image component
|---manager
|   |---loader/                      // Media loaders
|   |---utils/                       // File and image utilities
|   |---DfsManager.ets               // Distributed sharing management
|   |---PhotoManager.ets             // Media data management
|   |---RdbManager.ets               // Database management
|   |---VideoThumbLoader.ets         // Video thumbnail processing
|---models
|   |---FileSendModel.ets            // Sharing data model
|   |---IDataSource.ets              // List data source model
|   |---PhotoModel.ets               // Media data model
|---pages
|   |---DistributedDevicePage.ets    // Distributed device page
|   |---Index.ets                    // Home page
|   |---NasClientPage.ets            // NAS client page
|   |---NasSessionPage.ets           // NAS session page
|   |---PhotoDeleteList.ets          // Recently deleted page
|   |---PhotoList.ets                // Album list page
|   |---PhotoWatch.ets               // Photo and video preview page
|   |---ThirdSelectPhotoGridPage.ets // Third-party picker page
|---smaba
|   |---client/                      // SMB/NAS client implementation
|   |---NasFinder.ets                // NAS discovery
|   |---NasSessionManager.ets        // NAS session management
|---workers
|   |---NasSessionWorker.ets         // NAS background task
```

### Implementation Details

- The capabilities for loading the photo list and album categories are encapsulated in [Index.ets](entry/src/main/ets/pages/Index.ets)
  - The home page supports focus switching between the **Photos** and **Albums** menus, and uses `phAccessHelper.getAlbums` to obtain album category data.
  - It uses `phAccessHelper.getFileAssets` to obtain media assets, and then reads query results through `fetchFileResult.getAllObject`. For API details, see [@ohos.file.photoAccessHelper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md).
  - The bottom menu supports select, share, and delete operations. The delete capability is implemented through `MediaAssetChangeRequest.deleteAssets`.
- The capabilities for the album list page are encapsulated in [PhotoList.ets](entry/src/main/ets/pages/PhotoList.ets)
  - It calls `phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, albumSubtype, albumFetchOptions)` to obtain system album category data, and supports focus switching and menu operations.
- The capabilities for the deleted photo list page are encapsulated in [PhotoDeleteList.ets](entry/src/main/ets/pages/PhotoDeleteList.ets)
  - It calls `phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, albumSubtype, albumFetchOptions)` to obtain data for the corresponding category.
- The capabilities for photo and video preview are encapsulated in [PhotoWatch.ets](entry/src/main/ets/pages/PhotoWatch.ets)
  - After a photo is selected, the preview page opens. Users can press the left and right directional keys to switch to the previous or next item. If a video is selected, the playback page opens.

### Permissions

| Permission Name                   | Description                                                       | Level        |
|-----------------------------------|-------------------------------------------------------------------|--------------|
| ohos.permission.MEDIA_LOCATION    | Allows the app to access geographic location information in user media files | normal       |
| ohos.permission.READ_MEDIA        | Allows the app to read media file information from the user's external storage | normal       |
| ohos.permission.WRITE_IMAGEVIDEO  | Allows the app to modify image or video files in public directories | system_basic |
| ohos.permission.READ_IMAGEVIDEO   | Allows the app to read image or video files in public directories | system_basic |

### Dependencies

None

### Constraints

1. This sample runs only on standard systems and supports the following devices: RK3568 and V900.
2. This sample uses the Stage model and supports API 10 SDK, SDK version (API Version 12 Release), and image version (5.0 Release).
3. This sample must be compiled and run with DevEco Studio 5.0 Release or later.
4. Some APIs used in this sample require a system application signature. For details, see [How to Configure Special Permissions](https://gitee.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md), and change the `apl` field in the configuration file to `system_core`.

### Download

To download this project separately, run the following commands:

```
git init
git config core.sparsecheckout true
echo code/SystemFeature/FileManagement/FileShare/Picker > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
