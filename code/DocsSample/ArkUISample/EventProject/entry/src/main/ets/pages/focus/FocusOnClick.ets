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

// [Start dynamic_focus_on_click]
@Entry
@Component
export struct FocusOnclickExample {
  @State count: number = 0;
  @State name: string = 'Button';

  build() {
    NavDestination() {
      Column() {
        Button(this.name)
          .fontSize(30)
          .onClick(() => {
            this.count++
            if (this.count % 2 === 0) {
              this.name = 'count is even number';
            } else {
              this.name = 'count is odd number';
            }
          }).height(60)
      }.height('100%').width('100%').justifyContent(FlexAlign.Center)
    }
    // [StartExclude dynamic_focus_on_click]
    .backgroundColor('#f1f2f3')
    //app.string.Focus_Index_FocusOnClick_title资源文件中的value值为'聚焦点击/FocusOnClick'
    .title($r('app.string.Focus_Index_FocusOnClick_title'))
    // [EndExclude dynamic_focus_on_click]
  }
}
// [End dynamic_focus_on_click]