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

// [Start state_source_update_refresh]
@Entry
@Component
struct StateIndex {
  @State isFinished: boolean = false;

  build() {
    Column() {
      Row() {
        // 请将$r('app.string.all_tasks')替换为实际资源文件，在本示例中该资源文件的value值为"全部待办"
        Text($r('app.string.all_tasks'))
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .margin({ top: 10, bottom: 10 })

      // 待办事项
      Row({ space: 15 }) {
        if (this.isFinished) {
          // 请将$r('app.media.finished')替换为实际资源文件
          Image($r('app.media.finished'))
            .width(28)
            .height(28)
        } else {
          // 请将$r('app.media.unfinished')替换为实际资源文件
          Image($r('app.media.unfinished'))
            .width(28)
            .height(28)
        }
        // 请将$r('app.string.all_learn_advanced_math')替换为实际资源文件，在本示例中该资源文件的value值为"学习高数"
        Text($r('app.string.learn_advanced_math'))
          .fontSize(24)
          .decoration({ type: this.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None })
      }
      .height('40%')
      .width('100%')
      .border({ width: 5 })
      .padding({ left: 15 })
      .onClick(() => {
        this.isFinished = !this.isFinished;
      })
    }
    .height('100%')
    .width('100%')
    .margin({ top: 5, bottom: 5 })
    .backgroundColor('#90f1f3f5')
  }
}

// [End state_source_update_refresh]