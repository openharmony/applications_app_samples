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
const WAIT_CHOSEN: string = '请选择'

@Component
export struct Encrypt {
  @State keyFileName: string = WAIT_CHOSEN;
  @State keyFileUri: string = '';
  @State textFileUri: string = '';
  @State textFileName: string = WAIT_CHOSEN;
  @State keyString: string = '';
  @State cipherText: string = '';
  @State plainText: string = '';
  @State message: string = '';
  @State createKeyUri: string = '';
  @State encryptedFileUri: string = '';
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

              Text(this.textFileName)
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

              Text(this.keyFileName)
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

        Column() {
          Row() {
            Text($r('app.string.encrypted_context'))
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
          Button() {
            Text($r('app.string.generate_aes_key_randomly')).fontSize(16).fontWeight(500)
              .lineHeight(22)
              .fontColor('#FFFFFF')
          }
          .id('encryptAesGenKey')
          .type(ButtonType.Capsule)
          .margin(8)
          .width('312')
          .height('40')
          .backgroundColor('#007DFF')
          .onClick(() => {
            this.genAesKey();
          });
          Button() {
            Text($r('app.string.encrypt')).fontSize(16).fontWeight(500)
              .lineHeight(22)
              .fontColor('#FFFFFF')
          }
          .id('encryptionBtn')
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
              this.encryptFunc();
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
    this.plainText = TextFileManager.getString();
  }

  async createTextFileAndWrite() {
    let DocumentSaveOptions = new picker.DocumentSaveOptions();
    DocumentSaveOptions.newFileNames = ['cipherText.txt'];
    let documentPicker = new picker.DocumentViewPicker();
    let DocumentSaveResult = await documentPicker.save(DocumentSaveOptions);
    this.encryptedFileUri = DocumentSaveResult[0];
    await TextFileManager.writeTextFile(this.encryptedFileUri, this.cipherText);
  }

  async createKeyFileAndWrite() {
    let DocumentSaveOptions = new picker.DocumentSaveOptions();
    DocumentSaveOptions.newFileNames = ['aesKey.txt'];
    let documentPicker = new picker.DocumentViewPicker();
    let DocumentSaveResult = await documentPicker.save(DocumentSaveOptions);
    this.createKeyUri = DocumentSaveResult[0];
    await TextFileManager.writeTextFile(this.createKeyUri, this.keyString);
  }

  async createShortFileAndWrite() {
    let DocumentSaveOptions = new picker.DocumentSaveOptions();
    DocumentSaveOptions.newFileNames = ['textShort.txt'];
    let documentPicker = new picker.DocumentViewPicker();
    let DocumentSaveResult = await documentPicker.save(DocumentSaveOptions);
    let uri = DocumentSaveResult[0];
    let short = 'hello world'
    await TextFileManager.writeTextFile(uri, short);
  }

  async createMidFileAndWrite() {
    let DocumentSaveOptions = new picker.DocumentSaveOptions();
    DocumentSaveOptions.newFileNames = ['textMid.txt'];
    let documentPicker = new picker.DocumentViewPicker();
    let DocumentSaveResult = await documentPicker.save(DocumentSaveOptions);
    let uri = DocumentSaveResult[0];
    let mid = 'hello world'
    await TextFileManager.writeTextFile(uri, mid);
  }

  async createChFileAndWrite() {
    let DocumentSaveOptions = new picker.DocumentSaveOptions();
    DocumentSaveOptions.newFileNames = ['中文.txt'];
    let documentPicker = new picker.DocumentViewPicker();
    let DocumentSaveResult = await documentPicker.save(DocumentSaveOptions);
    let uri = DocumentSaveResult[0];
    let mid = '0x9f255d8bf9e15ca86fa3f1620c4b78c44466e6e1e1f7299c0fd7d1405746151a1b93eaf28d13b6223ec6982ef547d283976a2e6043b2fe8b7ef73632ce2749b50x9f255d8bf9e15ca86fa3f1620c4b78c44466e6e1e1f7299c0fd7d1405746151a1b93eaf28d13b6223ec6982ef547d283976a2e6043b2fe8b7ef73632ce2749b5'
    await TextFileManager.writeTextFile(uri, mid);
  }

  async createLongFileAndWrite() {
    let DocumentSaveOptions = new picker.DocumentSaveOptions();
    DocumentSaveOptions.newFileNames = ['textLong.txt'];
    let documentPicker = new picker.DocumentViewPicker();
    let DocumentSaveResult = await documentPicker.save(DocumentSaveOptions);
    let uri = DocumentSaveResult[0];
    let long = '0x9260d0750ae117eee55c3f3deaba74917521a262ee76007cdf8a56755ad73a1598a1408410a01434c3f5bc54a88b57fa19fc4328daea0750a4c44e88cff3b2382621b80f670464433e4336e6d003e8cd65bff211da144b88291c2259a00a72b711c116ef7686e8fee34e4d933c868187bdc26f7be071493c86f7a5941c3510806ad67b0f94d88f5cf5c02a092821d8626e8932b65c5bd8c92049c210932b7afa7ac59c0e886ae5c1edb00d8ce2c57633db26bd6639bff73cee82be9275c402b4cf2a4388da8cf8c64eefe1c5a0f5ab8057c39fa5c0589c3e253f0960332300f94bea44877b588e1edbde97cf2360727a09b775262d7ee552b3319b9266f05a250x9260d0750ae117eee55c3f3deaba74917521a262ee76007cdf8a56755ad73a1598a1408410a01434c3f5bc54a88b57fa19fc4328daea0750a4c44e88cff3b2382621b80f670464433e4336e6d003e8cd65bff211da144b88291c2259a00a72b711c116ef7686e8fee34e4d933c868187bdc26f7be071493c86f7a5941c3510806ad67b0f94d88f5cf5c02a092821d8626e8932b65c5bd8c92049c210932b7afa7ac59c0e886ae5c1edb00d8ce2c57633db26bd6639bff73cee82be9275c402b4cf2a4388da8cf8c64eefe1c5a0f5ab8057c39fa5c0589c3e253f0960332300f94bea44877b588e1edbde97cf2360727a09b775262d7ee552b3319b9266f05a25'
    await TextFileManager.writeTextFile(uri, long);
  }

  async encryptFunc() {
    if (this.plainText === '' || this.keyFileUri === '') {
      promptAction.showToast({
        message: 'message or key is null'
      });
      return;
    }
    try {
      this.cipherText = await this.CryptoOperation.aesConvertAndEncrypt(this.keyString, this.plainText);
    } catch (error) {
      Logger.error(TAG, `encrypt failed, ${error.code}, ${error.message}`);
    }
    if (this.cipherText === '' || typeof (this.cipherText) == 'undefined') {
      promptAction.showToast({
        message: 'encrypt failed'
      });
      return;
    } else {
      try {
        await this.createTextFileAndWrite();
      } catch (error) {
        Logger.error(TAG, `encrypt failed, ${error.code}, ${error.message}`);
      }
    }
    if (this.encryptedFileUri === '' || typeof (this.encryptedFileUri) == 'undefined') {
      promptAction.showToast({
        message: '加密失败'
      });
    } else {
      promptAction.showToast({
        message: '加密成功并保存'
      });
    }
  }

  async genAesKey() {
    try {
      this.keyString = await this.CryptoOperation.generateAesKey();
    } catch (error) {
      Logger.error(TAG, `gen aes key failed, ${error.code}, ${error.message}`);
    }
    if (this.keyString === '' || typeof (this.keyString) == 'undefined') {
      promptAction.showToast({
        message: 'gen aes key failed'
      });
      return;
    } else {
      try {
        await this.createKeyFileAndWrite();
      } catch (error) {
        Logger.error(TAG, `write aes key failed, ${error.code}, ${error.message}`);
      }
    }
    if (this.createKeyUri === '' || typeof (this.createKeyUri) == 'undefined') {
      promptAction.showToast({
        message: 'create aes key file failed'
      });
    } else {
      promptAction.showToast({
        message: '已生成AES密钥'
      });
    }
  }
}

