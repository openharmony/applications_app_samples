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

// [Start xmlChange_import]
import { convertxml } from '@kit.ArkTS';
// [End xmlChange_import]

let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testConvertXML() {
  // [Start xmlChange_option]
  let xml: string =
    '<?xml version="1.0" encoding="utf-8"?>' +
      '<note importance="high" logged="true">' +
      '    <title>Happy</title>' +
      '    <todo>Work</todo>' +
      '    <todo>Play</todo>' +
      '</note>';
  let options: convertxml.ConvertOptions = {
    // trim: false 转换后是否删除文本前后的空格，否
    // declarationKey: "_declaration" 转换后文件声明使用_declaration来标识
    // instructionKey: "_instruction" 转换后指令使用_instruction标识
    // attributesKey: "_attributes" 转换后属性使用_attributes标识
    // textKey: "_text" 转换后标签值使用_text标识
    // cdataKey: "_cdata" 转换后未解析数据使用_cdata标识
    // docTypeKey: "_doctype" 转换后文档类型使用_doctype标识
    // commentKey: "_comment" 转换后注释使用_comment标识
    // parentKey: "_parent" 转换后父类使用_parent标识
    // typeKey: "_type" 转换后元素类型使用_type标识
    // nameKey: "_name" 转换后标签名称使用_name标识
    // elementsKey: "_elements" 转换后元素使用_elements标识
    trim: false,
    declarationKey: '_declaration',
    instructionKey: '_instruction',
    attributesKey: '_attributes',
    textKey: '_text',
    cdataKey: '_cdata',
    doctypeKey: '_doctype',
    commentKey: '_comment',
    parentKey: '_parent',
    typeKey: '_type',
    nameKey: '_name',
    elementsKey: '_elements'
  }
  // [End xmlChange_option]
  // [Start xmlChange_console]
  let conv: convertxml.ConvertXML = new convertxml.ConvertXML();
  let result: object = conv.fastConvertToJSObject(xml, options);
  let strRes: string = JSON.stringify(result); // 将js对象转换为json字符串，用于显式输出
  console.info(strRes);
  // [End xmlChange_console]

  if (globalLogUpdate) {
    globalLogUpdate(strRes, false);
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
          Text($r('app.string.test_convert_xml')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testConvertXML();
          this.currentState = $r('app.string.test_convert_xml_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}