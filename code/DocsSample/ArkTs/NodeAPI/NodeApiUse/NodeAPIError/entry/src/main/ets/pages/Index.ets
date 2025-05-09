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
                  // napi_get_last_error_info
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_last_error_info: %{public}s',
                      testNapi.getLastErrorInfo('message'));
                    this.result = 'napiGetLastErrorInfoSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_get_last_error_info error: %{public}s', error);
                    this.result = 'napiGetLastErrorInfoFail';
                  }
                } else if (item === '2.napiCreateTypeError') {
                  try {
                    this.result = 'napiCreateTypeErrorSuccess';
                    throw testNapi.creatTypeError();
                  } catch (error) { // napi_create_type_error
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_create_type_error errorCode: %{public}s, errorMessage %{public}s', error.code,
                      error.message);
                    this.result = 'napiCreateTypeErrorFail';
                  }
                } else if (item === '3.napiCreateRangeError') {
                  // napi_create_range_error
                  try {
                    this.result = 'napiCreateRangeErrorSuccess';
                    throw testNapi.creatRangeError();
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_create_range_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    this.result = 'napiCreateRangeErrorFail';
                  }
                } else if (item === '4.napiCreateErrorAndNapiThrow') {
                  // napi_create_error and napi_throw
                  try {
                    testNapi.napiThrow();
                    this.result = 'napiCreateErrorAndNapiThrowSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw errorCode: %{public}s, errorMessage: %{public}s',
                      error.code, error.message);
                    this.result = 'napiCreateErrorAndNapiThrowFail';
                  }
                } else if (item === '5.napiThrowError') {
                  // napi_throw_error
                  try {
                    testNapi.napiThrowErrorMessage();
                    this.result = 'napiThrowErrorMessageSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_error error code: %{public}s , message: %{public}s', error.code,
                      error.message);
                    this.result = 'napiThrowErrorMessageFail';
                  }
                  try {
                    testNapi.napiThrowError(5, 0);
                    this.result = 'napiThrowErrorSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_error errorCode: %{public}s , errorManager: %{public}s', error.code,
                      error.message);
                    this.result = 'napiThrowErrorFail';
                  }
                } else if (item === '6.napiThrowTypeError') {
                  // napi_throw_type_error
                  try {
                    testNapi.throwTypeErrorMessage();
                    this.result = 'throwTypeErrorMessageSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_type_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    this.result = 'throwTypeErrorMessageFail';
                  }
                  try {
                    testNapi.throwTypeError('str');
                    this.result = 'throwTypeErrorSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_type_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    this.result = 'throwTypeErrorFail';
                  }
                } else if (item === '7.napiThrowRangeError') {
                  // napi_throw_range_error
                  try {
                    testNapi.throwRangeErrorMessage();
                    this.result = 'throwRangeErrorMessageSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_range_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    this.result = 'throwRangeErrorMessageFail';
                  }

                  try {
                    testNapi.throwRangeError(1);
                    this.result = 'throwRangeErrorSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_throw_range_error errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    this.result = 'throwRangeErrorFail';
                  }
                } else if (item === '8.napiIsError') {
                  // napi_is_error
                  try {
                    this.result = 'napiIsErrorSuccess';
                    throw new Error("throwing an error");
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_error error: %{public}s',
                      testNapi.napiIsError(error)
                        .toString());
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_error error: %{public}s',
                      testNapi.napiIsError(1)
                        .toString());
                    this.result = 'napiIsErrorFail';
                  }
                } else if (item === '9.napiGetAndClearLastException') {
                  // napi_get_and_clear_last_exception
                  // 这里获取到最后一个未处理的异常
                  hilog.info(0x0000, 'testTag',
                    'Test Node-API napi_get_and_clear_last_exception, error.message: %{public}s',
                    testNapi.getAndClearLastException());
                  this.result = 'napiGetAndClearLastExceptionSuccess';
                } else if (item === '10.napiIsExceptionPending') {
                  // napi_is_exception_pending
                  try {
                    let result = testNapi.isExceptionPending() as MyObject;
                    hilog.info(0x0000, 'testTag',
                      'Test Node-API napi_is_exception_pending, error.Code: %{public}s, error.message: %{public}s',
                      result.code, result.message);
                    this.result = 'napiIsExceptionPendingSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_exception_pending error');
                    this.result = 'napiIsExceptionPendingFail';
                  }
                } else if (item === '11.napiFatalError') {
                  // napi_fatal_error 请注意，使用napi_fatal_error函数会导致应用进程直接终止，因此应该谨慎使用，仅在遇到无法恢复的严重错误时才应该调用该函数
                  // 模拟一个致命错误条件
                  try {
                    testNapi.fatalError();
                    this.result = 'napiFatalErrorSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_fatal_error error');
                    this.result = 'napiFatalErrorFail';
                  }
                } else if (item === '12.napiFatalException') {
                  // napi_fatal_exception 请注意，使用napi_fatal_error函数会导致应用进程直接终止，因此应该谨慎使用，仅在遇到无法恢复的严重错误时才应该调用该函数
                  // 模拟一个致命错误条件
                  try {
                    const err = new Error("a fatal exception occurred");
                    testNapi.fatalException(err);
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
