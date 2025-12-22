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

// [Start dynamic_focus_blur]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_FocusAndBlurExample]';
const DOMAIN = 0xF811;
const BUNDLE = 'MyApp_FocusAndBlurExample';

@Entry
@Component
export struct FocusAndBlurExample {
  build() {
    NavDestination() {
      Column() {
        Column({ space: 5 }) {
          Row() { // 父节点Row1
            Button('Button1') // 子节点Button1
              .width(140)
              .height(45)
              .margin(5)
              .onFocus(() => {
                hilog.info(DOMAIN, TAG, BUNDLE + 'Button1 onFocus');
              })
              .onBlur(() => {
                hilog.info(DOMAIN, TAG, BUNDLE + 'Button1 onBlur');
              })
          }
          .onFocus(() => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'Row1 onFocus');
          })
          .onBlur(() => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'Row1 onBlur');
          })

          Row() { // 父节点Row2
            Button('Button2') // 子节点Button2
              .width(140)
              .height(45)
              .margin(5)
              .onFocus(() => {
                hilog.info(DOMAIN, TAG, BUNDLE + 'Button2 onFocus');
              })
              .onBlur(() => {
                hilog.info(DOMAIN, TAG, BUNDLE + 'Button2 onBlur');
              })
          }
          .onFocus(() => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'Row2 onFocus');
          })
          .onBlur(() => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'Row2 onBlur');
          })
        }.width('100%').margin({ top: 5 })
      }.width('100%')
    }
    // [StartExclude dynamic_focus_blur]
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Focus_Index_OnFocusOnBlurEvents_title')替换为实际资源文件，在本示例中该资源文件的value值为"聚焦模糊事件/OnFocusOnBlurEvents"
    .title($r('app.string.Focus_Index_OnFocusOnBlurEvents_title'))
    // [EndExclude dynamic_focus_blur]
  }
}
// [End dynamic_focus_blur]