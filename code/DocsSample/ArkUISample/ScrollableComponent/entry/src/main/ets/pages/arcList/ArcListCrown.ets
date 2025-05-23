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

import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@kit.ArkUI';
import { ComponentCard } from '../../common/Card';

@Builder
function buildText() {
  Column() {
    Text($r('app.string.ArcListCrown_set'))
      .fontColor('#FFFFFF')
      .fontSize('19fp')

  }.height(10)
}

@Entry
@Component
export struct ArcListCrown {
  private watchSize: string = '466px'; // 手表默认宽高：466*466

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ArcListCrown_title') }) {
          Stack() {
            ArcList({
              initialIndex: 2,
            }) {
              ArcListItem() {
                Text('Network').fontSize('38px').fontColor('#FFFFFFFF')
              }
              .borderRadius('65px')
              .width('414px')
              .height('50px')
              .autoScale(false)

              ArcListItem() {
                Row() {
                  Image($r('app.media.wlan')).width('80px').height('80px')
                    .borderRadius('50px').margin({ left: 7 })
                  Column() {
                    Text('WLAN').fontSize('38px').fontColor('#FFFFFFFF')
                    Text('On').fontSize('20px').fontColor('#FFFFFFFF')
                  }.width('190px')

                  Image($r('app.media.ic_settings_arrow')).width('80px').height('80px')
                    .borderRadius('50px')
                }

              }
              .borderRadius('65px')
              .width('414px')
              .height('100px')
              .backgroundColor('#26FFFFFF')

              ArcListItem() {
                Row() {
                  Image($r('app.media.mobileData')).width('80px').height('80px')
                    .borderRadius('50px').margin({ left: 7 })
                  Column() {
                    Text('Bluetooth').fontSize('38px').fontColor('#FFFFFFFF')
                  }.width('190px')

                  Image($r('app.media.ic_settings_arrow')).width('80px').height('80px')
                    .borderRadius('50px')
                }

              }
              .borderRadius('65px')
              .width('414px')
              .height('100px')
              .backgroundColor('#26FFFFFF')

              ArcListItem() {
                Text('Display').fontSize('38px').fontColor('#FFFFFFFF')
              }
              .borderRadius('65px')
              .width('414px')
              .height('50px')
              .autoScale(false)

              ArcListItem() {
                Row() {
                  Image($r('app.media.displayAndBrightness')).width('80px').height('80px')
                    .borderRadius('50px').margin({ left: 7 })
                  Column() {
                    Text('Display & brightness').fontSize('38px').fontColor('#FFFFFFFF')
                  }.width('190px')

                  Image($r('app.media.ic_settings_arrow')).width('80px').height('80px')
                    .borderRadius('50px')
                }
              }
              .borderRadius('65px')
              .width('414px')
              .height('100px')
              .backgroundColor('#26FFFFFF')
            }
            .space(LengthMetrics.px(10))
            .scrollBarWidth(LengthMetrics.px(10))
            .scrollBarColor(ColorMetrics.resourceColor(Color.White))
            .borderRadius(this.watchSize)
            .focusable(true)
            .focusOnTouch(true)
            .defaultFocus(true)
          }
          .align(Alignment.Center)
          .width(this.watchSize)
          .height(this.watchSize)
          .borderRadius(this.watchSize)
          .backgroundColor(Color.Black)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ArcListCrown_title'))
  }
}