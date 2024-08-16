/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';

@Entry
@Component
struct Index {
  private fileName: string[] = [
    'AbilityStartCallback',
    'UIExtensionContext',
    'UIExtensionContentSession'
  ]

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.main_title'))
            .fontSize(30)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({
              top: 8,
              bottom: 8,
              left: 12
            })
        }
      }
      .width('100%')
      .height('7.18%')
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))
      .margin({
        top: '7.18%',
        bottom: '6.41%',
        left: '3.33%'
      })

      List({ initialIndex: 0 }) {
        ForEach(this.fileName, (item: string, index: number) => {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r(`app.string.${item}`))
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({
                  top: 17,
                  bottom: 17,
                  left: 12
                })
                .fontSize(16)
                .width('77.87%')
                .height('39.29%')
                .fontColor($r('app.color.text_color'))

              Row() {
                Image($r('app.media.ic_arrow'))
                  .width(24)
                  .height(24)
                  .margin({ top: 16, bottom: 16, right: 6 })
              }
            }
            .id(item)
            .onClick(() => {
              router.pushUrl({
                url: `uiextensionpages/${item}`
              });
            })
          }
          .height('8.45%')
          .backgroundColor($r('app.color.start_window_background'))
          .borderRadius(24)
          .margin({ top: 12, right: 12, left: 12 })
        }, (item: string, index: number) => item)
      }
      .height('85%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.backGrounding'))
  }
}