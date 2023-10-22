/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar'

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.font_color_shallow'))
  .fontSize(18)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, bottom: 8 })
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(12)
  .margin({ bottom: 12 })
}

@Entry
@Component
struct ListSample {
  @State arr: number[] = [0, 1, 2, 3, 4]

  @Builder itemEnd() {
    Row() {
      Button('Delete').margin('4vp')
      Button('Set').margin('4vp')
    }.padding('4vp').justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.list') })
      Text($r('app.string.delete_list_item'))
        .leftTitleStyle()
      Column() {
        List({ space: 10 }) {
          ForEach(this.arr, (item: number) => {
            ListItem() {
              Text('item' + item)
                .width('100%')
                .height(100)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .borderRadius(10)
                .backgroundColor(0xFFFFFF)
            }
            .transition({ type: TransitionType.Delete, opacity: 0 })
            .swipeAction({
              end: {
                onAction: () => {
                  animateTo({ duration: 1000 }, () => {
                    let index = this.arr.indexOf(item)
                    this.arr.splice(index, 1)
                  })
                },
                actionAreaDistance: 56,
              }
            })
          }, (item: number) => item.toString())
        }
      }
      .cardStyle()
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({ left: 20, right: 20 })
  }
}