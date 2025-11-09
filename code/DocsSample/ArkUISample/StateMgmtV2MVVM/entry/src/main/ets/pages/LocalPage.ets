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
 *
*/

// [Start Main_Local]
// src/main/ets/pages/LocalPage.ets
@Entry
@ComponentV2
struct TodoList {
  @Local isFinish: boolean = false;

  build() {
    Column() {
      Text('To do')
        .fontSize(40)
        .margin({ bottom: 10 })
      Row() {
        // 请开发者自行在src/main/resources/base/media路径下添加finished.png和unfinished.png两张图片，否则运行时会因资源缺失而报错。
        Image(this.isFinish ? $r('app.media.finished') : $r('app.media.unfinished'))
          .width(28)
          .height(28)
        Text('task1')
          .decoration({ type: this.isFinish ? TextDecorationType.LineThrough : TextDecorationType.None })
      }
      .onClick(() => this.isFinish = !this.isFinish)
    }
  }
}
// [End Main_Local]