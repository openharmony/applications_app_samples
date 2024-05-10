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
import fs from '@ohos.file.fs';
import Logger from '../utils/Logger';
import dlpPermission from '@ohos.dlpPermission';
import picker from '@ohos.file.picker';

const TAG = '[dlpmanager_dlpPage]';
const OPACITY_VALUE = 0.6; // 透明度

let storage = LocalStorage.getShared();

interface DLPUriObj {
  name: string
};

interface DLPNameObj {
  dateModified: string,
  displayName: string,
  relativePath: string,
};

interface DLPLinkNameObj {
  name: string
}

@Entry(storage)
@Component
struct DlpPage {
  @State inSandbox: boolean = false;
  @State opacityValue: number = OPACITY_VALUE;
  @State dlpName: string = '';
  @State dlpLinkName: string = '';
  @State dlpUri: string = '';
  @State dlpLinkUri: string = '';
  @State fd: number = 0;
  @State isDLPFile: boolean = false;
  @State dlpSuffix: string = '';
  @State dlpSuffixIncludes: boolean = false;
  @StorageLink('editable') editable: Boolean = false;
  @State dlpContent: string = '';
  controller: TextAreaController = new TextAreaController();
  @State uriSave: string = '';
  mediaFileUri: MediaFileUri = new MediaFileUri();
  scroller: Scroller = new Scroller();

  /**
   * 是否为沙箱应用
   */
  async isSandboxFunc(): Promise<void> {
    try {
      this.inSandbox = await dlpPermission.isInSandbox(); // 是否在沙箱内
      Logger.info(TAG, 'inSandbox:' + this.inSandbox);
      promptAction.showToast({ message: 'inSandbox:' + this.inSandbox, duration: 2000 });
    } catch (err) {
      Logger.error(TAG, 'error' + (err as BusinessError).code + (err as BusinessError).message);
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
  async isDlpFileFunc(fd: number): Promise<boolean> {
    try {
      this.isDLPFile = await dlpPermission.isDLPFile(fd); // 是否加密DLP文件
      Logger.info(TAG, 'isDlpFile:' + this.isDLPFile);
      this.inSandbox = await dlpPermission.isInSandbox();
      let msg = 'isDlpFile:' + true + ';inSandbox:' + this.inSandbox;
      dlpPermission.getDLPPermissionInfo().then((data: dlpPermission.DLPPermissionInfo) => {
        Logger.info(TAG, 'getDLPPermissionInfo, result: ' + JSON.stringify(data));
        promptAction.showToast({
          message: msg + ' permission：' + decodeURIComponent(JSON.stringify(data)),
          duration: 2000
        });
      }).catch((err: BusinessError) => {
        Logger.info(TAG, 'getDLPPermissionInfo: ' + JSON.stringify(err));
      });
    } catch (err) {
      Logger.error(TAG, 'isDLPFile error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
    return this.isDLPFile;
  }

  /**
   * 另存为
   */
  async callFilePickerSaveFile(fileName: string): Promise<void> {
    try {
      let DocumentSaveOptions = new picker.DocumentSaveOptions();
      DocumentSaveOptions.newFileNames = [fileName];
      let documentPicker = new picker.DocumentViewPicker();
      documentPicker.save(DocumentSaveOptions).then(async (DocumentSaveResult) => {
        Logger.info(TAG, 'DocumentViewPicker.save successfully, DocumentSaveResult uri: ' + JSON.stringify(DocumentSaveResult));
        if (DocumentSaveResult !== null && DocumentSaveResult !== undefined) {
          this.uriSave = DocumentSaveResult[0];
          Logger.info(TAG, `save callFilePickerSaveFile file this.uriSave: ${this.uriSave}`);
        }
        Logger.info(TAG, 'fileAsset.displayName wrFlag myFileContent :' + this.dlpContent);
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
      Logger.info(TAG, 'fileAsset.displayName wrFlag myFileContent :' + this.dlpContent);
      this.mediaFileUri.writeFileContent(myUri, this.dlpContent);
    }
  }

  /**
   * 生成dlp文件
   */
  async onEncrypt() {
    Logger.info(TAG + 'new file and encrypt');
    let context = getContext() as common.UIAbilityContext; // 获取当前UIAbilityContext
    let want: Want = {
      "action": "ohos.want.action.editData",
      "bundleName": "com.ohos.dlpmanager",
      "type": "text/plain",
      "abilityName": "MainAbility",
      "uri": this.dlpUri,
      "parameters": {
        "displayName": this.dlpName,
        "fileName": { "name": this.dlpName },
        "linkFileName": { "name": this.dlpLinkName },
      }
    };
    try {
      Logger.info(TAG, "openDLPFile:" + JSON.stringify(want));
      context.startAbility(want, (error: BusinessError) => {
        Logger.error(TAG, 'want error.code =' + error.code + ',error.message =' + error.message);
      });
    } catch (err) {
      Logger.error('openDLPFile startAbility failed' + (err as BusinessError).code + (err as BusinessError).message);
      return;
    }
  }

  async getOriginalFileNameFunc(fileName: string) {
    try {
      let res = dlpPermission.getOriginalFileName(fileName); // 获取原始文件名
      Logger.info(TAG, 'OriginalFileName:' + res);
      promptAction.showToast({ message: 'OriginalFileName:' + decodeURIComponent(res), duration: 2000 });
    } catch (err) {
      Logger.error(TAG, 'getOriginalFileNameFunc error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  async getDLPSuffixFunc() {
    try {
      let res = dlpPermission.getDLPSuffix(); // 获取DLP拓展名
      Logger.info(TAG, 'Extension name:' + res);
      promptAction.showToast({ message: 'Extension name:' + res, duration: 2000 });
    } catch (err) {
      Logger.error(TAG, 'getDLPSuffix error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  /**
   * 设置沙箱保留
   */
  async setSandboxFile(): Promise<void> {
    try {
      let docUris: Array<string> = [this.dlpUri];
      dlpPermission.setRetentionState(docUris); // 设置沙箱保留
      promptAction.showToast({ message: 'set success', duration: 2000 });
    } catch (err) {
      Logger.error(TAG, 'setRetentionState error' + (err as BusinessError).code + (err as BusinessError).message); // 失败报错
    }
  }

  /**
   * 取消沙箱保留
   */
  async cancelSandboxFile(): Promise<void> {
    try {
      let docUris: Array<string> = [this.dlpUri];
      dlpPermission.cancelRetentionState(docUris); // 设置沙箱保留
      promptAction.showToast({ message: 'cancel success', duration: 2000 });
    } catch (err) {
      Logger.error(TAG, 'setRetentionState error' + (err as BusinessError).code + (err as BusinessError).message); // 失败报错
    }
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear ------');
  }

  onPageShow(): void {
    Logger.info(TAG, "onPageShow begin ------");
    let wantInfo: Want = AppStorage.get("funcAbilityWant") as Want;
    Logger.info(TAG, "funcAbilityWant:" + JSON.stringify(wantInfo));
    this.dlpLinkUri = wantInfo.uri as string;
    this.dlpUri = (wantInfo.parameters?.dlpUri as DLPUriObj).name;
    this.dlpName = decodeURIComponent((wantInfo.parameters?.fileAsset as DLPNameObj).displayName);
    this.dlpLinkName = (wantInfo.parameters?.linkFileName as DLPLinkNameObj).name;

    this.dlpContent = this.mediaFileUri.readFileContent(this.dlpLinkUri);
    Logger.info(TAG, "funcAbilityWant dlpLinkUri:" + this.dlpLinkUri);
    Logger.info(TAG, "funcAbilityWant dlpUri:" + this.dlpUri);
    Logger.info(TAG, "funcAbilityWant dlpName:" + this.dlpName);
    Logger.info(TAG, "funcAbilityWant dlpLinkName:" + this.dlpLinkName);
    Logger.info(TAG, "funcAbilityWant fd:" + this.fd);
    Logger.info(TAG, "funcAbilityWant dlpContent:" + this.dlpContent);
    this.fd = fs.openSync(this.dlpLinkUri).fd;
    this.isDlpFileFunc(this.fd);
    this.getOriginalFileNameFunc(this.dlpName);
    this.getDLPSuffixFunc();
    Logger.info(TAG, "onPageShow end ------");
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .width('24vp')
          .height('24vp')
          .margin({ left: '24vp', right: '16vp', top: '16vp', bottom: '16vp' })
          .objectFit(ImageFit.Contain)
          .id('dlpPageBack')
          .onClick(() => {
            router.back();
          })
        Text(this.dlpName)
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
          TextArea({ text: this.dlpContent, placeholder: 'Input text here...', controller: this.controller })
            .width('372vp')
            .height('100vp')
            .fontSize('16vp')
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('app.color.font_color_182431'))
            .textAlign(TextAlign.Start)
            .fontWeight(500)
            .margin({ top: '10vp', bottom: '32vp', right: '8vp' })
            .id('dlpTextArea')
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
              this.dlpContent = value;
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
            .id('dlpEdit')
            .onClick(() => {
              this.editable = true;
              AppStorage.setOrCreate('editable', this.editable);
              Logger.info(TAG, 'EditFile caretPosition length = ' + this.dlpContent.length);
              this.controller.caretPosition(this.dlpContent.length);
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
            .id('dlpSave')
            .onClick(() => {
              Logger.info(TAG, 'save onClick dlpContent is: ' + this.dlpContent);
              Logger.info(TAG, 'save onClick this.myUri: ' + this.dlpLinkUri);
              this.mediaFileUri.writeFileContent(this.dlpLinkUri, this.dlpContent);
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
            .bindMenu(this.filePageMenu, { placement: Placement.TopRight, offset: { x: '52vp', y: '12vp' } })
            .id('dlpMore')
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
          this.callFilePickerSaveFile(this.dlpName);
        })

      MenuItem(this.filePageDivider)

      MenuItem(this.filePageTextMenu2)
        .width('124vp')
        .height('48vp')
        .margin({ left: '16vp', right: '16vp' })
        .onClick(() => {
          this.onEncrypt();
        })
        .enabled(true)

      MenuItem(this.filePageDivider)

      MenuItem(this.filePageTextMenu3)
        .width('124vp')
        .height('48vp')
        .margin({ left: '16vp', right: '16vp' })
        .onClick(() => {
          this.setSandboxFile();
        })
        .enabled(true)

      MenuItem(this.filePageDivider)

      MenuItem(this.filePageTextMenu4)
        .width('124vp')
        .height('48vp')
        .margin({ left: '16vp', right: '16vp' })
        .onClick(() => {
          this.cancelSandboxFile();
        })
        .enabled(true)

    }
    .width('156vp').height('202vp')
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
      .id('dlp_save_as')
  }

  @Builder
  filePageTextMenu2() {
    Text($r('app.string.set_permissions'))
      .width('122vp')
      .height('21vp')
      .fontSize('16vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(400)
      .fontColor($r('app.color.font_color_182431'))
      .align(Alignment.Start)
      .margin({ top: '13vp', bottom: '14vp', right: '2vp' })
      .id('dlp_set_permissions')
  }

  @Builder
  filePageTextMenu3() {
    Text($r('app.string.Set_retention_sandbox'))
      .width('122vp')
      .height('21vp')
      .fontSize('16vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(400)
      .fontColor($r('app.color.font_color_182431'))
      .align(Alignment.Start)
      .margin({ top: '13vp', bottom: '14vp', right: '2vp' })
      .id('set_retention_sandbox')
  }

  @Builder
  filePageTextMenu4() {
    Text($r('app.string.cancel_retention_sandbox'))
      .width('122vp')
      .height('21vp')
      .fontSize('16vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(400)
      .fontColor($r('app.color.font_color_182431'))
      .align(Alignment.Start)
      .margin({ top: '13vp', bottom: '14vp', right: '2vp' })
      .id('cancel_retention_sandbox')
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