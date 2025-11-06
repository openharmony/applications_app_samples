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

// [Start dynamic_focus_active]
@Entry
@Component
export struct FocusActiveExample {
  build() {
    NavDestination() {
      Column() {
        Button('Set Active').width(140).height(45).margin(5).onClick(() => {
          this.getUIContext().getFocusController().activate(true, true);
        })
        Button('Set Not Active').width(140).height(45).margin(5).onClick(() => {
          this.getUIContext().getFocusController().activate(false, true);
        })
      }.width('100%')
    }
    // [StartExclude dynamic_focus_active]
    .backgroundColor('#f1f2f3')
    // app.string.Pages_Index_Focus_Active_title资源文件中的value值为'聚焦/FocusActive'
    .title($r('app.string.Pages_Index_Focus_Active_title'))
    // [EndExclude dynamic_focus_active]
  }
}

// [End dynamic_focus_active]