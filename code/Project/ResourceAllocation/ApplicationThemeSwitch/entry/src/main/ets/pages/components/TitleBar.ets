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

import AbilityManager from '@ohos.application.abilityManager'
import { SearchTextModel } from '../../models/HomeModel'
import { searchTextData } from '../../mocks/HomeData'
import { getTheme } from '../../utils/ThemeGet'
import { FIND_SEARCH_TEXT_DATA } from '../../mocks/ProductsData'

const DEFAULT_THEME: number = -1 // 默认主题
const DARK: number = 0 // 深色主题模式
const LIGHT: number = 1 // 浅色主题模式
const CUSTOM_THEME: number = 3 // 自定义主题定义为3
const PLAY_BACK_TIME: number = 2000 //swiper组件自动回放的时间
@Component
export struct TitleBarComponent {
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State searchData: Array<SearchTextModel> = searchTextData
  @State isLight: boolean = true

  @Builder ThemeMenu() {
    Column() {
      Text($r('app.string.light_theme'))
        .fontColor(this.isLight ? Color.Black : Color.White)
        .fontSize(30)
        .borderRadius(8)
        .onClick(() => {
          AbilityManager.updateConfiguration({ colorMode: LIGHT }, () => {
            this.isLight = true
            this.theme = LIGHT
          })
        })

      Text($r('app.string.dark_theme'))
        .fontColor(this.isLight ? Color.Black : Color.White)
        .fontSize(30)
        .borderRadius(8)
        .onClick(() => {
          AbilityManager.updateConfiguration({ colorMode: DARK }, () => {
            this.isLight = false
            this.theme = DARK
          })
        })

      Text($r('app.string.custom_theme'))
        .fontColor(this.isLight ? Color.Black : Color.White)
        .fontSize(30)
        .borderRadius(8)
        .onClick(() => {
          this.theme = CUSTOM_THEME
        })
    }
    .padding(10)
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
        Row() {
          Image($r('app.media.logo'))
            .width(24)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)

          if (this.theme !== DEFAULT_THEME) {
            Row() {
              Text($r('app.string.theme_current'))
                .fontSize(20)
                .fontColor(getTheme(this.theme).STATUS_COLOR)
                .backgroundColor(Color.White)
              Text(this.theme === LIGHT ? $r('app.string.light_theme') : this.theme === DARK ? $r('app.string.dark_theme') : $r('app.string.custom_theme'))
                .fontSize(20)
                .fontColor(getTheme(this.theme).STATUS_COLOR)
                .backgroundColor(Color.White)
            }
          } else {
            Text($r('app.string.theme_switch_button'))
              .fontSize(20)
              .fontColor(getTheme(this.theme).STATUS_COLOR)
              .backgroundColor(Color.White)
          }
          Image($r('app.media.scan_code'))
            .width(24)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .bindMenu(this.ThemeMenu)

        Row() {
          Image($r('app.media.search'))
            .objectFit(ImageFit.Contain)
            .width(20)
            .aspectRatio(1)
          Swiper() {
            ForEach(FIND_SEARCH_TEXT_DATA, item => {
              Column() {
                Text(item.searchText)
                  .opacity(0.6)
                  .fontColor($r('app.color.blank'))
                  .fontFamily('HarmonyHeiTi')
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }, item => item.id.toString())
          }
          .loop(true)
          .autoPlay(true)
          .vertical(true)
          .indicator(false)
          .interval(PLAY_BACK_TIME)
          .margin(12)
          .displayCount(1)
        }
        .zIndex(2)
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .margin({ top: 8, bottom: 12 })
        .padding({ left: 12, right: 12 })
        .backgroundColor($r('app.color.white'))
        .border({ width: 2, color: $r('app.color.white'), radius: 40 })
      }
      .margin({ top: 12 })
      .padding({ left: 12, right: 12 })
    }
    .width('100%')
    .backgroundColor(getTheme(this.theme).TITLE_BACKGROUND)
  }
}