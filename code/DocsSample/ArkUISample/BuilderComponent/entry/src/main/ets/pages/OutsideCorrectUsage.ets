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
// [Start calling_builder_outside_correct_usage]
@Entry
@Component
struct BackGround2 {
  @Builder
  myImages() {
    Column() {
      Image($r('app.media.startIcon')).width('100%').height('100%')
    }
  }

  @Builder
  myImages2() {
    Column() {
      Image($r('app.media.startIcon')).width('100%').height('100%')
    }
  }

  @State bgColor: ResourceColor = Color.Orange;
  @State bgColor2: ResourceColor = Color.Orange;
  @State index: number = 0;

  build() {
    Column({ space: 10 }) {
      Text('1').width(100).height(50)
      Text('2').width(100).height(50).background(this.myImages) // 直接传递@Builder方法
      Text('3').width(100).height(50).background(this.myImages()) // 直接调用@Builder方法

      Text('4-1').width(100).height(50).fontColor(this.bgColor)
      Text('5-1').width(100).height(50)
      Text('4-2').width(100).height(50)
      Text('5-2').width(100).height(50)
      Stack() {
        Column() {
          Text('Vsync2')
        }
        .size({ width: '100%', height: '100%' })
        .border({ width: 1, color: Color.Black })
      }
      .size({ width: 100, height: 80 })
      .backgroundColor('#ffbbd4bb')

      Button('change').onClick((event: ClickEvent) => {
        this.index = 1;
        this.bgColor = Color.Red;
        this.bgColor2 = Color.Red;
      })
    }
    .margin(10)
  }
}
// [End calling_builder_outside_correct_usage]