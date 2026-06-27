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

// [Start dynamic_focus_scope]

import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_FocusAndBlurExample]';
const DOMAIN = 0xF811;
const BUNDLE = 'MyApp_FocusAndBlurExample';

@Entry
@Component
export struct ScopeFocusExample {
  @State scopeFocusState: boolean = true;

  build() {
    NavDestination() {
      Column() {
        Column({ space: 5 }) {
          // 请将$r('app.string.Container_Coking')替换为实际资源文件，在本示例中该资源文件的value值为"容器获焦"
          Text($r('app.string.Container_Coking')).textAlign(TextAlign.Center)
        }
        .justifyContent(FlexAlign.Center)
        .width('80%')
        .height(50)
        .margin({ top: 5, bottom: 5 })
        .onClick(() => {
        })
        .focusable(this.scopeFocusState)

        Button('Button1')
          .width(140)
          .height(45)
          .margin(5)
          .onClick(() => {
            this.scopeFocusState = !this.scopeFocusState;
            hilog.info(DOMAIN, TAG, BUNDLE + 'Button1 onFocus');
          })
        Button('Button2')
          .width(140)
          .height(45)
          .margin(5)
      }.width('100%')
    }
    // [StartExclude dynamic_focus_scope]
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Focus_Index_ScopeFocus_title')替换为实际资源文件，在本示例中该资源文件的value值为"范围聚焦/ScopeFocus"
    .title($r('app.string.Focus_Index_ScopeFocus_title'))
    // [EndExclude dynamic_focus_scope]
  }
}

// [End dynamic_focus_scope]