# 管理用户相册

## 简介

photoAccessHelper模块提供了用户相册管理的API，包括创建或删除用户相册、向用户相册添加图片和视频，以及从用户相册中删除图片和视频。为确保应用运行效率，大多数PhotoAccessHelper API都是以回调或promise模式异步实现的。

1. [photoAccessHelper](https://gitcode.com/openharmony/interface_sdk-js/blob/master/api/@ohos.file.photoAccessHelper.d.ts)
2. [abilityAccessCtrl](https://gitcode.com/openharmony/interface_sdk-js/blob/master/api/@ohos.abilityAccessCtrl.d.ts)
3. [dataSharePredicates](https://gitcode.com/openharmony/interface_sdk-js/blob/master/api/@ohos.data.dataSharePredicates.d.ts)

## 使用说明

1. 配置开发环境后，下载本示例代码工程且在IDE中构建APP确保成功；
2. 进入`entry/src/ohosTest/ets/test`文件夹；
3. 右键单击要运行的场景，选择`Run`选项；
4. 也可以右键单击`List.test.ets`运行所有场景。

## 工程目录
```
PhotoAccessHelper
entry/src/main/ets/
├── entryability
│   └── EntryAbility.ets                        # 入口能力
├── entrybackupability
│   └── EntryBackupAbility.ets                  # 备份能力
├── getfavoriteobjectability
│   └── GetFavoriteObjectAbility.ets            # 获取收藏夹对象能力
├── getmediafromfavoritesability
│   └── GetMediaFromFavoritesAbility.ets        # 从收藏夹获取媒体能力
├── getvideoalbumability
│   └── GetVideoAlbumAbility.ets                # 获取视频相册能力
├── getvideosFromvideoalbumability
│   └── GetVideosFromVideoAlbumAbility.ets      # 从视频相册获取视频能力
├── pages
│   └── Index.ets                               # 主界面
entry/src/main/resources/
└── rawfile
    ├── test.jpg                                # 测试图片
    └── test.mp4                                # 测试视频
entry/src/ohosTest/ets/
├── test
│   ├── GetFavoriteObject.test.ets              # 获取收藏夹对象单元测试
│   ├── GetMediaFromFavorites.test.ets          # 从收藏夹获取媒体单元测试
│   ├── GetVideoAlbum.test.ets                  # 获取视频相册单元测试
│   ├── GetVideosFromVideoAlbum.test.ets        # 从视频相册获取视频单元测试
│   └── List.test.ets                           # 测试套件列表
└── Provider.ets                                # 测试提供者
```

## 具体实现

* 示例项目中包含4个不同的场景，所有场景都需要用户授予相关权限。为了获取用户权限，使用了`abilityAccessCtrl.AtManager`接口的`requestPermissionsFromUser`方法。
    * 获取收藏夹对象：
        1. 从用户获取`ohos.permission.READ_IMAGEVIDEO`权限；
        2. 调用`photoAccessHelper.getAlbums`方法，并将`photoAccessHelper.AlbumType.SYSTEM`和`photoAccessHelper.AlbumSubtype.FAVORITE`值传递给其参数；
        3. 调用返回的`photoAccessHelper.FetchResult`对象的`getFirstObject`方法获取相册。
    * 从收藏夹相册获取媒体：
        1. 从用户获取`ohos.permission.READ_IMAGEVIDEO`权限；
        2. 调用`photoAccessHelper.getAlbums`方法，并将`photoAccessHelper.AlbumType.SYSTEM`和`photoAccessHelper.AlbumSubtype.FAVORITE`值传递给其参数；
        3. 调用返回的`photoAccessHelper.FetchResult`对象的`getFirstObject`方法获取相册；
        4. 创建`dataSharePredicates.DataSharePredicates`对象；
        5. 使用此谓词对象创建`photoAccessHelper.FetchOptions`对象，用于从图库中获取资源；
        6. 在获取的相册上调用`getAssets`方法，并将创建的`FetchOptions`传递给其参数，将返回值赋给一个变量；
        7. 在该变量上调用`getFirstObject`方法以获取资源。
    * 获取视频相册：
        1. 从用户获取`ohos.permission.READ_IMAGEVIDEO`权限；
        2. 调用`photoAccessHelper.getAlbums`方法，并将`photoAccessHelper.AlbumType.SYSTEM`和`photoAccessHelper.AlbumSubtype.VIDEO`值传递给其参数；
        3. 调用返回的`photoAccessHelper.FetchResult`对象的`getFirstObject`方法获取相册。
    * 从视频相册获取视频：
        1. 从用户获取`ohos.permission.READ_IMAGEVIDEO`权限；
        2. 调用`photoAccessHelper.getAlbums`方法，并将`photoAccessHelper.AlbumType.SYSTEM`和`photoAccessHelper.AlbumSubtype.VIDEO`值传递给其参数；
        3. 调用返回的`photoAccessHelper.FetchResult`对象的`getFirstObject`方法获取相册；
        4. 创建`dataSharePredicates.DataSharePredicates`对象；
        5. 使用此谓词对象创建`photoAccessHelper.FetchOptions`对象，用于从图库中获取资源；
        6. 在获取的相册上调用`getAssets`方法，并将创建的`FetchOptions`传递给其参数，将返回值赋给一个变量；
        7. 在该变量上调用`getFirstObject`方法以获取视频。

## 相关权限

- ohos.permission.READ_IMAGEVIDEO - 读取媒体资源时需要

## 依赖

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行；
2. 本示例支持API23版本SDK，版本号：6.1.0.23；
3. 本示例需要使用DevEco Studio 6.0.0 Canary1（构建版本：6.0.0.63，构建于2025年10月30日）及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/DocsSample/MediaLibraryKit/SystemAlbumUsageSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```