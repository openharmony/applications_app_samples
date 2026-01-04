/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start xmlDySerializer_import]
import { xml, util } from '@kit.ArkTS';
// [End xmlDySerializer_import]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testCreateXmlByXmlDynamicSerializer() {
  // [Start xmlDySerializer_function]
  let dySerializer = new xml.XmlDynamicSerializer('utf-8');
  dySerializer.setDeclaration(); // 写入XML的声明
  dySerializer.startElement('bookstore'); // 写入元素开始标记
  dySerializer.startElement('book'); // 嵌套元素开始标记
  dySerializer.setAttributes('category', 'COOKING'); // 写入属性及其属性值
  dySerializer.startElement('title');
  dySerializer.setAttributes('lang', 'en');
  dySerializer.setText('Everyday'); // 写入标签值
  dySerializer.endElement(); // 写入结束标记
  dySerializer.startElement('author');
  dySerializer.setText('Giana');
  dySerializer.endElement();
  dySerializer.startElement('year');
  dySerializer.setText('2005');
  dySerializer.endElement();
  dySerializer.endElement();
  dySerializer.endElement();
  let arrayBuffer = dySerializer.getOutput();
  // [End xmlDySerializer_function]
  // [Start xmlDySerializer_console]
  let uint8Array: Uint8Array = new Uint8Array(arrayBuffer);
  let result: string = util.TextDecoder.create().decodeToString(uint8Array);
  console.info(result);
  // [End xmlDySerializer_console]
  if (globalLogUpdate) {
    globalLogUpdate(result, false);
  }
}

@Entry
@Component
struct IndexArkTs {
  @State currentState: string | ResourceStr = $r('app.string.uninitialized');
  @State logMessages: string | ResourceStr = $r('app.string.no_log_info');

  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }

  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Text($r('app.string.status_info_title'))
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.current_status'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.currentState)
              .fontSize(14)
              .fontColor('#007DFF')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.log_info'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.logMessages)
                .fontSize(12)
                .fontColor('#52C41A')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 10 })
        }
        .width('100%')
        .padding(18)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 16 })

        Column() {
          Text($r('app.string.test_xml_dynamic_serializer')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testCreateXmlByXmlDynamicSerializer();
          this.currentState = $r('app.string.test_xml_dynamic_serializer_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}