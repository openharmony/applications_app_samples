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

@Entry
@Component
struct Index {
  @State result: string = '';
  @State saveresult: string = '';
  @State documentUris: string[] = [];
  @State audioUris: string = '';
  @State fileContent: string = '';

  build() {
    Column({ space: $r('app.float.size_10') }) { // 设置列内元素间距为10
      Column({ space: $r('app.float.size_10') }) { // 设置列内元素间距为10
        // 预制条件保存文件按钮
        Button($r('app.string.saveDocumentFileButton'))
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

            this.saveDocumentFile();
          })
        Text(this.saveresult)
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

  saveDocumentFile() {
    try {
      const documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.newFileNames = ['test0.txt', 'test0.pdf'];
      let uris: string[] = [];
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const documentViewPicker = new picker.DocumentViewPicker(context);
      documentViewPicker.save(documentSaveOptions).then((documentSaveResult: string[]) => {
        uris = documentSaveResult;
        console.info('documentViewPicker.save to file succeed and uris are:' + uris);
        this.saveresult = 'Save Success';
      }).catch((err: BusinessError) => {
        console.error(`Invoke documentViewPicker.save failed, code is ${err.code}, message is ${err.message}`);
      });
    }catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
  }

  selectDocumentFiles() {
    try {
      // [Start create_document_select_option]
      const documentSelectOptions = new picker.DocumentSelectOptions();
      // [End create_document_select_option]

      // [Start picker_select]
      let uris: string[] = [];
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const documentViewPicker = new picker.DocumentViewPicker(context);
      documentViewPicker.select(documentSelectOptions).then((documentSelectResult: string[]) => {
        uris = documentSelectResult;
        Logger.info('documentViewPicker.select to file succeed and uris are:' + uris);
        // [StartExclude picker_select]
        if (uris.length > 0) {
          this.readDocumentFile(uris);
        }
        // [EndExclude picker_select]
      }).catch((err: BusinessError) => {
        Logger.error(`Invoke documentViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
      });
      // [End picker_select]
    }catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
  }

  readDocumentFile(uris: string[]) {
    try {
      // [Start document_read_only]
      if (uris.length > 0) {
        let uri: string = uris[0];
        //这里需要注意接口权限参数是fs.OpenMode.READ_WRITE。
        let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
        console.info('file fd: ' + file.fd);
        // [Start document_fs_read_sync]
        let buffer = new ArrayBuffer(4096); // 分配一个大小为4096字节的缓冲区
        let readLen = fs.readSync(file.fd, buffer); // 读取文件内容
        Logger.info('readSync data to file succeed and buffer size is:' + readLen);
        fs.closeSync(file);
        // [Start document_fs_read_sync]
      }
      // [End document_read_only]
    }catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
    this.result = 'Read Success';
  }


  async selectAudioFile() {
    try {
      // [Start audio_select_option]
      const audioSelectOptions = new picker.AudioSelectOptions();
      // [End audio_select_option]

      // [Start audio_select_picker]
      let uris: string[] = [];
      // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const audioViewPicker = new picker.AudioViewPicker(context);
      audioViewPicker.select(audioSelectOptions).then((audioSelectResult: Array<string>) => {
        //文件选择成功后，返回被选中音频的URI结果集。
        uris = audioSelectResult;
        console.info('audioViewPicker.select to file succeed and uri is:' + uris);
        // [End audio_select_picker]
        // [StartExclude audio_view_picker]
        this.fileContent = 'Select Success';
        this.readAudioFile(uris);
        // [EndExclude audio_view_picker]
      }).catch((err: BusinessError) => {
        console.error(`Invoke audioViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
      })
    } catch (err) {
      const error: BusinessError = err as BusinessError;
      Logger.error(`Invoke audioViewPicker.select failed, code is ${error.code}, message is ${error.message}`);
    }
  }

  readAudioFile(uris: string[]) {
    try {
      // [Start openmode_read_only]
      if (uris.length > 0) {
        let uri: string = uris[0];
        //这里需要注意接口权限参数是fs.OpenMode.READ_ONLY。
        let file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
        console.info('file fd: ' + file.fd);
        // [Start fs_read_sync]
        const buffer = new ArrayBuffer(4096); // 分配一个大小为4096字节的缓冲区
        const readLen = fs.readSync(file.fd, buffer); // 读取文件内容
        Logger.info('readSync data to file succeed and buffer size is:' + readLen);
        // [StartExclude fs_read_sync]
        this.fileContent = `Read ${readLen} bytes from file.`; // 显示读取的字节数
        // [EndExclude fs_read_sync]
        fs.closeSync(file);
        // [End fs_read_sync]
      }
      // [Start openmode_read_only]
    } catch (err) {
      const error: BusinessError = err as BusinessError;
      Logger.error(`Failed to read file, code is ${error.code}, message is ${error.message}`);
    }
  }
  
}