/**
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import MediaFileUri from './MediaFileUri';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import Logger from '../utils/Logger';
import dlpPermission from '@ohos.dlpPermission';
import picker from '@ohos.file.picker';

const TAG = '[dlpmanager_filePage]';
const OPACITY_VALUE = 0.6; // 透明度

interface myParams extends Object {
  fileName: string,
  myPath: string,
  fd: number,
  myUri: string,
  isDlpFile: boolean,
  fileSuffix: string,
}

let storage = LocalStorage.getShared();

@Entry(storage)
@Component
struct FilePage {
  @State inSandbox: boolean = false;
  @State opacityValue: number = OPACITY_VALUE;
  @State myFileName: string = '';
  @State myUri: string = '';
  @State fd: number = 0;
  @State myPath: string = '';
  @State isDLPFile: boolean = false;
  @State fileSuffix: string = '';
  @State fileSuffixIncludes: boolean = false;
  @StorageLink('editable') editable: Boolean = false;
  @StorageLink('myFileContent') myFileContent: string = '';
  controller: TextAreaController = new TextAreaController();
  newFileContent: string = '';
  @State uriSave: string = '';
  mediaFileUri: MediaFileUri = new MediaFileUri();
  scroller: Scroller = new Scroller();

  getFileInfo(): void {
    this.myFileName = decodeURIComponent((router.getParams() as myParams).fileName);
    this.myPath = (router.getParams() as myParams).myPath;
    this.myUri = (router.getParams() as myParams).myUri;
    this.fd = (router.getParams() as myParams).fd;
    this.isDLPFile = (router.getParams() as myParams).isDlpFile;
    this.fileSuffix = (router.getParams() as myParams).fileSuffix;
    this.myFileContent = this.mediaFileUri.readFileContent(this.myUri);
    this.isDlpFileFunc(this.fd, this.fileSuffix);
    Logger.info(TAG, 'The count of getFileInfo is myUri is: ' + JSON.stringify(this.myUri));
    Logger.info(TAG, 'The count of getFileInfo is myFileName is: ' + JSON.stringify(this.myFileName));
    Logger.info(TAG, 'The count of getFileInfo is myFileContent ' + this.myFileContent);
    AppStorage.setOrCreate('myFileContent', this.myFileContent);
  }

  /**
   * 是否为沙箱应用
   */
  async isSandboxFunc(): Promise<void> {
    try {
      this.inSandbox = await dlpPermission.isInSandbox();
      Logger.info(TAG, 'inSandbox:' + this.inSandbox);
      promptAction.showToast({ message: 'isSandbox:' + this.inSandbox, duration: 2000 });
    } catch (err) {
      Logger.error(TAG, 'error' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  /**
   * 获取dlp文件的uri和访问时间
   */
  async getDLPFile(): Promise<void> {
    try {
      let info: Array<dlpPermission.AccessedDLPFileInfo> = await dlpPermission.getDLPFileAccessRecords();
      promptAction.showToast({ message: 'getDLPFile:' + decodeURIComponent(JSON.stringify(info)), duration: 2000 });
      Logger.info(TAG, 'getDLPFile:', JSON.stringify(info));
    } catch (err) {
      Logger.error(TAG, 'getDLPFileAccessRecords error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  /**
   * 获取沙箱保留信息
   */
  async getSandboxList(): Promise<void> {
    try {
      let res: Array<dlpPermission.RetentionSandboxInfo> = await dlpPermission.getRetentionSandboxList(); // 获取沙箱保留列表
      Logger.info(TAG, 'res', JSON.stringify(res));
      promptAction.showToast({ message: 'getSandboxList:' + decodeURIComponent(JSON.stringify(res)), duration: 2000 });
    } catch (err) {
      Logger.error(TAG, 'getRetentionSandboxList error:' + (err as BusinessError).code + (err as BusinessError).message); // 失败报错
    }
  }

  /**
   * 获取沙箱权限
   */
  async getDlpPermission(): Promise<void> {
    dlpPermission.getDLPPermissionInfo().then((data: dlpPermission.DLPPermissionInfo) => {
      Logger.info(TAG, 'getDLPPermissionInfo, result: ' + JSON.stringify(data));
      promptAction.showToast({ message: 'permission：' + decodeURIComponent(JSON.stringify(data)), duration: 2000 });
    }).catch((err: BusinessError) => {
      Logger.info(TAG, 'getDLPPermissionInfo: ' + JSON.stringify(err));
    });
  }

  /**
   * 是否为dlp文件
   */
  async isDlpFileFunc(fd: number, fileSuffix: string): Promise<boolean> {
    try {
      this.isDLPFile = await dlpPermission.isDLPFile(fd); // 是否加密DLP文件
      Logger.info(TAG, 'isDlpFile:' + this.isDLPFile);
      this.inSandbox = await dlpPermission.isInSandbox();
      let msg = 'isDlpFile:' + this.isDLPFile + ';inSandbox:' + this.inSandbox;
      promptAction.showToast({ message: decodeURIComponent(msg), duration: 2000 });
      this.getDLPSupported(fileSuffix);
    } catch (err) {
      Logger.error(TAG, 'isDLPFile error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
    return this.isDLPFile;
  }

  /**
   * 查询当前可支持权限设置和校验的文件扩展名类型列表
   */
  async getDLPSupported(fileSuffix: string): Promise<void> {
    try {
      let res: Array<string> = await dlpPermission.getDLPSupportedFileTypes(); // 获取支持DLP的文件类型
      Logger.info(TAG, 'file extension support permission :' + JSON.stringify(res));
      Logger.info(TAG, 'file extension is:' + fileSuffix);
      this.fileSuffixIncludes = res.includes(fileSuffix);
      Logger.info(TAG, 'the file extension in the list:' + this.fileSuffixIncludes);
      promptAction.showToast({
        message: 'file extension is:' + fileSuffix + ',in the list:' + this.fileSuffixIncludes,
        duration: 2000
      });
    } catch (err) {
      Logger.error(TAG, 'getDLPSupportedFileTypes error' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  /**
   * 另存为
   */
  async callFilePickerSaveFile(fileName: string): Promise<void> {
    try {
      let DocumentSaveOptions = new picker.DocumentSaveOptions();
      DocumentSaveOptions.newFileNames = [fileName];
      let documentPicker = new picker.DocumentViewPicker();
      documentPicker.save(DocumentSaveOptions).then((DocumentSaveResult) => {
        Logger.info(TAG, 'DocumentViewPicker.save successfully, DocumentSaveResult uri: ' + JSON.stringify(DocumentSaveResult));
        if (DocumentSaveResult !== null && DocumentSaveResult !== undefined) {
          this.uriSave = DocumentSaveResult[0];
          Logger.info(TAG, `save callFilePickerSaveFile file this.uriSave: ${this.uriSave}`);
        }
        ;
        Logger.info(TAG, 'fileAsset.displayName wrFlag myFileContent :' + this.myFileContent);
        this.writeContentForSaveAsFile(this.uriSave, true); // 用 medialibrary 重新获取uri，进行写入操作
      }).catch((err: BusinessError) => {
        Logger.error(TAG, 'DocumentViewPicker.save failed with err: ' + JSON.stringify(err));
      });
    } catch (err) {
      Logger.error(TAG, 'DocumentViewPicker failed with err: ' + err);
    }
  }

  async writeContentForSaveAsFile(myUri: string, wrFlag: Boolean = false): Promise<void> {
    if (wrFlag) {
      Logger.info(TAG, 'fileAsset.displayName wrFlag is true');
      Logger.info(TAG, 'fileAsset.displayName wrFlag myFileContent :' + this.myFileContent);
      this.mediaFileUri.writeFileContent(myUri, this.myFileContent);
    }
  }

  /**
   * 生成dlp文件
   */
  async onEncrypt() {
    Logger.info(TAG + 'new file and encrypt');
    try {
      let context = getContext() as common.UIAbilityContext; // 获取当前UIAbilityContext
      let want: Want = {
        'uri': this.myUri,
        'parameters': {
          'displayName': this.myFileName
        }
      }; // 请求参数
      Logger.info(TAG, 'onEncrypt:' + JSON.stringify(want));
      dlpPermission.startDLPManagerForResult(context, want).then((res: dlpPermission.DLPManagerResult) => {
        Logger.info(TAG, 'startDLPManagerForResult res.resultCode:' + res.resultCode);
        Logger.info(TAG, 'startDLPManagerForResult res.want:' + JSON.stringify(res.want));
      }); // 打开DLP权限管理应用
    } catch (err) {
      Logger.error(TAG, 'startDLPManagerForResult error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  aboutToAppear() {
  }

  onPageShow(): void {
    this.getFileInfo();
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .width('24vp')
          .height('24vp')
          .margin({ left: '24vp', right: '16vp', top: '16vp', bottom: '16vp' })
          .objectFit(ImageFit.Contain)
          .id('filePageBack')
          .onClick(() => {
            router.back();
          })
        Text(this.myFileName)
          .width('296vp')
          .height('28vp')
          .fontSize('20vp')
          .fontFamily('HarmonyHeiTi-Bold')
          .fontColor($r('app.color.font_color_182431'))
          .textAlign(TextAlign.Start)
          .lineHeight('28vp')
          .fontWeight(700)
          .margin({ top: '13vp', bottom: '15vp' })
      }
      .height('56vp')
      .width('480vp')

      Scroll(this.scroller) {
        Column() {
          TextArea({ text: this.myFileContent, placeholder: 'Input text here...', controller: this.controller })
            .width('372vp')
            .height('100vp')
            .fontSize('16vp')
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('app.color.font_color_182431'))
            .textAlign(TextAlign.Start)
            .fontWeight(500)
            .margin({ top: '10vp', bottom: '32vp', right: '8vp' })
            .id('fileTextArea')
            .padding({
              top: 0,
              right: 0,
              left: 0,
              bottom: 0
            })
            .focusable(this.editable ? true : false)
            .focusOnTouch(true)
            .defaultFocus(false)
            .onFocus(() => {
              this.opacityValue = 1;
            })
            .onBlur(() => {
              this.opacityValue = OPACITY_VALUE;
            })
            .onChange((value: string) => {
              this.myFileContent = value;
            })
            .backgroundColor('#FFFFFF')

        }
        .width('380vp')
        .height('64vp')
        .margin({ left: '28vp', right: '72vp', top: '4vp', bottom: '576vp' })
      }

      Blank()

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
        Column() {
          Image($r('app.media.ic_public_edit'))
            .width('24vp')
            .height('24vp')
            .margin({ top: '8vp', bottom: '3vp', left: '40vp', right: '40vp' })
            .id('fileEdit')
            .onClick(() => {
              this.editable = true;
              AppStorage.setOrCreate('editable', this.editable);
              Logger.info(TAG, 'EditFile caretPosition length = ' + this.myFileContent.length);
              this.controller.caretPosition(this.myFileContent.length);
              promptAction.showToast({ message: $r('app.string.editable'), duration: 2000 });
            })

          Text($r('app.string.edit'))
            .fontSize('10vp')
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('app.color.font_color_182431'))
            .textAlign(TextAlign.Center)
            .lineHeight('14vp')
            .fontWeight(500)
            .width('136vp')
            .height('14vp')
            .margin({ left: '4vp', right: '4vp', bottom: '7vp' })
        }.width('144vp').height('56vp')

        Column() {
          Image($r('app.media.ic_public_save'))
            .width('24vp')
            .height('24vp')
            .margin({ top: '8vp', bottom: '3vp', left: '40vp', right: '40vp' })
            .id('fileSave')
            .onClick(() => {
              Logger.info(TAG, 'save onClick myFileContent is: ' + this.myFileContent);
              Logger.info(TAG, 'save onClick this.myUri: ' + this.myUri);
              this.mediaFileUri.writeFileContent(this.myUri, this.myFileContent);
              this.editable = false;
              AppStorage.setOrCreate('editable', this.editable);
              promptAction.showToast({ message: $r('app.string.saved'), duration: 2000 });
            })
          Text($r('app.string.save'))
            .fontSize('10vp')
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('app.color.font_color_182431'))
            .textAlign(TextAlign.Center)
            .lineHeight('14vp')
            .fontWeight(500)
            .width('136vp')
            .height('14vp')
            .margin({ left: '4vp', right: '4vp', bottom: '7vp' })
        }.width('144vp').height('56vp')

        Column() {
          Image($r('app.media.ic_public_more'))
            .width('24vp')
            .height('24vp')
            .margin({ top: '8vp', bottom: '3vp', left: '40vp', right: '40vp' })
            .id('fileMore')
            .bindMenu(this.filePageMenu, { placement: Placement.TopRight, offset: { x: '52vp', y: '12vp' } })
          Text($r('app.string.more'))
            .fontSize('10vp')
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('app.color.font_color_182431'))
            .textAlign(TextAlign.Center)
            .lineHeight('14vp')
            .fontWeight(500)
            .width('136vp')
            .height('14vp')
            .margin({ left: '4vp', right: '4vp', bottom: '7vp' })
        }.width('144vp').height('56vp')
      }
      .align(Alignment.Bottom)
      .height('56vp')
      .width('100%')
      .backgroundColor($r('app.color.bg_color_F1F3F5'))
    }.width('100%').height('100%')
  }

  @Builder
  filePageMenu() {
    Menu() {
      MenuItem(this.filePageTextMenu1)
        .width('124vp')
        .height('48vp')
        .margin({ left: '16vp', right: '16vp' })
        .onClick(() => {
          this.callFilePickerSaveFile(this.myFileName);
        })

      MenuItem(this.filePageDivider)

      MenuItem(this.filePageTextMenu2)
        .width('124vp')
        .height('48vp')
        .margin({ left: '16vp', right: '16vp' })
        .onClick(() => {
          this.onEncrypt();
        })
        .enabled(this.fileSuffixIncludes ? true : false)

      MenuItem(this.filePageDivider)

      MenuItem(this.filePageTextMenu3)
        .width('124vp')
        .height('48vp')
        .margin({ left: '16vp', right: '16vp' })
        .onClick(() => {
          this.getDLPFile();
        })
        .enabled(true)

      MenuItem(this.filePageDivider)

      MenuItem(this.filePageTextMenu4)
        .width('124vp')
        .height('48vp')
        .margin({ left: '16vp', right: '16vp' })
        .onClick(() => {
          this.getSandboxList();
        })
        .enabled(true)
    }
    .width('176vp').height('202vp')
    .backgroundColor('#FFFFFF')
    .borderRadius('16vp')
  }

  @Builder
  filePageTextMenu1() {
    Text($r('app.string.save_as'))
      .width('91vp')
      .height('22vp')
      .fontSize('16vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(400)
      .fontColor($r('app.color.font_color_182431'))
      .align(Alignment.Start)
      .margin({ top: '13vp', bottom: '13vp', right: '33vp' })
      .id('file_save_as')
  }

  @Builder
  filePageTextMenu2() {
    Text($r('app.string.set_permissions'))
      .width('122vp')
      .height('21vp')
      .fontSize('16vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(400)
      .fontColor(this.fileSuffixIncludes ? $r('app.color.font_color_182431') : $r('app.color.font_color_66182431'))
      .align(Alignment.Start)
      .margin({ top: '13vp', bottom: '14vp', right: '2vp' })
      .id('file_set_permissions')
  }

  @Builder
  filePageTextMenu3() {
    Text($r('app.string.query_AccessList'))
      .width('122vp')
      .height('21vp')
      .fontSize('16vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(400)
      .fontColor($r('app.color.font_color_182431'))
      .align(Alignment.Start)
      .margin({ top: '13vp', bottom: '14vp', right: '2vp' })
      .id('file_query_AccessList')
  }

  @Builder
  filePageTextMenu4() {
    Text($r('app.string.query_retentionList'))
      .width('122vp')
      .height('21vp')
      .fontSize('16vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(400)
      .fontColor($r('app.color.font_color_182431'))
      .align(Alignment.Start)
      .margin({ top: '13vp', bottom: '14vp', right: '2vp' })
      .id('file_query_retentionList')
  }

  @Builder
  filePageDivider() {
    Divider()
      .width('124vp')
      .height('0.5vp')
      .opacity(0.05)
      .backgroundColor($r('app.color.divider_color_182431'))
      .margin({ left: '16vp', right: '16vp' })
  }
}