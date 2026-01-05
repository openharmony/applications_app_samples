# 管理用户相册

## 简介

photoAccessHelper模块提供了用户相册管理的API，包括创建或删除用户相册、向用户相册添加图片和视频，以及从用户相册中删除图片和视频。为确保应用运行效率，大多数PhotoAccessHelper API都是以回调或promise模式异步实现的。

1. [photoAccessHelper](https://gitcode.com/openharmony/interface_sdk-js/blob/master/api/@ohos.file.photoAccessHelper.d.ts)
2. [abilityAccessCtrl](https://gitcode.com/openharmony/interface_sdk-js/blob/master/api/@ohos.abilityAccessCtrl.d.ts)
3. [dataSharePredicates](https://gitcode.com/openharmony/interface_sdk-js/blob/master/api/@ohos.data.dataSharePredicates.d.ts)

## 使用说明

1. 配置环境后，下载本示例代码工程且在IDE中编译；
2. 进入`entry/src/ohosTest/ets/test`文件夹；
3. 右键单击要运行的场景，选择`Run`选项；
4. 也可以右键单击`List.test.ets`运行所有场景。

## 工程目录
```
PhotoAccessHelper
├── entry/src/main/ets/
│   ├── addmediatouseralbumability
│   │   └── AddMediaToUserAlbumAbility.ets         # 添加媒体到用户相册能力
│   ├── entryability
│   │   └── EntryAbility.ets                       # 入口能力
│   ├── entrybackupability
│   │   └── EntryBackupAbility.ets                 # 备份能力
│   ├── getmediafromuseralbumability
│   │   └── GetMediaFromUserAlbumAbility.ets       # 从用户相册获取媒体能力
│   ├── getuseralbumability
│   │   └── GetUserAlbumAbility.ets                # 获取用户相册能力
│   ├── pages
│   │   └── Index.ets                              # 主界面
│   ├── removemediafromuseralbumability
│   │   └── RemoveMediaFromUserAlbumAbility.ets    # 从用户相册移除媒体能力
│   └── renameuseralbumability
│       └── RenameUserAlbumAbility.ets             # 重命名用户相册能力
├── entry/src/main/resources/
│   └── rawfile
│       └── test.jpg                               # 测试图片
└── entry/src/ohosTest/ets/
    ├── test
    │   ├── AddMediaToUserAlbum.test.ets           # 添加媒体单元测试
    │   ├── GetMediaFromUserAlbum.test.ets         # 获取媒体单元测试
    │   ├── GetUserAlbum.test.ets                  # 获取相册单元测试
    │   ├── List.test.ets                          # 测试套件列表 
    │   ├── RemoveMediaFromUserAlbum.test.ets      # 移除媒体单元测试
    │   └── RenameUserAlbum.test.ets               # 重命名相册单元测试
    └── Provider.ets                               # 测试提供者
```

## 具体实现

* 示例项目中包含5个不同的场景，所有场景都需要用户授予相关权限。为了获取用户权限，使用了`abilityAccessCtrl.AtManager`接口的`requestPermissionsFromUser`方法。
    * 向用户相册添加媒体：
        1. 从用户获取`ohos.permission.READ_IMAGEVIDEO`和`ohos.permission.WRITE_IMAGEVIDEO`权限；
        2. 创建`dataSharePredicates.DataSharePredicates`对象，使用`equalTo`方法指定相册；
        3. 使用此谓词对象创建`photoAccessHelper.FetchOptions`对象，用于从图库中获取指定相册；
        4. 调用`photoAccessHelper.getAlbums`方法，然后调用返回的`photoAccessHelper.FetchResult`对象的`getFirstObject`方法获取相册；
        5. 对照片资源执行相同操作，但使用`.getAssets`方法而不是`.getAlbums`；
        6. 通过调用`photoAccessHelper.MediaAlbumChangeRequest`并将已获取的相册对象传递给其参数，创建一个`photoAccessHelper.MediaAlbumChangeRequest`对象；
        7. 在更改请求对象上调用`addAssets`，并将获取的照片资源传递给其参数；
        8. 最后，调用`PhotoAccessHelper`接口的`applyChanges`方法，传入创建的更改请求对象。
    * 从用户相册获取媒体：
        1. 从用户获取`ohos.permission.READ_IMAGEVIDEO`和`ohos.permission.WRITE_IMAGEVIDEO`权限；
        2. 创建`dataSharePredicates.DataSharePredicates`对象，使用`equalTo`方法指定相册；
        3. 使用此谓词对象创建`photoAccessHelper.FetchOptions`对象，用于从图库中获取指定相册；
        4. 调用`photoAccessHelper.getAlbums`方法，然后调用返回的`photoAccessHelper.FetchResult`对象的`getFirstObject`方法获取相册；
        5. 对照片资源执行相同操作，并将`FetchOptions`对象传递给已获取的`photoAccessHelper.Album`接口对象的`getAssets`方法，将返回值赋给一个变量；
        6. 在该变量上调用`getFirstObject`方法以获取资源。
    * 从图库获取相册：
        1. 从用户获取`ohos.permission.READ_IMAGEVIDEO`权限；
        2. 创建`dataSharePredicates.DataSharePredicates`对象，使用`equalTo`方法指定相册；
        3. 使用此谓词对象创建`photoAccessHelper.FetchOptions`对象，用于从图库中获取指定相册；
        4. 调用`photoAccessHelper.getAlbums`方法，然后调用返回的`photoAccessHelper.FetchResult`对象的`getFirstObject`方法获取相册。
    * 从用户相册移除媒体：
        1. 从用户获取`ohos.permission.READ_IMAGEVIDEO`和`ohos.permission.WRITE_IMAGEVIDEO`权限；
        2. 创建`dataSharePredicates.DataSharePredicates`对象，使用`equalTo`方法指定相册；
        3. 使用此谓词对象创建`photoAccessHelper.FetchOptions`对象，用于从图库中获取指定相册；
        4. 调用`photoAccessHelper.getAlbums`方法，然后调用返回的`photoAccessHelper.FetchResult`对象的`getFirstObject`方法获取相册；
        5. 对照片资源执行相同操作，并将`FetchOptions`对象传递给已获取的`photoAccessHelper.Album`接口对象的`getAssets`方法，将返回值赋给一个变量；
        6. 在该变量上调用`getFirstObject`方法以获取照片资源；
        7. 通过调用`photoAccessHelper.MediaAlbumChangeRequest`并将已获取的相册对象传递给其参数，创建一个`photoAccessHelper.MediaAlbumChangeRequest`对象；
        8. 在更改请求对象上调用`removeAssets`，并将获取的照片资源传递给其参数；
        9. 最后，调用`PhotoAccessHelper`接口的`applyChanges`方法，传入创建的更改请求对象。
    * 重命名用户相册：
        1. 从用户获取`ohos.permission.READ_IMAGEVIDEO`和`ohos.permission.WRITE_IMAGEVIDEO`权限；
        2. 创建`dataSharePredicates.DataSharePredicates`对象，使用`equalTo`方法指定相册；
        3. 使用此谓词对象创建`photoAccessHelper.FetchOptions`对象，用于从图库中获取指定相册；
        4. 调用`photoAccessHelper.getAlbums`方法，然后调用返回的`photoAccessHelper.FetchResult`对象的`getFirstObject`方法获取相册；
        5. 通过调用`photoAccessHelper.MediaAlbumChangeRequest`并将已获取的相册对象传递给其参数，创建一个`photoAccessHelper.MediaAlbumChangeRequest`对象；
        6. 在更改请求对象上调用`setAlbumName`，并将新相册名称传递给其参数；
        7. 最后，调用`PhotoAccessHelper`接口的`applyChanges`方法，传入创建的更改请求对象。

## 相关权限

- ohos.permission.READ_IMAGEVIDEO - 读取媒体资源时需要
- ohos.permission.WRITE_IMAGEVIDEO - 修改或删除媒体资源时需要

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
echo code/DocsSample/MediaLibraryKit/UserAlbumUsageSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```