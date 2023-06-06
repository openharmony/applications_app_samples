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
export struct Decrypt {
  @State keyFileName: string = '请选择';
  @State keyFileUri: string = '';
  @State textFileUri: string = '';
  @State textFileName: string = '请选择';
  @State keyString: string = '';
  @State cipherText: string = '';
  @State plainText: string = '';
  @State message: string = '';
  @State decryptedFileUri: string = '';
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

              Text('请选择') {
                Span(this.textFileName)
                  .fontSize(14)
              }
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

              Text('请选择') {
                Span(this.keyFileName)
                  .fontSize(14)
              }
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
            this.selectAesKeyFileAndRead();
          })
        }
        .width('336')
        .height('100')
        .borderRadius(15)
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
            Text() {
              Span(this.cipherText)
                .fontSize(16)
                .fontWeight(400)
                .fontColor('#182431')
            }.textAlign(TextAlign.Start)
          }
          .padding({ left: 12, right: 12, bottom: 4 })
          .width('336')
          .height('48')
        }
        .borderRadius(15)
        .margin({ bottom: 12 })
        .width('336')
        .height('100')
        .backgroundColor(0xFFFFFF)

        Column() {
          Row() {
            Text($r('app.string.decrypted_context'))
              .fontSize(16)
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .lineHeight(22)
          }
          .padding({ left: 12, right: 12 })
          .width('336')
          .height('48')

          Row() {
            Text() {
              Span(this.plainText)
                .fontSize(16)
                .fontWeight(400)
                .fontColor('#182431')
            }.textAlign(TextAlign.Start)
          }
          .padding({ left: 12, right: 12, bottom: 4 })
          .width('336')
          .height('48')
        }
        .borderRadius(15)
        .margin({ bottom: 12 })
        .width('336')
        .height('100')
        .backgroundColor(0xFFFFFF)

        Column({}) {
          Button() {
            Text($r('app.string.decrypt')).fontSize(16).fontWeight(500)
              .lineHeight(22)
              .fontColor('#FFFFFF')
          }
          .id('decryptionBtn')
          .type(ButtonType.Capsule)
          .margin(8)
          .width('312')
          .height('40')
          .backgroundColor('#007DFF')
          .onClick(() => {
            if (this.textFileUri === '' || this.keyFileUri === '') {
              promptAction.showToast({
                message: 'message or key is null'
              });
            } else {
              this.decryptFunc();
            }
          });
        }.width('100%').height(208).justifyContent(FlexAlign.End)
      }
      .width('100%')
      .height('100%')
    }
  }

  async selectAesKeyFileAndRead() {
    let config = {
      action: 'ohos.want.action.OPEN_FILE',
      parameters: {
        startMode: 'choose',
      }
    }
    let context = getContext(this) as common.UIAbilityContext;
    let result = await context.startAbilityForResult(config);
    if (result.resultCode !== 0) {
      Logger.error(TAG, `DocumentPicker.select failed, code is ${result.resultCode}, message is ${result.want.parameters.message}`);
      return;
    }
    // 获取到文档文件的URI
    this.keyFileUri = result.want.parameters.select_item_list.toString();
    // 获取到文档文件的文件名称
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
    if (result.resultCode !== 0) {
      Logger.error(TAG, `DocumentPicker.select failed, code is ${result.resultCode}, message is ${result.want.parameters.message}`);
      return;
    }
    // 获取到文档文件的URI
    this.textFileUri = result.want.parameters.select_item_list.toString();
    // 获取到文档文件的文件名称
    this.textFileName = result.want.parameters.file_name_list.toString();
    await TextFileManager.readTextFile(this.textFileUri);
    this.cipherText = TextFileManager.getString();
  }

  async createTextFileAndWrite() {
    let DocumentSaveOptions = new picker.DocumentSaveOptions();
    DocumentSaveOptions.newFileNames = ['plainText.txt'];
    let documentPicker = new picker.DocumentViewPicker();
    let DocumentSaveResult = await documentPicker.save(DocumentSaveOptions);
    this.decryptedFileUri = DocumentSaveResult[0];
    await TextFileManager.writeTextFile(this.decryptedFileUri, this.plainText);
  }

  async decryptFunc() {
    if (this.cipherText === '' || this.keyFileUri === '') {
      promptAction.showToast({
        message: 'message or key is null'
      });
      return;
    }
    try {
      this.plainText = await this.CryptoOperation.aesConvertAndDecrypt(this.keyString, this.cipherText);
    } catch(error) {
      Logger.error(TAG, `decrypt failed, ${error.code}, ${error.message}`);
      return;
    }
    if (this.plainText === '' || typeof(this.plainText) == 'undefined') {
      promptAction.showToast({
        message: 'decrypt failed'
      });
      return;
    } else {
      try {
        await this.createTextFileAndWrite();
      } catch(error) {
        Logger.error(TAG, `decrypt failed, ${error.code}, ${error.message}`);
      }
    }
    if (this.decryptedFileUri === '' || typeof (this.decryptedFileUri) == 'undefined') {
      promptAction.showToast({
        message: '解密失败'
      });
    } else {
      promptAction.showToast({
        message: '解密成功并保存'
      });
    }
  }
}