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

// [Start import_interface_picker]
import { fileUri, picker } from '@kit.CoreFileKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
// [End import_interface_picker]

@Entry
@Component
struct Index {
  @State text: string = '';
  @State documentResult: string = '';
  @State result: string = '';
  @State downloadResult: string = '';
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
      // Download按钮
      Button($r('app.string.downloadSaveFileButton'))
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
          this.downLoad();
        })
      // 显示downloadResult。
      Text(this.downloadResult)
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
    try {
      // [Start document_save_options]
      const documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.newFileNames = ['DocumentViewPicker01.txt'];
      documentSaveOptions.fileSuffixChoices = ['文档|.txt', '.pdf'];
      // [End document_save_options]

      // [Start save_file_picker]
      let uris: string[] = [];
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const documentViewPicker = new picker.DocumentViewPicker(context);
      documentViewPicker.save(documentSaveOptions).then((documentSaveResult: string[]) => {
        uris = documentSaveResult;
        console.info('documentViewPicker.save to file succeed and uris are:' + uris);
        // [StartExclude save_file_picker]
          this.writeDocumentFile(uris);
        // [EndExclude save_file_picker]
      }).catch((err: BusinessError) => {
        console.error(`Invoke documentViewPicker.save failed, code is ${err.code}, message is ${err.message}`);
      });
      // [End save_file_picker]
    }catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
  }

  writeDocumentFile(uris: string[]) {
    try {
      // [Start document_open_mode]
      if (uris.length > 0) {
        let uri: string = uris[0];
        let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
        console.info('file fd: ' + file.fd);
        // [Start document_writesync]
        let writeLen: number = fs.writeSync(file.fd, 'hello, world');
        console.info('write data to file succeed and size is:' + writeLen);
        fs.closeSync(file);
        // [End document_writesync]
      }
      // [End document_open_mode]
    }catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
  }

  selectDocumentFiles() {
    try {
      const documentSelectOptions = new picker.DocumentSelectOptions();
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const documentViewPicker = new picker.DocumentViewPicker(context);
      documentViewPicker.select(documentSelectOptions).then((documentSelectResult: string[]) => {
        this.documentUris = documentSelectResult;
        console.info('documentViewPicker.select to file succeed and uris are:' + this.documentUris);
        if (this.documentUris.length > 0) {
          this.readDocumentFile(this.documentUris[0]);
        }
      }).catch((err: BusinessError) => {
        console.error(`Invoke documentViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
      });
    } catch (error) {
        let err: BusinessError = error as BusinessError;
        console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
  }

  readDocumentFile(uri: string) {
    try {
      let file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
      console.info('file fd: ' + file.fd);
      let buffer = new ArrayBuffer(4096); // 创建一个 4096 字节的缓冲区
      let readLen = fs.readSync(file.fd, buffer);
      console.info('readSync data to file succeed and buffer size is:' + readLen);
      this.documentResult = 'Successfully read the file';
      fs.closeSync(file);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
  }

  saveAudioFile() {
    try {
      // [Start audio_save_options]
      const audioSaveOptions = new picker.AudioSaveOptions();
      audioSaveOptions.newFileNames = ['AudioViewPicker03.mp3']; // 保存文件名（可选）
      // [End audio_save_options]

      // [Start audio_save_file]
      let uris: string[] = [];
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const audioViewPicker = new picker.AudioViewPicker(context);
      audioViewPicker.save(audioSaveOptions).then((audioSelectResult: string[]) => {
        uris = audioSelectResult;
        console.info('audioViewPicker.save to file succeed and uri is:' + uris);
        // [StartExclude audio_save_file]
        this.writeAudioFile(uris);
        // [EndExclude audio_save_file]
      }).catch((err: BusinessError) => {
        console.error(`Invoke audioViewPicker.save failed, code is ${err.code}, message is ${err.message}`);
      });
      // [Start audio_save_file]
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
  }

  writeAudioFile(uris: string[]) {
    try {
      // [Start audio_open_mode]
      if (uris.length > 0) {
        let uri: string = uris[0];
        //这里需要注意接口权限参数是fileIo.OpenMode.READ_WRITE。
        let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
        console.info('file fd: ' + file.fd);
        // [End audio_open_mode]

        // [Start audio_write_sync]
        let writeLen = fs.writeSync(file.fd, 'hello, world');
        console.info('write data to file succeed and size is:' + writeLen);
        fs.closeSync(file);
        // [End audio_write_sync]
      }
      this.result = 'Successfully saved audio files';
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
  }

  downLoad() {
    try {
      // [Start download_save_file]
      let uri: string = '';
      // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const documentViewPicker = new picker.DocumentViewPicker(context);
      // [Start download_save_options]
      const documentSaveOptions = new picker.DocumentSaveOptions();
      // 配置保存的模式为DOWNLOAD，若配置了DOWNLOAD模式，此时配置的其他documentSaveOptions参数将不会生效。
      documentSaveOptions.pickerMode = picker.DocumentPickerMode.DOWNLOAD;
      // [End download_save_options]
      documentViewPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
        uri = documentSaveResult[0];
        console.info('documentViewPicker.save succeed and uri is:' + uri);
        const testFilePath = new fileUri.FileUri(uri + '/test.txt').path;
        const file = fs.openSync(testFilePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd, 'Hello World!');
        fs.closeSync(file.fd);
      }).catch((err: BusinessError) => {
        console.error(`Invoke documentViewPicker.save failed, code is ${err.code}, message is ${err.message}`);
      })
      // [Start download_save_file]
      this.downloadResult = 'Successfully download';
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
  }
}