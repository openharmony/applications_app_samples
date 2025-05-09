/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start import_user_fileAccess]
// [Start import_get_uri_assets]
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { dataSharePredicates } from '@kit.ArkData';
import { fileAccess, fileIo as fs, picker } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { Want } from '@kit.AbilityKit';
import Logger from '../common/Logger';

// context 是EntryAbility 传过来的context
let context = getContext(this) as common.UIAbilityContext;
// [End import_user_fileAccess]

// 定义一个uri数组，用于接收PhotoViewPicker选择图片返回的uri
let uris: string[] = [];

// [StartExclude import_get_uri_assets]
async function getFileAccessAbilityInfo() {
  let wantInfos: Want[] = [];
  try {
    wantInfos = await fileAccess.getFileAccessAbilityInfo();
    Logger.info('getFileAccessAbilityInfo data ' + JSON.stringify(wantInfos));
  } catch (err) {
    let error: BusinessError = err as BusinessError;
    Logger.error('getFileAccessAbilityInfo failed, errCode:' + error.code + ', errMessage:' + error.message);
  }
}
// [EndExclude import_get_uri_assets]

// [Start ]
// 调用PhotoViewPicker.select选择图片
async function photoPickerGetUri() {
  try {
    let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    // 设置最多可以选择的图片数量为1
    photoSelectOptions.maxSelectNumber = 1;
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    // 等待用户选择图片
    let photoSelectResult: photoAccessHelper.PhotoSelectResult = await photoPicker.select(photoSelectOptions);
    Logger.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(photoSelectResult));
    uris = photoSelectResult.photoUris;
  } catch (err) {
    Logger.error('PhotoViewPicker.select failed with err: ' + JSON.stringify(err));
  }
}

async function uriGetAssets(): Promise<string> {
  // 检查uris数组是否为空
  if (uris.length === 0) {
    throw new Error('No URIs available');
  }
  try {
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    // 配置查询条件，使用PhotoViewPicker选择图片返回的uri进行查询
    predicates.equalTo('uri', uris[0]);
    let fetchOption: photoAccessHelper.FetchOptions = {
      fetchColumns: [photoAccessHelper.PhotoKeys.WIDTH, photoAccessHelper.PhotoKeys.HEIGHT,
        photoAccessHelper.PhotoKeys.TITLE, photoAccessHelper.PhotoKeys.DURATION],
      predicates: predicates
    };
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
      await phAccessHelper.getAssets(fetchOption);
    // 得到uri对应的PhotoAsset对象，读取文件的部分信息
    const asset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
    console.info('asset displayName: ', asset.displayName);
    console.info('asset uri: ', asset.uri);
    console.info('asset photoType: ', asset.photoType);
    console.info('asset width: ', asset.get(photoAccessHelper.PhotoKeys.WIDTH));
    console.info('asset height: ', asset.get(photoAccessHelper.PhotoKeys.HEIGHT));
    console.info('asset title: ' + asset.get(photoAccessHelper.PhotoKeys.TITLE));
    // 获取缩略图
    asset.getThumbnail((err, pixelMap) => {
      if (err == undefined) {
        console.info('getThumbnail successful ' + JSON.stringify(pixelMap));
      } else {
        console.error('getThumbnail fail', err);
      }
    });
    // [StartExclude import_get_uri_assets]
    if (uris.length !== 0 && asset !== null) {
      return 'ReadMediaUriSuccess';
    }
    // [EndExclude import_get_uri_assets]
  } catch (error) {
    console.error('uriGetAssets failed with err: ' + JSON.stringify(error));
    return 'ReadMediaUriFail';
  }
  return 'ReadMediaUriFail';
}
// [End import_get_uri_assets]

@Entry
@Component
struct Index {
  @State uriMessage: string = ''; // 初始化状态变量，用于显示消息
  @State result: string = '';
  @State documentUris: string[] = [];

  build() {
    Column({ space: $r('app.float.size_10') }) { // 外层列布局，子元素间距为10
      Column({ space: $r('app.float.size_10') }) { // 内层列布局，子元素间距为10
        // 读取文件uri按钮
        Button($r('app.string.readDocumentUriButton'))
          .width('80%') // 按钮宽度占屏幕宽度80%
          .height('10%') // 按钮高度占屏幕高度10%
          .fontSize($r('app.float.size_25')) // 按钮字体大小为25
          .borderRadius($r('app.float.size_25')) // 按钮圆角半径为25
          .backgroundColor($r('app.color.whiteColor')) // 按钮背景颜色为白色
          .shadow({
            radius: $r('app.float.size_10'), // 阴影半径为10
            color: $r('app.color.grayColor'), // 阴影颜色为灰色
            offsetX: $r('app.float.size_15'), // 阴影水平偏移量为15
            offsetY: $r('app.float.size_15') // 阴影垂直偏移量为15
          })
          .fontColor($r('app.color.blackColor')) // 按钮字体颜色为黑色
          .onClick(() => {
            this.uriMessage = ''; // 重置消息为默认值
            this.documentURIExample(); // 调用方法处理文档URI
          })
        // 读取图片uri按钮
        Button($r('app.string.readMediaUriButton'))
          .width('80%') // 按钮宽度占屏幕宽度80%
          .height('10%') // 按钮高度占屏幕高度10%
          .fontSize($r('app.float.size_25')) // 按钮字体大小为25
          .borderRadius($r('app.float.size_25')) // 按钮圆角半径为25
          .backgroundColor($r('app.color.whiteColor')) // 按钮背景颜色为白色
          .shadow({
            radius: $r('app.float.size_10'), // 阴影半径为10
            color: $r('app.color.grayColor'), // 阴影颜色为灰色
            offsetX: $r('app.float.size_15'), // 阴影水平偏移量为15
            offsetY: $r('app.float.size_15') // 阴影垂直偏移量为15
          })
          .fontColor($r('app.color.blackColor')) // 按钮字体颜色为黑色
          .onClick(async () => {
            try {
              this.uriMessage = ''; // 重置消息为默认值
              // 首先获取图片URI
              await photoPickerGetUri();
              // 然后获取图片资源信息
              this.uriMessage = await uriGetAssets();
            } catch (error) {
              Logger.error('Error:', error); // 日志记录错误信息
              this.uriMessage = 'Error: ' + error.message; // 显示错误信息
            }
          })
        // 通过uri复制文件按钮
        Button($r('app.string.copyAFileButton'))
          .width('80%') // 按钮宽度占屏幕宽度80%
          .height('10%') // 按钮高度占屏幕高度10%
          .fontSize($r('app.float.size_25')) // 按钮字体大小为25
          .borderRadius($r('app.float.size_25')) // 按钮圆角半径为25
          .backgroundColor($r('app.color.whiteColor')) // 按钮背景颜色为白色
          .shadow({
            radius: $r('app.float.size_10'), // 阴影半径为10
            color: $r('app.color.grayColor'), // 阴影颜色为灰色
            offsetX: $r('app.float.size_15'), // 阴影水平偏移量为15
            offsetY: $r('app.float.size_15') // 阴影垂直偏移量为15
          })
          .fontColor($r('app.color.blackColor')) // 按钮字体颜色为黑色
          .onClick(() => {
            this.uriMessage = ''; // 重置消息为默认值
            this.copyingFileByUriExample(); // 调用方法处理文件复制
          })
        Text(this.uriMessage)
          .fontSize($r('app.float.size_50')) // 文本字体大小为50
          .fontWeight(FontWeight.Bold) // 文本字体加粗
          .margin({ top: $r('app.float.size_20') }) // 文本上边距为20
        // 读取文件按钮
        Button($r('app.string.selectDocumentFileButton'))
          .width('80%') // 按钮宽度占屏幕宽度80%
          .height('10%') // 按钮高度占屏幕高度10%
          .fontSize($r('app.float.size_25')) // 按钮字体大小为25
          .borderRadius($r('app.float.size_25')) // 按钮圆角半径为25
          .backgroundColor($r('app.color.whiteColor')) // 按钮背景颜色为白色
          .shadow({
            radius: $r('app.float.size_10'), // 阴影半径为10
            color: $r('app.color.grayColor'), // 阴影颜色为灰色
            offsetX: $r('app.float.size_15'), // 阴影水平偏移量为15
            offsetY: $r('app.float.size_15') // 阴影垂直偏移量为15
          })
          .fontColor($r('app.color.blackColor')) // 按钮字体颜色为黑色
          .onClick(() => {
            this.documentURIExample();
            this.selectDocumentFiles();
          })
        Text(this.result)
          .fontSize($r('app.float.size_50')) // 文本字体大小为50
          .fontWeight(FontWeight.Bold) // 文本字体加粗
          .margin({ top: $r('app.float.size_20') }) // 文本上边距为20
      }
    }
    .width('100%') // 外层列布局宽度占满屏幕
    .height('100%') // 外层列布局高度占满屏幕
    .alignItems(HorizontalAlign.Center) // 水平居中对齐
    .justifyContent(FlexAlign.Center) // 垂直居中对齐
    .backgroundColor($r('app.color.lightGrayColor')) // 背景颜色为浅灰色
  }

  // [Start function_example]
  async documentURIExample() {
    let fileAccessHelper: fileAccess.FileAccessHelper;
    // wantInfos 从getFileAccessAbilityInfo()获取
    let wantInfos: Want[] = [
      {
        bundleName: 'com.ohos.UserFile.ExternalFileManager',
        abilityName: 'FileExtensionAbility',
      },
    ];
    try {
      fileAccessHelper = fileAccess.createFileAccessHelper(context, wantInfos);
      if (!fileAccessHelper) {
        Logger.error('createFileAccessHelper interface returns an undefined object');
      }
      // 以内置存储目录为例
      // 示例代码sourceUri表示Download目录，该uri是对应的fileInfo中uri
      // 开发者应根据自己实际获取的uri进行开发
      let sourceUri: string = 'file://docs/storage/Users/currentUser/Download';
      let displayName: string = 'test1.txt';
      let fileUri: string;
      try {
        // 创建文件返回该文件的uri
        fileUri = await fileAccessHelper.createFile(sourceUri, displayName);
        if (!fileUri) {
          Logger.error('createFile return undefined object');
        }
        Logger.info('createFile success, fileUri: ' + JSON.stringify(fileUri));
        // 将刚创建的文件进行重命名，返回新文件的uri
        let renameUri = await fileAccessHelper.rename(fileUri, 'renameFile.txt');
        Logger.info('rename success, renameUri: ' + JSON.stringify(renameUri));
        this.uriMessage = 'ReadDocumentUriSuccess';
      } catch (err) {
        let error: BusinessError = err as BusinessError;
        Logger.error('createFile failed, errCode:' + error.code + ', errMessage:' + error.message);
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('createFileAccessHelper failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }
  // [Start function_example]
 
  // [Start copy_file_uri_example ]
  async copyingFileByUriExample() {
    let fileAccessHelper: fileAccess.FileAccessHelper;
    // wantInfos 从getFileAccessAbilityInfo()获取
    let wantInfos: Want[] = [
      {
        bundleName: 'com.ohos.UserFile.ExternalFileManager',
        abilityName: 'FileExtensionAbility',
      },
    ];
    try {
      fileAccessHelper = fileAccess.createFileAccessHelper(context, wantInfos);
      if (!fileAccessHelper) {
        Logger.error('createFileAccessHelper interface returns an undefined object');
      }
      // 以内置存储目录为例
      // 示例代码sourceUri表示Download目录，该uri是对应的fileInfo中uri
      // 开发者应根据自己实际获取的uri进行开发
      let sourceUri: string = 'file://docs/storage/Users/currentUser/Download/renameFile.txt';
      // 将文件复制到的位置uri
      let destUri: string = 'file://docs/storage/Users/currentUser/Documents';
      // 如果文件名冲突，要使用的文件名
      let displayName: string = 'file.txt';
      // 存放返回的uri
      let fileUri: string;
      try {
        // 复制文件返回该文件的uri
        fileUri = await fileAccessHelper.copyFile(sourceUri, destUri, displayName);
        if (!fileUri) {
          Logger.error('copyFile return undefined object');
        }
        Logger.info('copyFile success, fileUri: ' + JSON.stringify(fileUri));
        this.uriMessage = 'CopyAFileSuccess';
      } catch (err) {
        let error: BusinessError = err as BusinessError;
        Logger.error('copyFile failed, errCode:' + error.code + ', errMessage:' + error.message);
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('createFileAccessHelper failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }
  // [End copy_file_uri_example]

  selectDocumentFiles() {
    const documentSelectOptions = new picker.DocumentSelectOptions();
    const context = getContext(this) as common.Context;
    const documentViewPicker = new picker.DocumentViewPicker(context);
    documentViewPicker.select(documentSelectOptions).then((documentSelectResult: string[]) => {
      this.documentUris = documentSelectResult;
      Logger.info('documentViewPicker.select to file succeed and uris are:' + this.documentUris);
      if (this.documentUris.length > 0) {
        this.readDocumentFile(this.documentUris[0]);
      }
    }).catch((err: BusinessError) => {
      Logger.error(`Invoke documentViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
    });
  }

  readDocumentFile(uri: string) {
    let file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
    Logger.info('file fd: ' + file.fd);
    let buffer = new ArrayBuffer(4096); // 分配一个大小为4096字节的缓冲区
    let readLen = fs.readSync(file.fd, buffer); // 读取文件内容
    Logger.info('readSync data to file succeed and buffer size is:' + readLen);
    this.result = 'readSync data to file succeed and buffer size is:' + readLen;
    fs.closeSync(file);
  }
}