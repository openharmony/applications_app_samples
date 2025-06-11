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
    '1.napiCreateBigintInt64',
    '2.napiCreateBigintUint64',
    '3.napiCreateBigintWords',
    '4.napiGetValueBigintInt64',
    '5.napiGetValueBigintUint64',
    '6.napiGetValueBigintWords'
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
                } else if (item === '1.napiCreateBigintInt64') {
                  // [Start ark_napi_create_bigint_int64]
                  // napi_create_bigint_int64
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_bigint_int64: %{public}d',
                    testNapi.createBigintInt64t());
                  // [End ark_napi_create_bigint_int64]
                  this.result = 'napiCreateBigintInt64Success';
                } else if (item === '2.napiCreateBigintUint64') {
                  // [Start ark_napi_create_bigint_uint64]
                  // napi_create_bigint_uint64
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_bigint_uint64: %{public}d',
                    testNapi.createBigintUint64t());
                  // [End ark_napi_create_bigint_uint64]
                  this.result = 'napiCreateBigintUint64Success';
                } else if (item === '3.napiCreateBigintWords') {
                  // [Start ark_napi_create_bigint_words]
                  // napi_create_bigint_words
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_bigint_words: %{public}d',
                      testNapi.createBigintWords());
                    // [StartExclude ark_napi_create_bigint_words]
                    this.result = 'napiCreateBigintWordsSuccess';
                    // [EndExclude ark_napi_create_bigint_words]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API NapiGetValueBigint: %{public}s', error.message);
                    // [StartExclude ark_napi_create_bigint_words]
                    this.result = 'napiCreateBigintWordsFail';
                    // [EndExclude ark_napi_create_bigint_words]
                  }
                  // [End ark_napi_create_bigint_words]
                } else if (item === '4.napiGetValueBigintInt64') {
                  // [Start ark_napi_get_value_bigint_int64]
                  // napi_get_value_bigint_int64
                  let bigInt = BigInt(-5555555555555555);
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_value_bigint_int64: %{public}s',
                      JSON.stringify(testNapi.getValueBigintInt64t(bigInt)));
                    // [StartExclude ark_napi_get_value_bigint_int64]
                    this.result = 'napiGetValueBigintInt64Success';
                    // [EndExclude ark_napi_get_value_bigint_int64]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API NapiGetValueBigint: %{public}s', error.message);
                    // [StartExclude ark_napi_get_value_bigint_int64]
                    this.result = 'napiGetValueBigintInt64Fail';
                    // [EndExclude ark_napi_get_value_bigint_int64]
                  }
                  // [End ark_napi_get_value_bigint_int64]
                } else if (item === '5.napiGetValueBigintUint64') {
                  // [Start ark_napi_get_value_bigint_uint64]
                  // napi_get_value_bigint_uint64
                  let bigUint = BigInt(5555555555555555);
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_value_bigint_uint64: %{public}s',
                      JSON.stringify(testNapi.getValueBigintUint64t(bigUint)));
                    // [StartExclude ark_napi_get_value_bigint_uint64]
                    this.result = 'napiGetValueBigintUint64Success';
                    // [EndExclude ark_napi_get_value_bigint_uint64]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API NapiGetValueBigint: %{public}s', error.message);
                    // [StartExclude ark_napi_get_value_bigint_uint64]
                    this.result = 'napiGetValueBigintUint64Fail';
                    // [EndExclude ark_napi_get_value_bigint_uint64]
                  }
                  // [End ark_napi_get_value_bigint_uint64]
                } else if (item === '6.napiGetValueBigintWords') {
                  // [Start ark_napi_get_value_bigint_words]
                  // napi_get_value_bigint_words
                  let bigInt = BigInt(-5555555555555555);
                  let bigUint = BigInt(5555555555555555);
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_value_bigint_words signBit is: %{public}d',
                      testNapi.getValueBigintWords(bigInt));
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_value_bigint_words signBit is: %{public}d',
                      testNapi.getValueBigintWords(bigUint));
                    // [StartExclude ark_napi_get_value_bigint_words]
                    this.result = 'napiGetValueBigintWordsSuccess';
                    // [EndExclude ark_napi_get_value_bigint_words]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API NapiGetValueBigint: %{public}s', error.message);
                    // [StartExclude ark_napi_get_value_bigint_words]
                    this.result = 'napiGetValueBigintWordsFail';
                    // [EndExclude ark_napi_get_value_bigint_words]
                  }
                  // [End ark_napi_get_value_bigint_words]
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