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

// [Start parsingXML_import]
import { xml, util } from '@kit.ArkTS'; // 需要使用util模块函数对文本编码
// [End parsingXML_import]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [Start parsingXML_callback]
function func(name: string, value: string): boolean {
  if (name == 'note') {
    console.info(name);
  }
  if (value == 'Play' || value == 'Work') {
    console.info('    ' + value);
    // [StartExclude parsingXML_callback]
    if (globalLogUpdate) {
      globalLogUpdate(value, false);
    }
    // [EndExclude parsingXML_callback]
  }
  if (name == 'title' || name == 'lens') {
    console.info('  ' + name);
  }
  return true; // true:继续解析 false:停止解析
}
// [End parsingXML_callback]
function testParsingTagsAndValues() {
  // [Start parsingXML_xmlPullParser]
  let strXml: string =
    '<?xml version="1.0" encoding="utf-8"?>' +
      '<note importance="high" logged="true">' +
      '<title>Play</title>' +
      '<lens>Work</lens>' +
      '</note>';
  let textEncoder: util.TextEncoder = new util.TextEncoder();
  let arrBuffer: Uint8Array = textEncoder.encodeInto(strXml); // 对数据进行编码，防止中文字符乱码
  // 方式1：基于ArrayBuffer构造XmlPullParser对象
  let xmlParser: xml.XmlPullParser = new xml.XmlPullParser(arrBuffer.buffer as object as ArrayBuffer, 'UTF-8');
  // [End parsingXML_xmlPullParser]
  // [Start parsingXML_option]
  let options: xml.ParseOptions = {supportDoctype:true, ignoreNameSpace:true, tagValueCallbackFunction:func};
  xmlParser.parseXml(options);
  // [End parsingXML_option]
  testParsingTagsAndValuesMethodTwo();
}

function testParsingTagsAndValuesMethodTwo() {
  let strXml: string =
    '<?xml version="1.0" encoding="utf-8"?>' +
      '<note importance="high" logged="true">' +
      '<title>Play</title>' +
      '<lens>Work</lens>' +
      '</note>';
  let textEncoder: util.TextEncoder = new util.TextEncoder();
  let arrBuffer: Uint8Array = textEncoder.encodeInto(strXml); // 对数据进行编码，防止中文字符乱码
  // [Start parsingXML_xmlPullParser_method_two]
  // 方式2：基于DataView构造XmlPullParser对象
  let dataView: DataView = new DataView(arrBuffer.buffer as object as ArrayBuffer);
  let xmlParser: xml.XmlPullParser = new xml.XmlPullParser(dataView, 'UTF-8');
  // [End parsingXML_xmlPullParser_method_two]
  let options: xml.ParseOptions = {supportDoctype:true, ignoreNameSpace:true, tagValueCallbackFunction:func};
  xmlParser.parseXml(options);
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
          Text($r('app.string.test_parsing_tags_values')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testParsingTagsAndValues();
          this.currentState = $r('app.string.test_parsing_tags_values_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}