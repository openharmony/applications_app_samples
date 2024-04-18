# 相册

### 介绍

本示例主要展示了相册相关的功能，使用[@ohos.file.photoAccessHelper](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-library-kit/js-apis-photoAccessHelper-sys.md)
接口，实现了查看系统相册、创建用户相册、查看相册照片、用户相册文件添加和删除、以及预览图片、最近删除、收藏夹操作等功能;

### 效果预览

| 主页                              | 图片列表                              | 大图                                | 图片选择                                |
|---------------------------------|-----------------------------------|-----------------------------------|-------------------------------------|
| ![image](screenshots/home.jpeg) | ![image](screenshots/photos.jpeg) | ![image](screenshots/detail.jpeg) | ![image](screenshots/selector.jpeg) |

使用说明

1. 主界面：查询显示所有照片、系统相册（相机/视频/截屏录屏/动态照片/我的收藏/最近删除）、用户相册
2. 主界面点击“+”，创建用户相册
3. 创建用户相册时添加图片到用户相册
4. 长按相册，删除相册
5. 长按相册，重命名相册（不可重名）
6. 长按相册，相册多选，批量删除
7. 点击相册，查看相册中的图片列表
8. 点击图片，查看单个图片大图
9. 点击心形图标，收藏图片
10. 点击心形图标，取消收藏
11. 大图界面，重命名文件（可重名）
12. 大图界面，删除文件（移动到最近删除相册）
13. 从最近删除恢复照片
14. 点击视频，查看视频并播放
15. 点击图片页面右上角叹号，查看图片详情
16. 长按图片批量操作：多选/全选、删除、恢复
17. 相册内图片列表界面点击“+”，从已有相册添加照片
18. 长按图片列表图片，更多菜单，从图片选择添加到已有相册
19. 在相册图片列表界面，长按图片，选择图片，点击更多，可以将图片加入到其他相册（可多选）
20. 在用户相册图片列表界面，长按图片，选择图片，点击更多，可以将图片从当前相册移除（可多选）
21. 在用户相册图片列表界面，长按图片，选择图片，点击更多，可以查看图片详情（可多选）

### 工程目录

```
.
├── base // @ohos.file.photoAccessHelper接口封装
│   ├── FavorUserFileDataItem.ts            // 收藏夹图片数据类
│   ├── InnerUserFileDataItem.ts            // 大图数据类
│   ├── TrashUserFileDataItemCache.ts       // 最近删除图片数据缓存
│   ├── TrashUserFileDataItem.ts            // 最近删除图片数据类
│   ├── UserFileDataChangeCallback.ts       // 图片数据变化回调
│   ├── UserFileDataHelper.ts               // 图片展示信息查询接口
│   ├── UserFileDataItemCache.ts            // 图片数据缓存
│   ├── UserFileDataItem.ts                 // 图片数据类
│   ├── UserFileModel.ts                    // photoAccessHelper接口封装
│   ├── UserFileObserverCallback.ts         // 图片数据监听回调
│   └── UserFileObserver.ts                 // 图片数据监听类
├── common //业务逻辑
│   ├── ActionBarProp.ts
│   ├── AlbumDataImpl.ts                    // 相册数据查询接口封装
│   ├── AlbumDataItem.ts                    // 相册数据类
│   ├── AlbumsDataSource.ts
│   ├── BroadcastManager.ts
│   ├── Broadcast.ts
│   ├── CommonObserverCallback.ts
│   ├── EventPipeline.ts
│   ├── GlobalContext.ts
│   ├── GroupDataImpl.ts                    // 相册成员数组数据接口封装
│   ├── GroupItemDataSource.ts              // 相册成员数组数据
│   ├── ItemDataSource.ts
│   ├── MultimodalInputManager.ts
│   ├── ScreenManager.ts                    // 屏幕显示逻辑
│   ├── SelectManager.ts                    // 选择状态逻辑
│   └── SimpleAlbumDataItem.ts              // 简化相册数据类
├── components //UI组件
│   ├── ActionBarButton.ets
│   ├── ActionBar.ets
│   ├── AddNotesDialog.ets
│   ├── AlbumGridItemNewStyle.ets
│   ├── AlbumListCard.ets
│   ├── AlbumScrollBar.ets
│   ├── AlbumSelectGridItemNewStyle.ets
│   ├── AlbumSetPage.ets
│   ├── CancelOperationDialog.ets
│   ├── CustomDialogView.ets
│   ├── DeleteDialog.ets
│   ├── DeleteProgressDialog.ets
│   ├── DetailMenuPanel.ets
│   ├── DetailsDialog.ets
│   ├── DetailTitle.ets
│   ├── EmptyAlbumComponent.ets
│   ├── FindSameNameDialog.ets
│   ├── GridScrollBar.ets
│   ├── ImageGridItemComponent.ets
│   ├── LoadingPanel.ets
│   ├── MediaOperationActionBar.ets
│   ├── MultiSelectDialog.ets
│   ├── NewAlbumDialog.ets
│   ├── NoPhotoComponent.ets
│   ├── NoPhotoIndexComponent.ets
│   ├── PhotoBrowserActionBar.ets
│   ├── PhotoBrowserBg.ets
│   ├── PhotoItem.ets
│   ├── PhotoSwiper.ets
│   ├── ProgressDialog.ets
│   ├── RenameDialog.ets
│   ├── SaveDialog.ets
│   ├── SaveImageDialog.ets
│   ├── SelectionTitle.ets
│   ├── SingleTitle.ets
│   ├── ToolBarButton.ets
│   ├── ToolBar.ets
│   └── VideoIcon.ets
├── constants //常量
│   ├── AnimationConstants.ts
│   ├── BroadcastConstants.ts
│   ├── BrowserConstants.ts
│   ├── Constants.ts
│   ├── MediaConstants.ts
│   ├── QueryConstants.ts
│   └── RouterConstants.ts
├── entryability //HAP入口
│   └── EntryAbility.ts
├── menus //菜单操作
│   ├── AlbumSetDeleteMenuOperation.ts
│   ├── AlbumSetNewMenuOperation.ts
│   ├── AlbumSetRenameMenuOperation.ts
│   ├── AsyncCallback.ts
│   ├── BatchDeleteMenuOperation.ts
│   ├── BatchRecoverMenuOperation.ts
│   ├── BatchRemoveMenuOperation.ts
│   ├── ClearRecycleMenuOperation.ts
│   ├── GotoPhotosMenuOperation.ts
│   ├── MenuContext.ts
│   ├── MenuOperationCallback.ts
│   ├── MenuOperation.ts
│   ├── MoveMenuOperation.ets
│   ├── ProcessMenuOperation.ts
│   ├── RenameMenuOperation.ts
├── models //类型定义
│   ├── ActionBarMode.ts
│   ├── Action.ts
│   ├── AlbumBarModel.ts
│   ├── AlbumSelectBarModel.ts
│   ├── JumpSourceToMain.ts
│   ├── MediaOperationType.ts
│   ├── NewAlbumBarModel.ts
│   ├── PhotoGridBarModel.ts
│   ├── ThumbnailModel.ts
│   └── ViewType.ts
├── pages //页面
│   ├── AlbumSelect.ets                           // 相册选择页面
│   ├── Index.ets                                 // 主页面
│   ├── MediaOperationPage.ets                    // 图片文件操作页面
│   ├── NewAlbumPage.ets                          // 新建相册页面
│   ├── PhotoBrowser.ets                          // 大图展示页面
│   ├── PhotoGridPage.ets                         // 图片列表页面
│   ├── SelectPhotoBrowser.ets                    // 图片选择页面
│   └── VideoBrowser.ets                          // 视频查看页面
└── utils //工具类
    ├── AbilityUtils.ts
    ├── AlbumUtil.ts
    ├── DateUtil.ts
    ├── DialogUtil.ts
    ├── hisysEventUtil.ts
    ├── ImageUtil.ts
    ├── Log.ts
    ├── MathUtils.ts
    ├── ResourceUtils.ts
    ├── SingleInstanceUtils.ts
    └── UiUtil.ts

```

### 具体实现

在base模块中通过封装photoAccessHelper向外提供功能接口，如Album查询操作，源码参考：[AlbumDataImpl.ts](entry/src/main/ets/common/AlbumDataImpl.ts)

* 如效果预览中的**相册列表**：在[AlbumSetPage.ets](entry/src/main/ets/components/AlbumSetPage.ets)
  中调用AlbumDataImpl.reloadAlbumItemData()；

在base模块中通过封装photoAccessHelper向外提供功能接口，源码参考：[UserFileModel.ts](entry/src/main/ets/base/UserFileModel.ts)

* 如**新建相册**：在[AlbumSetPage.ets](entry/src/main/ets/components/AlbumSetPage.ets)
  中调用userFileModel.createAlbum()；
* 如**删除图片**：在[BatchDeleteMenuOperation.ets](entry/src/main/ets/menus/MoveMenuOperation.ets)
  中调用userFileModel.deleteOne()；
* 如**恢复图片**：在[TrashUserFileDataItem.ets](entry/src/main/ets/base/TrashUserFileDataItem.ts)
  中调用userFileModel.recover()；
* 如**永久删除图片**：在[TrashUserFileDataItem.ets](entry/src/main/ets/base/TrashUserFileDataItem.ts)
  中调用userFileModel.permanentDelete()；
* 如**删除相册**：在[AlbumDataItem.ets](entry/src/main/ets/common/AlbumDataItem.ts)
  中调用userFileModel.deleteAlbum()；

### 相关权限

[ohos.permission.WRITE_IMAGEVIDEO](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionwrite_imagevideo)

[ohos.permission.READ_IMAGEVIDEO](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionread_imagevideo)

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。

2. 本示例为Stage模型，支持API12版本SDK，SDK版本号(API Version 12 5.0.0.20),镜像版本号(5.0.0.20)

3. 本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。需要配置"apl":"system_basic"才可安装成功；

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/SystemFeature/FileManagement/Photos/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
