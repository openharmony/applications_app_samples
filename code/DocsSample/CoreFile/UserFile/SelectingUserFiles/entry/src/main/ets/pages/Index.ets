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

// [Start import_interface_file]
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileAccess, fileIo as fs,  picker } from '@kit.CoreFileKit';
import Logger from '../common/Logger';
// [End import_interface_file]

let context = getContext(this) as common.Context;

@Entry
@Component
struct Index {
  @State result: string = '';
  @State documentUris: string[] = [];
  @State audioUris: string = '';
  @State fileContent: string = '';

  build() {
    Column({ space: $r('app.float.size_10') }) { // 设置列内元素间距为10
      Column({ space: $r('app.float.size_10') }) { // 设置列内元素间距为10
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
        // 选择音频文件按钮
        Button($r('app.string.selectAudioFileButton'))
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
            this.selectAudioFile();
          })
        // 显示文件内容
        Text(this.fileContent)
          .fontSize($r('app.float.size_50')) // 文本字体大小为50
          .fontWeight(FontWeight.Bold) // 文本字体加粗
          .margin({ top: $r('app.float.size_20') }) // 文本上边距为20
      }
    }
    .width('100%') // 设置外层列的宽度为100%
    .height('100%') // 设置外层列的高度为100%
    .alignItems(HorizontalAlign.Center) // 设置子元素水平居中
    .justifyContent(FlexAlign.Center) // 设置子元素垂直居中
    .backgroundColor($r('app.color.lightGrayColor')) // 设置背景颜色为浅灰色
  }

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
      } catch (err) {
        let error: BusinessError = err as BusinessError;
        Logger.error('createFile failed, errCode:' + error.code + ', errMessage:' + error.message);
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('createFileAccessHelper failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }

  selectDocumentFiles() {
    // [Start create_document_select_option]
    const documentSelectOptions = new picker.DocumentSelectOptions();
    // [End create_document_select_option]

    // [Start picker_select]
    const context = getContext(this) as common.Context;
    const documentViewPicker = new picker.DocumentViewPicker(context);
    documentViewPicker.select(documentSelectOptions).then((documentSelectResult: string[]) => {
      this.documentUris = documentSelectResult;
      Logger.info('documentViewPicker.select to file succeed and uris are:' + this.documentUris);
      // [StartExclude picker_select]
      if (this.documentUris.length > 0) {
        this.readDocumentFile(this.documentUris[0]);
      }
      // [EndExclude picker_select]
    }).catch((err: BusinessError) => {
      Logger.error(`Invoke documentViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
    });
    // [End picker_select]
  }

  readDocumentFile(uri: string) {
    // [Start document_read_only]
    let file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
    Logger.info('file fd: ' + file.fd);
    // [End document_read_only]

    // [Start document_fs_read_sync]
    let buffer = new ArrayBuffer(4096); // 分配一个大小为4096字节的缓冲区
    let readLen = fs.readSync(file.fd, buffer); // 读取文件内容
    Logger.info('readSync data to file succeed and buffer size is:' + readLen);
    this.result = 'Read Success';
    fs.closeSync(file);
    // [Start document_fs_read_sync]
  }

  // [Start audio_view_picker]
  async selectAudioFile() {
    // [Start audio_select_option]
    const audioSelectOptions = new picker.AudioSelectOptions();
    // [End audio_select_option]
    const audioViewPicker = new picker.AudioViewPicker(context);
    try {
      const audioSelectResult: string[] = await audioViewPicker.select(audioSelectOptions);
      this.audioUris = audioSelectResult[0];
      Logger.info('audioViewPicker.select to file succeed and uri is:' + this.audioUris);
      // [StartExclude audio_view_picker]
      this.fileContent = 'Select Success';
      this.readAudioFile(this.audioUris);
      // [EndExclude audio_view_picker]
    } catch (err) {
      const error: BusinessError = err as BusinessError;
      Logger.error(`Invoke audioViewPicker.select failed, code is ${error.code}, message is ${error.message}`);
    }
  }
  // [Start audio_view_picker]

  readAudioFile(uri: string) {
    try {
      // [Start openmode_read_only]
      const file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
      Logger.info('file fd: ' + file.fd);
      // [Start openmode_read_only]

      // [Start fs_read_sync]
      const buffer = new ArrayBuffer(4096); // 分配一个大小为4096字节的缓冲区
      const readLen = fs.readSync(file.fd, buffer); // 读取文件内容
      Logger.info('readSync data to file succeed and buffer size is:' + readLen);
      // [StartExclude fs_read_sync]
      this.fileContent = `Read ${readLen} bytes from file.`; // 显示读取的字节数
      // [EndExclude fs_read_sync]
      fs.closeSync(file);
      // [End fs_read_sync]
    } catch (err) {
      const error: BusinessError = err as BusinessError;
      Logger.error(`Failed to read file, code is ${error.code}, message is ${error.message}`);
    }
  }
  
}