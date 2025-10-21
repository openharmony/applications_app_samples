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
struct RelativeContainerDifferentComponentId {
  @State value: number = 0

  build() {
    Row() {

      RelativeContainer() {
        Row()
          .width(100)
          .height(100)
          .backgroundColor('#a3cf62')
          .alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            left: { anchor: "__container__", align: HorizontalAlign.Start }
          })
          .id("row1")

        Column()
          .width('50%')
          .height(30)
          .backgroundColor('#00ae9d')
          .alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            left: { anchor: "__container__", align: HorizontalAlign.Center }
          })
          .id("row2")

        Flex({ direction: FlexDirection.Row }) {
          Text('1').width('20%').height(50).backgroundColor('#0a59f7')
          Text('2').width('20%').height(50).backgroundColor('#2ca9e0')
          Text('3').width('20%').height(50).backgroundColor('#0a59f7')
          Text('4').width('20%').height(50).backgroundColor('#2ca9e0')
        }
        .padding(10)
        .backgroundColor('#30c9f7')
        .alignRules({
          top: { anchor: "row2", align: VerticalAlign.Bottom },
          left: { anchor: "__container__", align: HorizontalAlign.Start },
          bottom: { anchor: "__container__", align: VerticalAlign.Center },
          right: { anchor: "row2", align: HorizontalAlign.Center }
        })
        .id("row3")

        Stack({ alignContent: Alignment.Bottom }) {
          Text('First child, show in bottom').width('90%').height('100%').backgroundColor('#a3cf62').align(Alignment.Top)
          Text('Second child, show in top').width('70%').height('60%').backgroundColor('#00ae9d').align(Alignment.Top)
        }
        .margin({ top: 5 })
        .alignRules({
          top: { anchor: "row3", align: VerticalAlign.Bottom },
          left: { anchor: "__container__", align: HorizontalAlign.Start },
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
          right: { anchor: "row3", align: HorizontalAlign.End }
        })
        .id("row4")

      }
      .width(300).height(300)
      .margin({ left: 50 })
      .border({ width: 2, color: "#6699FF" })
    }
    .height('100%')
  }
}