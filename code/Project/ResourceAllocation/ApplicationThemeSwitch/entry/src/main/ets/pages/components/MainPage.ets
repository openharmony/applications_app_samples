/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { HomePageContent } from './HomePageContent'
import { NAV_DATA } from '../../mocks/ProductsData'

@Component
export struct MainPage {
  @Prop ratio: number
  @Prop isLand: boolean
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State navigationTabsIndex: number = 0 // tabs索引
  @State navigationData: Array<NavigationDataModel> = navigationData
  @State navTabsIndex: number = 0
  private url: string
  private navController: TabsController = new TabsController()
  @StorageProp('curBp') curBp: string = 'sm'

  build() {
    Column() {
      TitleBarComponent()
        .backgroundImageSize({ width: '100%', height: '100%' })
        .backgroundImage($r('app.media.title_bar'), ImageRepeat.NoRepeat)
      Scroll() {
        Column() {
          Row() {
            ForEach(NAV_DATA, item => {
              Row() {
                Text(item.navData)
                  .fontSize(16)
                  .fontColor($r('app.color.white'))
                  .opacity(this.navTabsIndex == item.id ? 1 : 0.8)
                  .fontWeight(this.navTabsIndex == item.id ? 500 : 400)
              }
              .align(Alignment.Center)
              .onClick(() => {
                this.navTabsIndex = item.id
                this.navController.changeIndex(item.id)
              })
            }, item => item.id.toString())

            Row() {
              Divider()
                .vertical(true)
                .width(1)
                .height(18)
                .color($r('app.color.divider_white'))
              Image($r('app.media.nav_classification'))
                .width(16)
                .height(16)
                .objectFit(ImageFit.Contain)
                .margin({ left: 4 })
              Text($r('app.string.classification'))
                .fontSize(16)
                .opacity(0.8)
                .fontColor($r('app.color.white'))
                .margin({ left: 2 })
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding(12)

          HomePageContent({ isLand: this.isLand, ratio: this.ratio })
        }
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .flexGrow(1)
      .flexShrink(1)
      .align(Alignment.Top)
      .backgroundColor(getTheme(this.theme).CATEGORIES_BACKGROUND_COLOR)

      Divider()
        .color($r('app.color.divider2'))
        .height(0.5)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(getTheme(this.theme).BACKGROUND_COLOR)
  }
}