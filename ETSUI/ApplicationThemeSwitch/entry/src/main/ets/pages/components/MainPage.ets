/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { NavigationDataModel } from '../../models/HomeModel'
import { navigationData } from '../../mocks/HomeData'
import { getTheme } from '../../utils/ThemeGet'
import { TitleBarComponent } from './TitleBar'
import { homePageContent } from './HomePageContent'

const DEFAULT_OPACITY: number = 1 // 默认透明度
const OPACITY: number = 0.6 // 透明度
const RATIO: number = 0.1 // 组件的宽高比

@Component
export struct MainPage {
  private navigationController: TabsController = new TabsController()
  @Prop ratio: number
  @Prop isLand: boolean
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State navigationTabsIndex: number = 0 // tabs索引
  @State navigationData: Array<NavigationDataModel> = navigationData

  build() {
    Flex({ direction: FlexDirection.Column }) {
      List() {
        ListItem() {
          TitleBarComponent({ ratio: this.ratio })
        }
        .sticky(Sticky.Normal)
        .backgroundImageSize({ width: '100%', height: '100%' })
        .backgroundImage($r('app.media.titleBar'), ImageRepeat.NoRepeat)

        ListItem() {
          Column() {
            Flex({
              justifyContent: FlexAlign.SpaceBetween,
              alignItems: ItemAlign.Center
            }) {
              Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
                ForEach(this.navigationData, item => {
                  Column() {
                    Text(item.navigationData)
                      .margin(6)
                      .fontSize(20)
                      .opacity(this.navigationTabsIndex === item.id ? DEFAULT_OPACITY : OPACITY)
                      .fontWeight(this.navigationTabsIndex === item.id ? FontWeight.Bold : FontWeight.Normal)
                      .fontColor(Color.White)
                  }
                  .onClick(() => {
                    this.navigationTabsIndex = item.id
                    this.navigationController.changeIndex(item.id)
                  })
                }, item => item.toString())

                Row() {
                  Image($r('app.media.nav_classification'))
                    .width(26)
                    .height('55%')
                    .objectFit(ImageFit.Contain)
                  Text($r('app.string.classification'))
                    .fontSize(20)
                    .opacity(OPACITY)
                    .fontWeight(FontWeight.Normal)
                    .fontColor(Color.White)
                }
              }
            }
            .height(38)
            .width('100%')
            .margin({ left: 4, bottom: 12 })
            .padding({ left: 8, right: 8 })

            Tabs({ controller: this.navigationController }) {
              TabContent() {
                homePageContent({ isLand: this.isLand, ratio: this.ratio })
              }
            }
            .barWidth(0)
            .barHeight(0)
            .aspectRatio(RATIO)
            .scrollable(false)
          }
        }
        .backgroundColor(getTheme(this.theme).CATEGORIES_BACKGROUND_COLOR)
      }

      Divider()
        .color($r('app.color.divider_color'))
        .width(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(getTheme(this.theme).BACKGROUND_COLOR)
  }
}