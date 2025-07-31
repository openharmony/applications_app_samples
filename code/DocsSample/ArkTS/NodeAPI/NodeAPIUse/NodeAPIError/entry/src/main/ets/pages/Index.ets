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
import testNapi, { MyObject } from 'libentry.so';

@Entry
@Component
struct Index {
  @State result: string = ''
  private items: string[] = [
    'Reset Result Message',
    '1.napiGetLastErrorInfo',
    '2.napiCreateTypeError',
    '3.napiCreateRangeError',
    '4.napiCreateErrorAndNapiThrow',
    '5.napiThrowError',
    '6.napiThrowTypeError',
    '7.napiThrowRangeError',
    '8.napiIsError',
    '9.napiGetAndClearLastException',
    '10.napiIsExceptionPending',
    '11.napiFatalError',
    '12.napiFatalException'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(20)
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
                } else if (item === '1.napiGetLastErrorInfo') {
                  // [Start ark_napi_get_last_error_info]
                  // napi_get_last_error_info
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_last_error_info: %{public}s',
                      testNapi.getLastErrorInfo('message'));
                    // [StartExclude ark_napi_get_last_error_info]
                    this.result = 'napiGetLastErrorInfoSuccess';
                    // [EndExclude ark_napi_get_last_error_info]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_get_last_error_info error: %{public}s', error);
                    // [StartExclude ark_napi_get_last_error_info]
                    this.result = 'napiGetLastErrorInfoFail';
                    // [EndExclude ark_napi_get_last_error_info]
                  }
                  // [End ark_napi_get_last_error_info]
                } else if (item === '2.napiCreateTypeError') {
                  // [Start ark_napi_create_type_error]
                  try {
                    // [StartExclude ark_napi_create_type_error]
                    this.result = 'napiCreateTypeErrorSuccess';
                    // [EndExclude ark_napi_create_type_error]
                    throw testNapi.createTypeError();
                  } catch (error) { // napi_create_type_error
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_create_type_error errorCode: %{public}s, errorMessage %{public}s', error.code,
                      error.message);
                    // [StartExclude ark_napi_create_type_error]
                    this.result = 'napiCreateTypeErrorFail';
                    // [EndExclude ark_napi_create_type_error]
                  }
                  // [End ark_napi_create_type_error]
                } else if (item === '3.napiCreateRangeError') {
                  // [Start ark_napi_create_range_error]
                  // napi_create_range_error
                  try {
                    // [StartExclude ark_napi_create_range_error]
                    this.result = 'napiCreateRangeErrorSuccess';
                    // [EndExclude ark_napi_create_range_error]
                    throw testNapi.createRangeError();
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_create_range_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    // [StartExclude ark_napi_create_range_error]
                    this.result = 'napiCreateRangeErrorFail';
                    // [EndExclude ark_napi_create_range_error]
                  }
                  // [End ark_napi_create_range_error]
                } else if (item === '4.napiCreateErrorAndNapiThrow') {
                  // [Start ark_napi_create_error]
                  // napi_create_error and napi_throw
                  try {
                    testNapi.napiThrow();
                    // [StartExclude ark_napi_create_error]
                    this.result = 'napiCreateErrorAndNapiThrowSuccess';
                    // [EndExclude ark_napi_create_error]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw errorCode: %{public}s, errorMessage: %{public}s',
                      error.code, error.message);
                    // [StartExclude ark_napi_create_error]
                    this.result = 'napiCreateErrorAndNapiThrowFail';
                    // [EndExclude ark_napi_create_error]
                  }
                  // [End ark_napi_create_error]
                } else if (item === '5.napiThrowError') {
                  // [Start ark_napi_throw_error]
                  // napi_throw_error
                  try {
                    testNapi.napiThrowErrorMessage();
                    // [StartExclude ark_napi_throw_error]
                    this.result = 'napiThrowErrorMessageSuccess';
                    // [EndExclude ark_napi_throw_error]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_error error code: %{public}s , message: %{public}s', error.code,
                      error.message);
                    // [StartExclude ark_napi_throw_error]
                    this.result = 'napiThrowErrorMessageFail';
                    // [EndExclude ark_napi_throw_error]
                  }
                  try {
                    testNapi.napiThrowError(5, 0);
                    // [StartExclude ark_napi_throw_error]
                    this.result = 'napiThrowErrorSuccess';
                    // [EndExclude ark_napi_throw_error]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_error errorCode: %{public}s , errorManager: %{public}s', error.code,
                      error.message);
                    // [StartExclude ark_napi_throw_error]
                    this.result = 'napiThrowErrorFail';
                    // [EndExclude ark_napi_throw_error]
                  }
                  // [End ark_napi_throw_error]
                } else if (item === '6.napiThrowTypeError') {
                  // [Start ark_napi_throw_type_error]
                  // napi_throw_type_error
                  try {
                    testNapi.throwTypeErrorMessage();
                    // [StartExclude ark_napi_throw_type_error]
                    this.result = 'throwTypeErrorMessageSuccess';
                    // [EndExclude ark_napi_throw_type_error]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_type_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    // [StartExclude ark_napi_throw_type_error]
                    this.result = 'throwTypeErrorMessageFail';
                    // [EndExclude ark_napi_throw_type_error]
                  }
                  try {
                    testNapi.throwTypeError('str');
                    // [StartExclude ark_napi_throw_type_error]
                    this.result = 'throwTypeErrorSuccess';
                    // [EndExclude ark_napi_throw_type_error]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_type_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    // [StartExclude ark_napi_throw_type_error]
                    this.result = 'throwTypeErrorFail';
                    // [EndExclude ark_napi_throw_type_error]
                  }
                  // [End ark_napi_throw_type_error]
                } else if (item === '7.napiThrowRangeError') {
                  // [Start ark_napi_throw_range_error]
                  // napi_throw_range_error
                  try {
                    testNapi.throwRangeErrorMessage();
                    // [StartExclude ark_napi_throw_range_error]
                    this.result = 'throwRangeErrorMessageSuccess';
                    // [EndExclude ark_napi_throw_range_error]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_range_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    // [StartExclude ark_napi_throw_range_error]
                    this.result = 'throwRangeErrorMessageFail';
                    // [EndExclude ark_napi_throw_range_error]
                  }

                  try {
                    testNapi.throwRangeError(1);
                    // [StartExclude ark_napi_throw_range_error]
                    this.result = 'throwRangeErrorSuccess';
                    // [EndExclude ark_napi_throw_range_error]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_range_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    // [StartExclude ark_napi_throw_range_error]
                    this.result = 'throwRangeErrorFail';
                    // [EndExclude ark_napi_throw_range_error]
                  }
                  // [End ark_napi_throw_range_error]
                } else if (item === '8.napiIsError') {
                  // [Start ark_napi_is_error]
                  // napi_is_error
                  try {
                    // [StartExclude ark_napi_is_error]
                    this.result = 'napiIsErrorSuccess';
                    // [EndExclude ark_napi_is_error]
                    throw new Error("throwing an error");
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_error error: %{public}s',
                      testNapi.napiIsError(error)
                        .toString());
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_error error: %{public}s',
                      testNapi.napiIsError(1)
                        .toString());
                    // [StartExclude ark_napi_is_error]
                    this.result = 'napiIsErrorFail';
                    // [EndExclude ark_napi_is_error]
                  }
                  // [End ark_napi_is_error]
                } else if (item === '9.napiGetAndClearLastException') {
                  // [Start ark_napi_get_and_clear_last_exception]
                  // napi_get_and_clear_last_exception
                  // 这里获取到最后一个未处理的异常
                  hilog.info(0x0000, 'testTag',
                    'Test Node-API napi_get_and_clear_last_exception, error.message: %{public}s',
                    testNapi.getAndClearLastException());
                  // [End ark_napi_get_and_clear_last_exception]
                  this.result = 'napiGetAndClearLastExceptionSuccess';
                } else if (item === '10.napiIsExceptionPending') {
                  // [Start ark_napi_is_exception_pending]
                  // napi_is_exception_pending
                  try {
                    let result = testNapi.isExceptionPending() as MyObject;
                    hilog.info(0x0000, 'testTag',
                      'Test Node-API napi_is_exception_pending, error.Code: %{public}s, error.message: %{public}s',
                      result.code, result.message);
                    // [StartExclude ark_napi_is_exception_pending]
                    this.result = 'napiIsExceptionPendingSuccess';
                    // [EndExclude ark_napi_is_exception_pending]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_exception_pending error');
                    // [StartExclude ark_napi_is_exception_pending]
                    this.result = 'napiIsExceptionPendingFail';
                    // [EndExclude ark_napi_is_exception_pending]
                  }
                  // [End ark_napi_is_exception_pending]
                } else if (item === '11.napiFatalError') {
                  // [Start ark_napi_fatal_error]
                  // napi_fatal_error 请注意，使用napi_fatal_error函数会导致应用进程直接终止，因此应该谨慎使用，仅在遇到无法恢复的严重错误时才应该调用该函数
                  // 模拟一个致命错误条件
                  try {
                    testNapi.fatalError();
                    // [StartExclude ark_napi_fatal_error]
                    this.result = 'napiFatalErrorSuccess';
                    // [EndExclude ark_napi_fatal_error]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_fatal_error error');
                    // [StartExclude ark_napi_fatal_error]
                    this.result = 'napiFatalErrorFail';
                    // [EndExclude ark_napi_fatal_error]
                  }
                  // [End ark_napi_fatal_error]
                } else if (item === '12.napiFatalException') {
                  // napi_fatal_exception 请注意，使用napi_fatal_error函数会导致应用进程直接终止，因此应该谨慎使用，仅在遇到无法恢复的严重错误时才应该调用该函数
                  // 模拟一个致命错误条件
                  try {
                    // [Start ark_napi_fatal_exception]
                    const err = new Error("a fatal exception occurred");
                    testNapi.fatalException(err);
                    // [End ark_napi_fatal_exception]
                    this.result = 'napiFatalExceptionSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_fatal_exception error');
                    this.result = 'napiFatalExceptionFail';
                  }
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
