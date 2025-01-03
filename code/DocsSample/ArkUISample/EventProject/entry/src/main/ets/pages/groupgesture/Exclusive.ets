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

@Entry
@Component
export struct Exclusive {
  @State count1: number = 0;
  @State count2: number = 0;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Text($r('app.string.groupgesture_Exclusive_text'))
          .fontSize(14)
          .fontColor('#666')
        Column() {
          Text('Exclusive gesture\n' + 'tapGesture count is 1:' + this.count1 + '\ntapGesture count is 2:' + this.count2 + '\n')
            .fontSize(28)
        }
        .height(200)
        .width('100%')
        //以下组合手势为互斥并别，单击手势识别成功后，双击手势会识别失败
        .gesture(
          GestureGroup(GestureMode.Exclusive,
            TapGesture({ count: 1 })
              .onAction(() => {
                this.count1++;
              }),
            TapGesture({ count: 2 })
              .onAction(() => {
                this.count2++;
              })
          )
        )
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.groupgesture_Exclusive_title'))
  }
}