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
    '1.napiOpenHandleScope',
    '2.napiOpenEscapableHandleScope',
    '3.napiAddFinalizer'
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
                } else if (item === '1.napiOpenHandleScope') {
                  // [Start ark_napi_open_close_handle_scope]
                  // napi_open_handle_scope  napi_close_handle_scope
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API handleScopeTest: %{public}s',
                      testNapi.handleScopeTest());
                    hilog.info(0x0000, 'testTag', 'Test Node-API handleScope: %{public}s', testNapi.handleScope());
                    // [StartExclude ark_napi_open_close_handle_scope]
                    this.result = 'napiOpenHandleScopeSuccess';
                    // [EndExclude ark_napi_open_close_handle_scope]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API handleScopeTest errorCode: %{public}s, errorMessage: %{public}s', error.code,
                      error.message);
                    // [StartExclude ark_napi_open_close_handle_scope]
                    this.result = 'napiOpenHandleScopeFail';
                    // [EndExclude ark_napi_open_close_handle_scope]
                  }
                  // [End ark_napi_open_close_handle_scope]
                } else if (item === '2.napiOpenEscapableHandleScope') {
                  // [Start ark_napi_open_close_escapable_handle_scope]
                  // napi_open_escapable_handle_scope napi_close_escapable_handle_scope、napi_escape_handle
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API EscapableHandleScopeTest: %{public}s',
                      testNapi.escapableHandleScopeTest());
                    // [StartExclude ark_napi_open_close_escapable_handle_scope]
                    this.result = 'napiOpenEscapableHandleScopeSuccess';
                    // [EndExclude ark_napi_open_close_escapable_handle_scope]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API EscapableHandleScopeTest errorCode: %{public}s, errorMessage: %{public}s',
                      error.code,
                      error.message);
                    // [StartExclude ark_napi_open_close_escapable_handle_scope]
                    this.result = 'napiOpenEscapableHandleScopeFail';
                    // [EndExclude ark_napi_open_close_escapable_handle_scope]
                  }
                  // [End ark_napi_open_close_escapable_handle_scope]
                } else if (item === '3.napiAddFinalizer') {
                  // [Start ark_napi_create_delete_reference]
                  // napi_add_finalizer
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API createReference: %{public}s',
                      JSON.stringify(testNapi.createReference()));
                    hilog.info(0x0000, 'testTag', 'Test Node-API useReference: %{public}s',
                      JSON.stringify(testNapi.useReference()));
                    hilog.info(0x0000, 'testTag', 'Test Node-API deleteReference: %{public}s',
                      testNapi.deleteReference());
                    // [StartExclude ark_napi_create_delete_reference]
                    this.result = 'napiAddFinalizerSuccess';
                    // [EndExclude ark_napi_create_delete_reference]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API ReferenceTest errorCode: %{public}s, errorMessage: %{public}s', error.code,
                      error.message);
                    // [StartExclude ark_napi_create_delete_reference]
                    this.result = 'napiAddFinalizerFail';
                    // [EndExclude ark_napi_create_delete_reference]
                  }
                  // [End ark_napi_create_delete_reference]
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
