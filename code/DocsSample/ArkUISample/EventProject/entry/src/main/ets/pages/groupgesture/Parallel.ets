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

// [Start parallel_recognition_gesture]
@Entry
@Component
export struct Parallel {
  @State count1: number = 0;
  @State count2: number = 0;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        /* 请将$r('app.string.groupgesture_Parallel_text')替换为实际资源文件，在本示例中该资源文件的value值为"以在一个Column组件上绑定点击手势
           和双击手势组成的并行识别手势为例，由于单击手势和双击手势是并行识别，因此两个手势可以同时进行识别，二者互不干涉。" */
        Text($r('app.string.groupgesture_Parallel_text'))
          .fontSize(14)
          .fontColor('#666')
        Column() {
          Text('Parallel gesture\n' + 'tapGesture count is 1:' + this.count1 + '\ntapGesture count is 2:' + this.count2 + '\n')
            .fontSize(28)
        }
        .height(200)
        .width('100%')
        // 以下组合手势为并行并别，单击手势识别成功后，若在规定时间内再次点击，双击手势也会识别成功
        .gesture(
          GestureGroup(GestureMode.Parallel,
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
    // 请将$r('app.string.groupgesture_Parallel_title')替换为实际资源文件，在本示例中该资源文件的value值为"并行识别"
    .title($r('app.string.groupgesture_Parallel_title'))
  }
}
// [End parallel_recognition_gesture]