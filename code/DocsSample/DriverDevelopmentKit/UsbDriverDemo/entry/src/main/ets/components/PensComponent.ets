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

@Preview
@Component
export struct PensComponent {
  @State value: number = 200;

  build() {
    Column() {
      Row() {
        // 笔图片
        Column() {
          Image($rawfile('pens.PNG'))
            .height('80%')
        }.height('100%')
        .justifyContent(FlexAlign.Center)
        // 左键右键
        Column() {
          Row() {
            Column()
              .border({ width: 1, color: '#0A59F7' })
              .width(50)
              .height(1)
            Column()
              .width(10)
              .height(10)
              .borderRadius(10)
              .backgroundColor('#0A59F7')
            Text('右键').margin({ left: 10 })
          }.margin({ bottom: 90 })

          Row() {
            Column()
              .border({ width: 1, color: '#0A59F7' })
              .width(50)
              .height(2)
            Column()
              .width(10)
              .height(10)
              .borderRadius(10)
              .backgroundColor('#0A59F7')
            Text('左键').margin({ left: 10 })
          }
          .margin({ bottom: 50 })
        }
        .height('100%')
        .justifyContent(FlexAlign.End)
        // 笔记效果体验区
        Column() {
          Stack() {
            Row()
              .backgroundColor(Color.White)
              .height('100%')
              .width('100%')
            Text('笔记效果体验区')
              .fontColor(Color.Gray)
              .fontSize(30)
          }.layoutWeight(1)
          .margin({ bottom: 30, top: 30, right: 30, left: 50 })

          Button('清除笔迹')
            .width(150)
            .margin({ bottom: 15 })
        }.layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}