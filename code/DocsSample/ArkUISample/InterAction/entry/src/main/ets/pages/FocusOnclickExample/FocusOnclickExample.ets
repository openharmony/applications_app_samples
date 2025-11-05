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

// [Start focus_onclick]
@Entry
@Component
struct FocusOnclickExample {
  @State text: string = ''
  @State number:number = 0

  build() {
    Column() {
      Text(this.text)
        .margin({bottom:20})
      //app.string.button资源文件中的value值为'按钮'
      Button($r('app.string.button'))
        .responseRegion([
          {
            x: 0,
            y: 0,
            width: '30%',
            height: '100%'
          }, // 第一个热区为按钮的左侧1/3区域
          {
            x: '70%',
            y: 0,
            width: '30%',
            height: '100%'
          },// 第二个热区为按钮的右侧1/3区域
        ])
        .onClick(() => {
          this.number++;
          this.text = 'button' + this.number + 'clicked'
        })
        .width(200)
    }.width('100%').justifyContent(FlexAlign.Center)
  }
}
// [End focus_onclick]
