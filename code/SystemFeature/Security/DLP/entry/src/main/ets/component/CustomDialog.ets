/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import { DlpManager, TestDlpFileInfo } from '../feature/DlpManager';
import { MediaFileUri } from '../feature/FileManager';
import Logger from '../util/Logger';
import { getResourceString } from '../util/ResourceUtils';

let sourceUri: string = 'file://docs/storage/Users/currentUser';
let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

@CustomDialog
export struct CustomDialogExample {
  @State dlpManager: DlpManager = new DlpManager();
  @State mediaFileUri: MediaFileUri = new MediaFileUri();
  // dlp文件信息
  @StorageLink('dlpFileInfos') dlpFileInfos: Array<TestDlpFileInfo> = [];
  @Link currentPerssion: number;
  @Link currentSelectedFileUri: string;
  private controller: CustomDialogController = {} as CustomDialogController;

  // 弹窗函数
  promptPopup() {
    Logger.info(`promptPopup start`);
    try {
      promptAction.showToast({
        message: $r('app.string.authorization_reminder'),
        // 弹窗延迟时间
        duration: 2000
      });
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      Logger.error(`showToast args error code is ${code}, message is ${message}`);
    }
  }

  build() {
    Column() {
      Text($r('app.string.encryption_protection'))
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .width('100%')
        .textAlign(TextAlign.Start)
      Text($r('app.string.authorization_description'))
        .fontSize(18)
        .width('100%')
        .textAlign(TextAlign.Start)
      Column() {
        Row() {
          Text($r('app.string.user_access_rights')).fontSize(18)
          Select([
            { value: $r('app.string.read_only') }, { value: $r('app.string.edit_only') }])
            .selected(2)
            .value(getResourceString(context, $r('app.string.authorization_reminder')))
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .margin({ top: 20, bottom: 20, left: 6 })
            .onSelect((index: number) => {
              this.currentPerssion = index;
            })
        }.width('100%').justifyContent(FlexAlign.Start)

        Flex({ justifyContent: FlexAlign.SpaceAround }) {
          Button($r('app.string.cancel'))
            .onClick(() => {
              this.controller.close()
            }).backgroundColor(0xffffff)
            .fontColor(Color.Black)
          Button($r('app.string.confirm'))
            .onClick(async () => {
              if (this.currentPerssion === -1) {
                this.promptPopup();
              } else {
                let displayName: string = Date.now().toString() + '.txt.dlp';
                let ciphertextFd: number = await this.mediaFileUri.createFile(sourceUri, displayName);
                await this.dlpManager.genTestDlpFile(this.currentSelectedFileUri, ciphertextFd, displayName, this.currentPerssion, this.dlpFileInfos);
                await this.mediaFileUri.getAllFiles(context, this.dlpFileInfos);
                await this.mediaFileUri.getAllFiles(context, this.dlpFileInfos);
                let time: number = new Date().getTime();
                // 切换用户
                await this.dlpManager.AccountLogin(`lisi${time}`);
                this.controller.close();
              }
            })
            .backgroundColor(0xffffff)
            .fontColor(Color.Red)
        }.margin({ bottom: 10 })
      }
    }.width('100%')
    .height('40%')
    .padding(15)
  }
}