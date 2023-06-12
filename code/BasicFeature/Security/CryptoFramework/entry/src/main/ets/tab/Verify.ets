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

import promptAction from '@ohos.promptAction';
import Logger from '../util/Logger';
import picker from '@ohos.file.picker';
import { CryptoOperation } from '../cryptoframework/CryptoOperation';
import TextFileManager from '../textfilemanager/TextFileManager';
import common from '@ohos.app.ability.common';

const TAG: string = '[Crypto_Framework]';

@Component
export struct Verify {
  @State keyFileName: string = '';
  @State keyFileUri: string = '';
  @State textFileUri: string = '';
  @State textFileName: string = '';
  @State keyString: string = '';
  @State plainText: string = '';
  @State message: string = '';
  @State signFileUri: string = '';
  @State signFileName: string = '';
  @State signText: string = '';
  @State createKeyUri: string = '';
  private CryptoOperation: CryptoOperation = new CryptoOperation();

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        List() {
          ListItem() {
            Row() {
              Text($r('app.string.open_file'))
                .fontSize(16)
                .textAlign(TextAlign.Start)
                .lineHeight(22)

              Blank()

              Text(this.textFileName === '' ? $r('app.string.please_choose') : this.textFileName)
                .fontSize(14)
                .textAlign(TextAlign.Start)
                .lineHeight(19)

              Image($r('app.media.right_arrow'))
                .height(24)
                .width(24)
                .padding({ left: 9, right: 9, top: 6, bottom: 6 })
            }
            .backgroundColor(0xFFFFFF)
            .width('336')
            .height('48')
            .padding({ top: 4, left: 12, right: 12 })
          }.onClick(() => {
            this.selectTextFileAndRead();
          })

          ListItem() {
            Row() {
              Text($r('app.string.select_key_file'))
                .fontSize(16)
                .textAlign(TextAlign.Start)
                .lineHeight(22)

              Blank()

              Text(this.keyFileName === '' ? $r('app.string.please_choose') : this.keyFileName)
                .fontSize(14)
                .textAlign(TextAlign.Start)
                .lineHeight(19)

              Image($r('app.media.right_arrow'))
                .height(24)
                .width(24)
                .padding({ left: 9, right: 9, top: 6, bottom: 6 })
            }
            .backgroundColor(0xFFFFFF)
            .width('336')
            .height('48')
            .padding({ left: 12, right: 12 })
          }.onClick(() => {
            this.selectRsaKeyFileAndRead();
          })
        }
        .width('336')
        .height('100')
        .borderRadius(16)
        .margin({ bottom: 12 })

        List() {
          ListItem() {
            Row() {
              Text($r('app.string.select_signature_file'))
                .fontSize(16)
                .textAlign(TextAlign.Start)
                .lineHeight(22)

              Blank()

              Text(this.signFileName === '' ? $r('app.string.please_choose') : this.signFileName)
                .fontSize(14)
                .textAlign(TextAlign.Start)
                .lineHeight(19)

              Image($r('app.media.right_arrow'))
                .height(24)
                .width(24)
                .padding({ left: 9, right: 9, top: 6, bottom: 6 })
            }
            .backgroundColor(0xFFFFFF)
            .width('336')
            .height('48')
            .padding({ left: 12, right: 12, top: 4, bottom: 4 })
          }.onClick(() => {
            this.selectSignFileAndRead();
          })
        }
        .width('336')
        .height('56')
        .borderRadius(16)
        .margin({ bottom: 12 })

        Column() {
          Row() {
            Text($r('app.string.text_context'))
              .fontSize(16)
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .lineHeight(22)
          }
          .padding({ left: 12, right: 12 })
          .width('336')
          .height('48')

          Row() {
            Text(this.plainText)
              .fontSize(16)
              .fontWeight(400)
              .fontColor('#182431')
              .textAlign(TextAlign.Start)
          }
          .padding({ left: 12, right: 12, bottom: 4 })
          .width('336')
          .height('48')
        }
        .borderRadius(16)
        .margin({ bottom: 12 })
        .width('336')
        .height('100')
        .backgroundColor(0xFFFFFF)

        Column() {
          Button() {
            Text($r('app.string.verify')).fontSize(16).fontWeight(500)
              .lineHeight(22)
              .fontColor('#FFFFFF')
          }
          .borderRadius(20)
          .id('verifyBtn')
          .type(ButtonType.Capsule)
          .margin(8)
          .width('312')
          .height('40')
          .backgroundColor('#007DFF')
          .onClick(() => {
            if (this.textFileUri === '' || this.keyFileUri === '' || this.signFileUri === '') {
              promptAction.showToast({
                message: $r('app.string.null_message')
              });
            } else {
              this.verifyFunc();
            }
          });
        }.width('100%').height(248).justifyContent(FlexAlign.End)
      }
      .width('100%')
      .height('100%')
    }
  }

  async selectRsaKeyFileAndRead() {
    let config = {
      action: 'ohos.want.action.OPEN_FILE',
      parameters: {
        startMode: 'choose',
      }
    }
    let context = getContext(this) as common.UIAbilityContext;
    let result = await context.startAbilityForResult(config);
    if (result === null || result === undefined) {
      Logger.error(TAG, `result is null or undefined!`);
      return;
    }
    if (result.resultCode !== 0) {
      Logger.error(TAG, `DocumentPicker.select failed, code is ${result.resultCode}, message is ${result.want.parameters.message}`);
      return;
    }
    if (result.want.parameters.select_item_list === null || result.want.parameters.select_item_list === undefined) {
      Logger.error(TAG, `result uri is null or undefined!`);
      return;
    }
    if (result.want.parameters.file_name_list === null || result.want.parameters.file_name_list === undefined) {
      Logger.error(TAG, `result file name is null or undefined!`);
      return;
    }
    // 获取到密钥文档文件的URI
    this.keyFileUri = result.want.parameters.select_item_list.toString();
    // 获取到密钥文档文件的文件名称
    this.keyFileName = result.want.parameters.file_name_list.toString();
    await TextFileManager.readTextFile(this.keyFileUri);
    this.keyString = TextFileManager.getString();
  }

  async selectTextFileAndRead() {
    let config = {
      action: 'ohos.want.action.OPEN_FILE',
      parameters: {
        startMode: 'choose',
      }
    }
    let context = getContext(this) as common.UIAbilityContext;
    let result = await context.startAbilityForResult(config);
    if (result === null || result === undefined) {
      Logger.error(TAG, `result is null or undefined!`);
      return;
    }
    if (result.resultCode !== 0) {
      Logger.error(TAG, `DocumentPicker.select failed, code is ${result.resultCode}, message is ${result.want.parameters.message}`);
      return;
    }
    if (result.want.parameters.select_item_list === null || result.want.parameters.select_item_list === undefined) {
      Logger.error(TAG, `result uri is null or undefined!`);
      return;
    }
    if (result.want.parameters.file_name_list === null || result.want.parameters.file_name_list === undefined) {
      Logger.error(TAG, `result file name is null or undefined!`);
      return;
    }
    // 获取到文档文件的URI
    this.textFileUri = result.want.parameters.select_item_list.toString();
    // 获取到文档文件的文件名称
    this.textFileName = result.want.parameters.file_name_list.toString();
    await TextFileManager.readTextFile(this.textFileUri);
    this.plainText = TextFileManager.getString();
  }

  async selectSignFileAndRead() {
    let config = {
      action: 'ohos.want.action.OPEN_FILE',
      parameters: {
        startMode: 'choose',
      }
    }
    let context = getContext(this) as common.UIAbilityContext;
    let result = await context.startAbilityForResult(config);
    if (result === null || result === undefined) {
      Logger.error(TAG, `result is null or undefined!`);
      return;
    }
    if (result.resultCode !== 0) {
      Logger.error(TAG, `DocumentPicker.select failed, code is ${result.resultCode}, message is ${result.want.parameters.message}`);
      return;
    }
    if (result.want.parameters.select_item_list === null || result.want.parameters.select_item_list === undefined) {
      Logger.error(TAG, `result uri is null or undefined!`);
      return;
    }
    if (result.want.parameters.file_name_list === null || result.want.parameters.file_name_list === undefined) {
      Logger.error(TAG, `result file name is null or undefined!`);
      return;
    }
    // 获取到文档文件的URI
    this.signFileUri = result.want.parameters.select_item_list.toString();
    // 获取到文档文件的文件名称
    this.signFileName = result.want.parameters.file_name_list.toString();
    await TextFileManager.readTextFile(this.signFileUri);
    this.signText = TextFileManager.getString();
  }

  async createKeyFileAndWrite() {
    let documentSaveOptions = new picker.DocumentSaveOptions();
    documentSaveOptions.newFileNames = ['rsaKey.txt'];
    let documentPicker = new picker.DocumentViewPicker();
    try {
      let documentSaveResult = await documentPicker.save(documentSaveOptions);
      this.createKeyUri = documentSaveResult[0];
      await TextFileManager.writeTextFile(this.createKeyUri, this.keyString);
    } catch (error) {
      Logger.error(TAG, `save key failed, ${error.code}, ${error.message}`);
    }

  }

  async verifyFunc() {
    let verifyRes;
    if (this.plainText === '' || this.keyFileUri === '' || this.signText === '') {
      promptAction.showToast({
        message: $r('app.string.null_message')
      });
      return;
    }
    try {
      verifyRes = await this.CryptoOperation.rsaConvertAndVerify(this.keyString, this.plainText, this.signText);
    } catch (error) {
      Logger.error(TAG, `verify failed, ${error.code}, ${error.message}`);
    }
    if (verifyRes != true) {
      promptAction.showToast({
        message: $r('app.string.verify_fail')
      });
      return;
    } else {
      promptAction.showToast({
        message: $r('app.string.verify_success')
      });
    }
  }
}