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
  @State copyText: string = '';
  @State text: string = '';
  controller: TextInputController = new TextInputController()
  copyController: TextInputController = new TextInputController()
  addLog(message: string): void {
    Log.showInfo(TAG, `pasteboard: ${message}`);
  }

  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
          Text($r('app.string.title'))
            .fontStyle(FontStyle.Normal)
            .fontSize(30)
            .textAlign(TextAlign.Start)
            .fontWeight(700)
            // .backgroundColor(Color.Red)

// Column() {}
        Text($r('app.string.text_input'))
          .fontStyle(FontStyle.Normal)
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .margin({top:12, bottom:12})

        // Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {

            // .fontWeight(700)

          TextInput({
            text: this.copyText,
            // placeholder: 'Please input your word...',
            controller: this.copyController
          })
            .placeholderFont({ size: 16, weight: 400 })
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: Color.Gray, radius: 16 })
            .width('100%') //336
            .height('40%') // 56
            .margin(0)
            .fontSize(16)
            .fontColor('#182431')
            .id('copyText')
            .onChange((value: string) => {
              this.copyText = value
            })

          Text($r('app.string.text_result'))
            .fontStyle(FontStyle.Normal)
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .margin({top:12, bottom:12})
            // .fontWeight(700)
          TextInput({
            text: this.text,
            // placeholder: 'Please paste your word...',
            controller: this.controller
          })
            .placeholderFont({ size: 16, weight: 400 })
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: Color.Gray, radius: 16 })
            .width('100%') //336
            .height('40%') // 56
            .margin(0)
            .fontSize(16)
            .fontColor('#182431')
            .id('pasteText')
            .onChange((value: string) => {
              this.text = value
            })
        }
        // .backgroundColor(Color.Gray)
        .width('100%')
        .height('60%')

        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceEvenly }) {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            // Row() {
            Button($r('app.string.Button_paste'))
              .backgroundColor('#007DFF')
              .fontSize(16)
              .fontColor('#007DFF')
              .backgroundColor($r('app.color.custom_button_color'))
              // .margin(15)
              .border({ radius: 20 })
              // .height('20%')
              .width('45%')
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

            Button($r('app.string.Button_text_paste'))
              .backgroundColor('#007DFF')
              // .margin(15)
              .border({ radius: 20 })
              .id('textPaste')
              .width('45%')
              // .height('20%')
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
            // }
            // .height('25%')//row
          }
          // .height('20%')
          .margin({left:12, right:12})

          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            PasteButton()
              // .backgroundColor('#007DFF')
              .width('45%')
              .fontSize(16)
              .fontColor('#007DFF')
              .backgroundColor($r('app.color.custom_button_color'))
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

            Button($r('app.string.Button_device_paste'))
              .backgroundColor('#007DFF')
              // .margin(15)
              .width('45%')
              .border({ radius: 20 })
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
          .margin({left:12, right:12})
          // .height('15%')

          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Button($r('app.string.Button_copy'))
              .fontColor('#007DFF')
              .backgroundColor($r('app.color.custom_button_color'))
              .margin({ left: 12, right: 12 })
              .border({ radius: 20 })
              .width('100%')
              .onClick(() => {
                // 复制文本框文本到剪贴板
                this.addLog('text content :' + this.text);
                let plainTextData = new unifiedDataChannel.UnifiedData();
                let plainText = new unifiedDataChannel.PlainText();
                plainText.details = {
                  Key: 'delayPlaintext',
                  Value: this.copyText,
                };
                plainText.textContent = this.copyText;
                plainText.abstract = 'delayTextContent';
                plainTextData.addRecord(plainText);

                let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
                systemPasteboard.setUnifiedData(plainTextData).then((data: void) => {
                  console.info('Succeeded in setting UnifiedData.');
                }).catch((err: BusinessError) => {
                  console.error('Failed to set UnifiedData. Cause: ' + err.message);
                });
              })
          }
        }
        // .backgroundColor(Color.Brown)
        .height('40%')
        .width('100%')
        }
      .margin({ left: 24, right: 24, top:24, bottom:24 })
      // .backgroundColor(Color.Green)
        .height('100%')
      // }
      // .height('100%')
      // .width('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}