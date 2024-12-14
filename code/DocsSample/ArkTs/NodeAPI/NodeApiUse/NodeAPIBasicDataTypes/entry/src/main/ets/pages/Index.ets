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
    '1.napiGetValueUint32',
    '2.napiGetValueInt32',
    '3.napiGetValueInt64',
    '4.napiGetValueDouble',
    '5.napiCreateInt32',
    '6.napiCreateUint32',
    '7.napiCreateInt64',
    '8.napiCreateDouble'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
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
                } else if (item === '1.napiGetValueUint32') {
                  // napi_get_value_uint32
                  let value = testNapi.getValueUint32<number>(111111111111);
                  let data = testNapi.getValueUint32<string>("sssss");
                  hilog.info(0x0000, 'Node-API', 'get_value_uint32_number %{public}d', value);
                  // 传入非数字"sssss"时函数返回undefined
                  hilog.info(0x0000, 'Node-API', 'get_value_uint32_number %{public}s', data);
                  // 传入uint32范围内的数字100时函数返回原数字
                  hilog.info(0x0000, 'Node-API', 'get_value_uint32_number %{public}d',
                    testNapi.getValueUint32<number>(100));
                  this.result = 'napiGetValueUint32Success';
                } else if (item === '2.napiGetValueInt32') {
                  // napi_get_value_int32
                  // 传入非数字“ss”时函数返回undefined
                  hilog.info(0x0000, 'Node-API', 'get_value_int32_not_number %{public}s', testNapi.getValueInt32('ss'));
                  // 传入int32范围内的数字100时函数返回原数字
                  hilog.info(0x0000, 'Node-API', 'get_value_int32_number %{public}d', testNapi.getValueInt32(100));
                  // 传入68719476735，此数字的二进制为111111111111111111111111111111111111，在int32类型中此二进制代表数字-1
                  hilog.info(0x0000, 'Node-API', 'get_value_int32_oversize %{public}d',
                    testNapi.getValueInt32(68719476735));
                  // 大于2的31次-1的数字且不是二进制为111111111111111111111111111111111111这样的在int32中有特殊含义的数字也会溢出，导致数值发生改变，返回值按后32位二进制编码解码
                  hilog.info(0x0000, 'Node-API', 'get_value_int32_oversize %{public}d',
                    testNapi.getValueInt32(687194767355));
                  // 传入NAN（not a number）、+Infinity（正无穷）或-Infinity（负无穷），会返回数字0
                  hilog.info(0x0000, 'Node-API', 'get_value_int32_number_NAN %{public}d', testNapi.getValueInt32(NaN));
                  hilog.info(0x0000, 'Node-API', 'get_value_int32_number_+Infinity %{public}d',
                    testNapi.getValueInt32(+Infinity));
                  hilog.info(0x0000, 'Node-API', 'get_value_int32_number_-Infinity %{public}d',
                    testNapi.getValueInt32(-Infinity));
                  this.result = 'napiGetValueInt32Success';
                } else if (item === '3.napiGetValueInt64') {
                  // napi_get_value_int64
                  // 输入不超过int64表示范围的数字，会返回该数字
                  hilog.info(0x0000, 'Node-API', 'get_value_int64_number %{public}d', testNapi.getValueInt64(80));
                  // 传入非数字“ss”，获得函数返回的值应为undefined
                  hilog.info(0x0000, 'Node-API', 'get_value_int64_not_number %{public}s',
                    testNapi.getValueInt64('sAs'));
                  // 输入超过int64表示范围的数字会溢出，失去精度，导致输入数字与返回数字不相等
                  hilog.info(0x0000, 'Node-API', 'get_value_int64_number_oversize %{public}d',
                    testNapi.getValueInt64(9223372036854775809));
                  // 传入NAN（not a number）、+Infinity（正无穷）或-Infinity（负无穷）接口返回数字0
                  hilog.info(0x0000, 'Node-API', 'get_value_int64_number_NAN %{public}d', testNapi.getValueInt64(NaN));
                  hilog.info(0x0000, 'Node-API', 'get_value_int64_number_+Infinity %{public}d',
                    testNapi.getValueInt64(+Infinity));
                  hilog.info(0x0000, 'Node-API', 'get_value_int64_number_-Infinity %{public}d',
                    testNapi.getValueInt64(-Infinity));
                  this.result = 'napiGetValueInt64Success';
                } else if (item === '4.napiGetValueDouble') {
                  // napi_get_value_double
                  // 输入数字，返回该数字
                  hilog.info(0x0000, 'Node-API', 'get_value_double_number %{public}d', testNapi.getDouble(80.885));
                  // 传入非数字，获得函数返回的值应为undefined
                  hilog.info(0x0000, 'Node-API', 'get_value_double_not_number %{public}s', testNapi.getDouble('sAs'));
                  this.result = 'napiGetValueDoubleSuccess';
                } else if (item === '5.napiCreateInt32') {
                  // napi_create_int32
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_int32：' + testNapi.createInt32());
                  this.result = 'napiCreateInt32Success';
                } else if (item === '6.napiCreateUint32') {
                  // napi_create_uint32
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_uint32: ' + testNapi.createUInt32());
                  this.result = 'napiCreateUint32Success';
                } else if (item === '7.napiCreateInt64') {
                  // napi_create_int64
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_int64: ' + testNapi.createInt64());
                  this.result = 'napiCreateInt64Success';
                } else if (item === '8.napiCreateDouble') {
                  // napi_create_double
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_double: ' + testNapi.createDouble());
                  this.result = 'napiCreateDoubleSuccess';
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}
