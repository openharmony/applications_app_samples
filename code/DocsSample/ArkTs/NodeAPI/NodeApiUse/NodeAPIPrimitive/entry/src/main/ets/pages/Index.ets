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
    '1.napiCoerceToBool',
    '2.napiCoerceToNumber',
    '3.napiCoerceToObject',
    '4.napiCoerceToString',
    '5.napiGetBoolean',
    '6.napiGetValueBool',
    '7.napiGetGlobal',
    '8.napiGetNull',
    '9.napiGetUndefined'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 3 })
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
                } else if (item === '1.napiCoerceToBool') {
                  // napi_coerce_to_bool
                  let value = testNapi.coerceToBool<number>(0);
                  let str = testNapi.coerceToBool<string>('111111111');
                  let obj = new Object();
                  let res = testNapi.coerceToBool<Object>(obj);
                  let result = testNapi.coerceToBool<null>(null);
                  // false
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_bool:%{public}s', value);
                  // true
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_bool:%{public}s', str);
                  // true
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_bool:%{public}s', res);
                  // false
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_bool:%{public}s', result);
                  this.result = 'napiCoerceToBoolSuccess';
                } else if (item === '2.napiCoerceToNumber') {
                  // napi_coerce_to_number
                  let value = testNapi.coerceToNumber<string>('2556');
                  let str = testNapi.coerceToNumber<string>('sssss');
                  let bool = testNapi.coerceToNumber<boolean>(true);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_number:%{public}d', value);
                  // 返回的为NAN
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_number:%{public}d', str);
                  // 返回的是1
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_number:%{public}d', bool);
                  this.result = 'napiCoerceToNumberSuccess';
                } else if (item === '3.napiCoerceToObject') {
                  // napi_coerce_to_object
                  let value = testNapi.coerceToObject<string>('222222');
                  let result = testNapi.coerceToObject<number>(111);
                  hilog.info(0x0000, 'testTag', 'Node-API coerceToObject:%{public}s.', typeof result);
                  if (typeof value === 'object') {
                    hilog.info(0x0000, 'testTag', 'Node-API The value is an object.');
                  } else {
                    hilog.info(0x0000, 'testTag', 'Node-API The value is not an object.');
                  }
                  this.result = 'napiCoerceToObjectSuccess';
                } else if (item === '4.napiCoerceToString') {
                  // napi_coerce_to_string
                  let value = testNapi.coerceToString<number>(212);
                  let obj = new Object();
                  let res = testNapi.coerceToString<Object>(obj);
                  let bool = testNapi.coerceToString<boolean>(false);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_string:%{public}s', value);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_string:%{public}s', typeof res);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_coerce_to_string:%{public}s', bool);
                  this.result = 'napiCoerceToStringSuccess';
                } else if (item === '5.napiGetBoolean') {
                  // napi_get_boolean
                  let value = testNapi.getBoolean<number>(1, '1');
                  let data = testNapi.getBoolean<string>('sss', '1');
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_boolean:%{public}s', value);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_boolean:%{public}s', data);
                  this.result = 'napiGetBooleanSuccess';
                } else if (item === '6.napiGetValueBool') {
                  // napi_get_value_bool
                  //         // 分别传入布尔值和非布尔值检测接口,传入布尔值将返回原布尔值,传入其他类型返回undefined
                  hilog.info(0x0000, 'Node-API', 'get_value_bool_not_bool %{public}s',
                    testNapi.getValueBool('你好123'));
                  hilog.info(0x0000, 'Node-API', 'get_value_bool_true %{public}s', testNapi.getValueBool(true));
                  hilog.info(0x0000, 'Node-API', 'get_value_bool_false %{public}s', testNapi.getValueBool(false));
                  this.result = 'napiGetValueBoolSuccess';
                } else if (item === '7.napiGetGlobal') {
                  // napi_get_global
                  let globalObj = testNapi.getGlobal();
                  // 判断获取的global是否具有global的自身属性
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_global:%{public}s',
                    globalObj.hasOwnProperty!("undefined"));
                  this.result = 'napiGetGlobalSuccess';
                } else if (item === '8.napiGetNull') {
                  // napi_get_null
                  let value = testNapi.getNull();
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_null:%{public}s', value);
                  this.result = 'napiGetNullSuccess';
                } else if (item === '9.napiGetUndefined') {
                  // napi_get_undefined
                  let data: undefined = undefined;
                  let value = testNapi.getUndefined(data);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_undefined:%{public}s', value);
                  this.result = 'napiGetUndefinedSuccess';
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