# File Manager

### Introduction

The File Manager application uses fileAccess and fileIo to implement core file operations such as browsing, searching, copying, moving, deleting, and renaming files. It leverages userFileManager for media file classification management and access, supports file access on external storage devices, and provides file compression/decompression based on zlib.

The  File Manager is a TV-form factor file management application, adapted for TV remote control interaction and large-screen interface display, supporting unified management of local and external storage.

Instructions:

1. **File Browsing**, select a media category (video, image, document, audio) or device entry on the home page to browse the local/external storage file list.
2. **File Operations**, select a file to perform operations such as copy, move, delete, rename, create file/folder, etc.
3. **File Search**, enter keywords in the SearchBar to search for files.
4. **Storage Space**, view the available space and total space of local and external storage.
5. **File Sharing**, select a file and click the share button to share the file.

### Screenshots
| Home Page                           |
|--------------------------------------|
|![](./screenshots/device/fileManager.png)|

### Project Directory
```text
entry/src/main/ets/
|---Application
|   |---MyAbilityStage.ets              // Application lifecycle entry
|---entryability
|   |---EntryAbility.ets                // Main Ability
|---common
|   |---data
|   |   |---DeviceType.ets              // Device type definition
|   |   |---FileInfo.ets                // File info data model
|   |---manager
|   |   |---AbilityManager.ets          // Ability manager
|   |   |---CompressManager.ets         // Compress/decompress manager
|   |   |---FileAccessManager.ets       // File access manager
|   |   |---FileIoManager.ets           // File IO operation manager
|   |   |---FileTaskPool.ets            // File task thread pool
|   |   |---NavPathStackManager.ets     // Navigation stack manager
|   |   |---StorageManager.ets          // Storage space manager
|   |   |---UserFileManager.ets         // User file manager
|   |---utils
|   |   |---DateTools.ets               // Date tools
|   |   |---FileUtil.ets                // File utility
|   |   |---InputKeyEventUtils.ets      // Key event utility
|   |   |---MLog.ets                    // Log utility
|   |   |---Permission.ets              // Permission management utility
|   |   |---PixelUnitConversion.ets     // Pixel unit conversion utility
|   |   |---SubtitleHelper.ets          // Subtitle helper
|   |   |---Tools.ets                   // General tools
|   |   |---lpx.ets                     // Layout pixel utility
|   |---Constants.ets                   // Constants (TABS, media types, etc.)
|   |---ConstantsMedia.ets              // Media constants (file suffixes, etc.)
|   |---FileJumpTools.ets               // File jump tools
|---component
|   |---adapter
|   |   |---BasicDataSource.ets         // Basic data source adapter
|   |   |---FileDataSource.ets          // File data source adapter
|   |   |---ListPageAdapter.ets         // List page adapter
|   |---bean
|   |   |---FileBean.ets                // File data bean
|   |---dialog
|   |   |---CreateFileDialog.ets        // Create file dialog
|   |   |---DeleteDialog.ets            // Delete confirmation dialog
|   |   |---OverrideDialog.ets          // Override confirmation dialog
|   |   |---ProgressDialog.ets          // Progress dialog
|   |   |---RenameDialog.ets            // Rename dialog
|   |   |---RenameFileDialog.ets        // Rename file dialog
|   |---FileOperationItem.ets           // File operation item component
|   |---SearchBar.ets                   // Search bar component
|   |---StorageSpaceComponent.ets       // Storage space display component
|---model
|   |---MediaType.ets                   // Media type definition
|   |---Operation.ets                   // Operation type definition
|   |---PageType.ets                    // Page type definition
|---pages
|   |---Index.ets                       // Main page (Tab switching, focus control)
|   |---Home.ets                        // Home page (media category entries)
|   |---FileList.ets                    // File list page
```

### Implementation

In the TV File Manager, file management capabilities consist of four parts: file access, file IO operations, file task scheduling, and user file management.
FileAccessManager implements file browsing, searching, deleting, and recycle bin management. FileIoManager implements low-level IO operations such as directory creation, file copy/move. FileTaskPool implements asynchronous execution of batch file operations with progress callbacks. UserFileManager wraps system capabilities for media file management.

(1) File Access Management
Uses @kit.CoreFileKit's fileAccess and trash capabilities to implement file browsing, searching, deleting, and recycle bin cleaning. See [FileAccessManager.ets](entry/src/main/ets/common/manager/FileAccessManager.ets).

(2) File IO Operations
Uses @kit.CoreFileKit's fileIo capability to implement low-level IO operations such as directory creation, directory checking, file copying, and file moving. See [FileIoManager.ets](entry/src/main/ets/common/manager/FileIoManager.ets).

(3) File Task Scheduling
Based on @kit.ArkTS's taskpool.LongTask, implements asynchronous execution of batch file operations (copy/move) with progress callbacks and cancellation support. See [FileTaskPool.ets](entry/src/main/ets/common/manager/FileTaskPool.ets).

(4) User File Management
Wraps @kit.CoreFileKit's userFileManager system capability to provide file deletion, creation, and other operations. See [UserFileManager.ets](entry/src/main/ets/common/manager/UserFileManager.ets).

(5) Compression/Decompression
Based on @kit.BasicServicesKit's zlib capability, implements file and directory compression and decompression. See [CompressManager.ets](entry/src/main/ets/common/manager/CompressManager.ets).

(6) Storage Space Management
Queries available and total space information for local and external storage. See [StorageManager.ets](entry/src/main/ets/common/manager/StorageManager.ets).

(7) Navigation and Focus Management
NavPathStackManager manages page routing stack and focus control, adapted for TV remote control interaction. See [NavPathStackManager.ets](entry/src/main/ets/common/manager/NavPathStackManager.ets).

(8) Page Interaction
The Index page manages local/external storage Tab switching, see [Index.ets](entry/src/main/ets/pages/Index.ets). The Home page displays media category entries, see [Home.ets](entry/src/main/ets/pages/Home.ets). The FileList page handles file browsing and operations, see [FileList.ets](entry/src/main/ets/pages/FileList.ets).

### Required Permissions

| Permission                                   | Description                     |
|---------------------------------------|--------------------------|
| ohos.permission.CLEAN_BACKGROUND_PROCESSES | Allow cleaning background processes               |
| ohos.permission.INTERNET | Allow network access                 |
| ohos.permission.READ_MEDIA | Allow reading media files               |
| ohos.permission.WRITE_MEDIA | Allow writing media files               |
| ohos.permission.MEDIA_LOCATION | Allow getting media location info             |
| ohos.permission.STORAGE_MANAGER | Allow accessing storage management service             |
| ohos.permission.FILE_ACCESS_MANAGER | Allow accessing file management               |
| ohos.permission.GET_BUNDLE_INFO_PRIVILEGED | Allow getting Bundle info         |
| ohos.permission.SET_WALLPAPER | Allow setting wallpaper                 |
| ohos.permission.MANAGE_MISSIONS | Allow managing missions                 |
| ohos.permission.GET_RUNNING_INFO | Allow getting running info               |
| ohos.permission.READ_AUDIO | Allow reading audio files               |
| ohos.permission.READ_IMAGEVIDEO | Allow reading image and video files            |
| ohos.permission.WRITE_IMAGEVIDEO | Allow writing image and video files            |

### Dependencies

- Test framework: Hypium (`entry/src/ohosTest`)

### Constraints and Limitations

1. This sample only supports running on standard systems. Supported devices: RK3568, large-screen TV devices.

2. The full functionality of this sample requires granting file read/write permissions, otherwise file browsing and operations will not work properly.

3. This sample uses the Stage model, adapted for API version 12 SDK, SDK version (API Version 12 Release), image version (5.0 Release).

4. This sample requires DevEco Studio version (5.0 Release) or later to compile and run.

5. This sample requires system interfaces with `@ohos.fileAccessManager` and other system permissions. When using the Full SDK, you need to manually obtain it from the mirror site and replace it in DevEco Studio. For specific operations, refer to the [replacement guide](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/faqs/full-sdk-switch-guide.md).

6. This sample requires special installation. You need to add this sample to the whitelist before installation. Details are as follows:
```json
{
    "bundleName": "com.ohos.file.manager",
    "app_signature" : [],
    "allowAppUsePrivilegeExtension": true
}
```

### Download

To download this project separately, execute the following commands:

```bash
git init
git config core.sparsecheckout true
echo code/BasicFeature/TV/TVFileManager > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
