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

// [Start import_interface_fileio]
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs, picker } from '@kit.CoreFileKit';
import Logger from '..//common//Logger';
// [End import_interface_fileio]

// 确保 getContext(this) 返回结果为 UIAbilityContext
let context = getContext(this) as common.Context;

function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct Index {
  @State uris: string[] = [];
  @State text: string = '';
  @State documentResult: string = '';
  @State result: string = '';
  @State uri_image: string = '';
  @State uri: string = '';
  @State documentUris: string[] = [];

  build() {
    Column({ space: $r('app.float.size_10') }) {
      Row({ space: $r('app.float.size_10') }) {
        // 写入文件按钮
        Button($r('app.string.saveDocumentButton'))
          .width('50%') // 按钮宽度占屏幕宽度50%
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
            this.saveDocumentFile();
          })
        // 读取文件按钮
        Button($r('app.string.readFilesButton'))
          .width('30%') // 按钮宽度占屏幕宽度30%
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
            this.selectDocumentFiles();
          })
      }
      Text(this.documentResult)
        .fontSize($r('app.float.size_50')) // 文本字体大小为50
        .fontWeight(FontWeight.Bold) // 文本字体加粗
        .margin({ top: $r('app.float.size_20') }) // 文本上边距为20
      // 保存音频文件按钮
      Button($r('app.string.saveAudioFilesButton'))
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
          this.saveAudioFile();
        })
      // 显示文件URI
      Text(this.result)
        .fontSize($r('app.float.size_50')) // 文本字体大小为50
        .fontWeight(FontWeight.Bold) // 文本字体加粗
        .margin({ top: $r('app.float.size_20') }) // 文本上边距为20
    }
    .width('100%') // 外层列布局宽度占满屏幕
    .height('100%') // 外层列布局高度占满屏幕
    .alignItems(HorizontalAlign.Center) // 水平居中对齐
    .justifyContent(FlexAlign.Center) // 垂直居中对齐
    .backgroundColor($r('app.color.lightGrayColor')) // 背景颜色为浅灰色
  }

  saveDocumentFile() {
    // [Start document_save_options]
    const documentSaveOptions = new picker.DocumentSaveOptions();
    documentSaveOptions.newFileNames = ['DocumentViewPicker01.txt'];
    documentSaveOptions.fileSuffixChoices = [resourceToString($r('app.string.document')), '.pdf'];
    // [End document_save_options]

    // [Start save_file_picker]
    const context = getContext(this) as common.Context;
    const documentViewPicker = new picker.DocumentViewPicker(context);
    documentViewPicker.save(documentSaveOptions).then((documentSaveResult: string[]) => {
      this.uris = documentSaveResult;
      Logger.info('documentViewPicker.save to file succeed and uris are:' + this.uris);
      // [StartExclude save_file_picker]
      if (this.uris.length > 0) {
        this.writeDocumentFile(this.uris[0]);
      }
      // [EndExclude save_file_picker]
    }).catch((err: BusinessError) => {
      Logger.error(`Invoke documentViewPicker.save failed, code is ${err.code}, message is ${err.message}`);
    });
    // [End save_file_picker]
  }

  writeDocumentFile(uri: string) {
    // [Start document_open_mode]
    let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
    Logger.info('file fd: ' + file.fd);
    // [End document_open_mode]

    // [Start document_writesync]
    let writeLen: number = fs.writeSync(file.fd, 'hello, world');
    Logger.info('write data to file succeed and size is:' + writeLen);
    fs.closeSync(file);
    // [End document_writesync]
  }

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
    let buffer = new ArrayBuffer(4096); // 创建一个 4096 字节的缓冲区
    let readLen = fs.readSync(file.fd, buffer);
    Logger.info('readSync data to file succeed and buffer size is:' + readLen);
    this.documentResult = 'Successfully read the file';
    fs.closeSync(file);
  }

  saveAudioFile() {
    // [Start audio_save_options]
    const audioSaveOptions = new picker.AudioSaveOptions();
    audioSaveOptions.newFileNames = ['AudioViewPicker03.mp3']; // 保存文件名（可选）
    // [End audio_save_options]

    // [Start audio_save_file]
    const context = getContext(this) as common.Context;
    const audioViewPicker = new picker.AudioViewPicker(context);
    audioViewPicker.save(audioSaveOptions).then((audioSelectResult: string[]) => {
      this.uri = audioSelectResult[0];
      Logger.info('audioViewPicker.save to file succeed and uri is:' + this.uri);
      this.writeAudioFile();
    }).catch((err: BusinessError) => {
      Logger.error(`Invoke audioViewPicker.save failed, code is ${err.code}, message is ${err.message}`);
    });
    // [Start audio_save_file]
  }

  writeAudioFile() {
    if (!this.uri) {
      Logger.error('URI is empty, cannot write file');
      return;
    }
    // [Start audio_open_mode]
    let file = fs.openSync(this.uri, fs.OpenMode.READ_WRITE);
    Logger.info('file fd: ' + file.fd);
    // [End audio_open_mode]

    // [Start audio_write_sync]
    let writeLen = fs.writeSync(file.fd, 'hello, world');
    Logger.info('write data to file succeed and size is:' + writeLen);
    fs.closeSync(file);
    // [End audio_write_sync]
    this.result = 'Successfully saved audio files';
  }
}