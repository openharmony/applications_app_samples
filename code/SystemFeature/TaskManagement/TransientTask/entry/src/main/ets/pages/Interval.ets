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

@Component
export struct Interval {
  @State timer: number = 0;

  build() {
    Column() {
      Row(){
        Text($r('app.string.interval_number')).fontSize(20)
        Text(this.timer.toString()).fontSize(20).id('interval_number')
      }
      Button($r('app.string.counter'))
        .id('counter')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.background'))
        .size({ width: '70%', height: '8%' })
        .onClick(() => {
        setInterval(() => {
          this.timer += 1
          console.info('text now is '+ this.timer)
        }, 1000)
      })
    }
    .width('100%')
  }
}