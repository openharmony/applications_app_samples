/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State result: string = ''
  private items: string[] = [
    'Reset Result Message',
    '1.napiString'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 4 })
      List({ space: '10vp' }) {
        ForEach(this.items, (item: string) => {
          ListItem() {
            Text(item)
              .fontSize(16)
              .width('100%')
              .height(60)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)
              .borderRadius(30)
              .backgroundColor(Color.White)
              .onClick(() => {
                if (item === 'Reset Result Message') {
                  this.result = '';
                } else if (item === '1.napiString') {
                  // [Start ark_napi_get_value_string_utf8]
                  // 分别传入字符和非字符检测接口，传入字符串类型的数据将返回原字符串，传入其他类型返回undefined
                  hilog.info(0x0000, 'testTag', 'Test Node-API get_value_string_utf8_string %{public}s',
                    testNapi.getValueStringUtf8('aaBC+-$%^你好123'));
                  hilog.info(0x0000, 'testTag', 'Test Node-API get_value_string_utf8_not_string %{public}s',
                    testNapi.getValueStringUtf8(50));
                  // [End ark_napi_get_value_string_utf8]
                  // [Start ark_napi_create_string_utf8]
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_string_utf8:%{public}s',
                    testNapi.createStringUtf8());
                  // [End ark_napi_create_string_utf8]
                  // [Start ark_napi_get_value_string_utf16]
                  let result = testNapi.getValueStringUtf16('hello,');
                  hilog.info(0x0000, 'testTag', 'Node-API napi_get_value_string_utf16:%{public}s', result);
                  // [End ark_napi_get_value_string_utf16]
                  // [Start ark_napi_create_string_utf16]
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_string_utf16:%{public}s ',
                    testNapi.createStringUtf16());
                  // [End ark_napi_create_string_utf16]
                  // [Start ark_napi_get_value_string_latin1]
                  // 传入非字符型数据，函数返回undefined
                  hilog.info(0x0000, 'testTag', 'Test Node-API get_value_string_latin1_not_string %{public}s',
                    testNapi.getValueStringLatin1(10));
                  // ISO-8859-1编码不支持中文，传入中文字符会乱码
                  hilog.info(0x0000, 'testTag', 'Test Node-API get_value_string_latin1_string_chinese %{public}s',
                    testNapi.getValueStringLatin1('中文'));
                  // 传入其他字符，不会乱码
                  hilog.info(0x0000, 'testTag', 'Test Node-API get_value_string_latin1_string %{public}s',
                    testNapi.getValueStringLatin1('abo ABP=-&*/'));
                  // [End ark_napi_get_value_string_latin1]
                  // [Start ark_napi_create_string_latin1]
                  hilog.info(0x0000, 'testTag', 'Test Node-API  napi_create_string_latin1:%{public}s',
                    testNapi.createStringLatin1());
                  // End ark_napi_create_string_latin1]
                  this.result = 'napiStringSuccess';
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
    }.width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}