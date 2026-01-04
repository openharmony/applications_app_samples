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

// [Start xmlSerializer_import]
import { xml, util } from '@kit.ArkTS';
// [End xmlSerializer_import]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testCreateXmlByXmlSerializer() {
  // [Start xmlSerializer_new]
  let arrayBuffer: ArrayBuffer = new ArrayBuffer(2048); // 创建一个2048字节的缓冲区
  let serializer: xml.XmlSerializer = new xml.XmlSerializer(arrayBuffer); // 基于ArrayBuffer构造XmlSerializer对象
  // [End xmlSerializer_new]
  // [Start xmlSerializer_function]
  serializer.setDeclaration(); // 写入XML的声明
  serializer.startElement('bookstore'); // 写入元素开始标记
  serializer.startElement('book'); // 嵌套元素开始标记
  serializer.setAttributes('category', 'COOKING'); // 写入属性及其属性值
  serializer.startElement('title');
  serializer.setAttributes('lang', 'en');
  serializer.setText('Everyday'); // 写入标签值
  serializer.endElement(); // 写入结束标记
  serializer.startElement('author');
  serializer.setText('Giana');
  serializer.endElement();
  serializer.startElement('year');
  serializer.setText('2005');
  serializer.endElement();
  serializer.endElement();
  serializer.endElement();
  // [End xmlSerializer_function]
  // [Start xmlSerializer_console]
  let uint8Array: Uint8Array = new Uint8Array(arrayBuffer); // 使用Uint8Array读取arrayBuffer的数据
  let textDecoder: util.TextDecoder = util.TextDecoder.create(); // 调用util模块的TextDecoder类
  let result: string = textDecoder.decodeToString(uint8Array); // 对uint8Array解码
  console.info(result);
  // [End xmlSerializer_console]
  if (globalLogUpdate) {
    globalLogUpdate(result, false);
  }
}

function testDifferentMethod() {
  // [Start xmlSerializer_differentFunction]
  let arrayBuffer: ArrayBuffer = new ArrayBuffer(2048); // 创建一个2048字节的缓冲区
  let dataView: DataView = new DataView(arrayBuffer); // 创建一个DataView
  let serializer: xml.XmlSerializer = new xml.XmlSerializer(dataView); // 基于DataView构造XmlSerializer对象
  // [End xmlSerializer_differentFunction]
  serializer.setDeclaration(); // 写入XML的声明
  serializer.startElement('bookstore'); // 写入元素开始标记
  serializer.startElement('book'); // 嵌套元素开始标记
  serializer.setAttributes('category', 'COOKING'); // 写入属性及其属性值
  serializer.startElement('title');
  serializer.setAttributes('lang', 'en');
  serializer.setText('Everyday'); // 写入标签值
  serializer.endElement(); // 写入结束标记
  serializer.startElement('author');
  serializer.setText('Giana');
  serializer.endElement();
  serializer.startElement('year');
  serializer.setText('2005');
  serializer.endElement();
  serializer.endElement();
  serializer.endElement();
  let uint8Array: Uint8Array = new Uint8Array(arrayBuffer); // 使用Uint8Array读取arrayBuffer的数据
  let textDecoder: util.TextDecoder = util.TextDecoder.create(); // 调用util模块的TextDecoder类
  let result: string = textDecoder.decodeToString(uint8Array); // 对uint8Array解码
  console.info(result);
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
          .height(100)
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 10 })
        }
        .width('100%')
        .padding(18)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 16 })

        Column() {
          Text($r('app.string.test_xml_serializer')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testCreateXmlByXmlSerializer();
          this.currentState = $r('app.string.test_xml_serializer_complete');
        })

        Column() {
          Text($r('app.string.test_xml_serializer_method2')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testDifferentMethod();
          this.currentState = $r('app.string.test_xml_serializer_method2_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}