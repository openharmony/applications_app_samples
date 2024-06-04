/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { BusinessError } from '@ohos.base';
import pasteboard from '@ohos.pasteboard';
import unifiedDataChannel from '@ohos.data.unifiedDataChannel';
import uniformTypeDescriptor from '@ohos.data.uniformTypeDescriptor';
import Log from '../../common/Log'

const TAG: string = 'pasteboard->';
@Entry
@Component
struct Index {
  @State text: string = '';
  controller: TextInputController = new TextInputController()
  addLog(message: string): void {
    Log.showInfo(TAG, `pasteboard: ${message}`);
  }

  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
          TextInput({
            text: this.text,
            placeholder: 'Please input your word...',
            controller: this.controller
          })
            .placeholderFont({ size: 16, weight: 400 })
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: Color.Gray, radius: 18 })
            .width(436) //336
            .height(56) // 56
            .margin(20)
            .fontSize(16)
            .fontColor('#182431')
            .id('pasteText')
            .onChange((value: string) => {
              this.text = value
            })
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Button($r('app.string.Button_copy'))
              .backgroundColor('#007DFF')
              .margin(15)
              .onClick(() => {
                // 复制文本框文本到剪贴板
                this.addLog('text content :' + this.text);
                let plainTextData = new unifiedDataChannel.UnifiedData();
                let plainText = new unifiedDataChannel.PlainText();
                plainText.details = {
                    Key: 'delayPlaintext',
                    Value: this.text,
                };
                plainText.textContent = this.text;
                plainText.abstract = 'delayTextContent';
                plainTextData.addRecord(plainText);

                let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
                systemPasteboard.setUnifiedData(plainTextData).then((data: void) => {
                    console.info('Succeeded in setting UnifiedData.');
                }).catch((err: BusinessError) => {
                    console.error('Failed to set UnifiedData. Cause: ' + err.message);
                });
              })
            Button($r('app.string.Button_paste'))
              .backgroundColor('#007DFF')
              .margin(15)
              .onClick(() => {
                // 粘贴剪贴板内容到文本框
                let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
                systemPasteboard.getUnifiedData().then((data) => {
                  let records = data.getRecords();
                  this.addLog('Button_paste records.length: ' + records.length);
                  for (let j = 0; j < records.length; j++) {
                    if (records[j].getType() === uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
                      let text = records[j] as unifiedDataChannel.PlainText;
                      this.text = text.textContent;
                      this.addLog('Button_paste' + `${j + 1}.${text.textContent}`);
                    }
                  }
                }).catch((err: BusinessError) => {
                  this.addLog('Failed to get UnifiedData. Cause: ' + err.message);
                });
              })
          }
          .height('10%')

          PasteButton()
            .backgroundColor('#007DFF')
            .onClick((event: ClickEvent, result: PasteButtonOnClickResult) => {
              // 使用安全粘贴控件粘贴文本
              this.addLog('PasteButton onclick!')
              if (PasteButtonOnClickResult.SUCCESS === result) {
                pasteboard.getSystemPasteboard().getData((err: BusinessError, pasteData: pasteboard.PasteData) => {
                  if (err) {
                    this.addLog(`Failed to get paste data. Code is ${err.code}, message is ${err.message}`);
                    return;
                  }
                  this.text = pasteData.getPrimaryText();
                  this.addLog('PasteButton onclick getPrimaryText: ' + this.text)
                });
              }
            })

          Button($r('app.string.Button_text_paste'))
            .backgroundColor('#007DFF')
            .margin(15)
            .id('textPaste')
            .onClick(() => {
              // 粘贴类型过滤，仅粘贴文本
              let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
              let result: boolean = systemPasteboard.hasDataType(pasteboard.MIMETYPE_TEXT_PLAIN);
              if (result) {
                let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
                systemPasteboard.getUnifiedData().then((data) => {
                  let records = data.getRecords();
                  for (let j = 0; j < records.length; j++) {
                    if (records[j].getType() === uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
                      let text = records[j] as unifiedDataChannel.PlainText;
                      this.text = text.textContent;
                      this.addLog('Button_text_paste' + `${j + 1}.${text.textContent}`);
                    }
                  }
                }).catch((err: BusinessError) => {
                  this.addLog('Failed to get UnifiedData. Cause: ' + err.message);
                });
              } else {
                this.addLog('Check the PLAIN_TEXT DataType fail!')
              }
            })
          Button($r('app.string.Button_device_paste'))
            .backgroundColor('#007DFF')
            .margin(15)
            .onClick(() => {
              // 粘贴类型过滤，仅跨设备文本
              let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
              let result: boolean = systemPasteboard.isRemoteData();
              if (result) {
                let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
                systemPasteboard.getUnifiedData().then((data) => {
                  let records = data.getRecords();
                  for (let j = 0; j < records.length; j++) {
                    if (records[j].getType() === uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
                      let text = records[j] as unifiedDataChannel.PlainText;
                      this.text = text.textContent;
                      this.addLog('Button_device_paste' + `${j + 1}.${text.textContent}`);
                    }
                  }
                }).catch((err: BusinessError) => {
                  this.addLog('Failed to get UnifiedData. Cause: ' + err.message);
                });
              } else {
                this.addLog('Check isRemoteData DataType fail!');
              }
            })
        }
        .height('100%')
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}