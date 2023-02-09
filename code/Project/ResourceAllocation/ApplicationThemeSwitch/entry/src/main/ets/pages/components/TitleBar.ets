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

import AbilityManager from '@ohos.application.abilityManager';
import { SearchTextModel } from '../../models/HomeModel'
import { searchTextData } from '../../mocks/HomeData'
import { getTheme } from '../../utils/ThemeGet'

const OPACITY_TEXT: number = 0.6 // 文本透明度0.6
const OPACITY_SWIPER: number = 0.8 // 轮播组件透明度0.8
const INDEX: number = 2 // 组件层级2
const INTERVAL: number = 2000 // 切换间隔2秒
const DEFAULT_THEME: number = -1 // 默认主题
const DARK: number = 0 // 深色主题模式
const LIGHT: number = 1 // 浅色主题模式
const CUSTOM_THEME: number = 3 // 自定义主题定义为3

@Component
export struct TitleBarComponent {
  @Prop ratio: number
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State searchData: Array<SearchTextModel> = searchTextData

  @Builder ThemeMenu() {
    Column() {
      Text($r('app.string.light_theme'))
        .fontColor(Color.Black)
        .fontSize(30)
        .borderRadius(8)
        .onClick(() => {
          AbilityManager.updateConfiguration({ colorMode: LIGHT }, () => {
            this.theme = LIGHT
          })
        })

      Text($r('app.string.dark_theme'))
        .fontColor(Color.Black)
        .fontSize(30)
        .borderRadius(8)
        .onClick(() => {
          AbilityManager.updateConfiguration({ colorMode: DARK }, () => {
            this.theme = DARK
          })
        })

      Text($r('app.string.custom_theme'))
        .fontColor(Color.Black)
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
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Image($r('app.media.logo'))
            .width(52)
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
          Image($r('app.media.scan'))
            .width(50)
            .objectFit(ImageFit.Contain)
        }
        .height(38)
        .width('100%')
        .margin({ bottom: 16, top: 10 })
        .bindMenu(this.ThemeMenu)

        Flex({ alignItems: ItemAlign.Center }) {
          Image($r('app.media.search'))
            .objectFit(ImageFit.Contain)
            .width(20 * (this.ratio + 0.2))
            .margin({ left: 12, right: 8 })
          Swiper() {
            ForEach(this.searchData, item => {
              Column() {
                Text(item.searchText)
                  .opacity(OPACITY_TEXT)
                  .fontColor(getTheme(this.theme).DEFAULT_COLOR)
                  .fontSize(18 * this.ratio)
                  .fontFamily('HarmonyHeiTi')
                  .lineHeight(23 * (this.ratio + 0.2))
              }
              .width('100%')
              .height(25 * (this.ratio + 0.2))
              .alignItems(HorizontalAlign.Start)
            }, item => item.toString())
          }
          .loop(true)
          .width('66%')
          .autoPlay(true)
          .vertical(true)
          .indicator(false)
          .interval(INTERVAL)
        }
        .zIndex(INDEX)
        .height(56)
        .margin({ bottom: 12 })
        .backgroundColor(getTheme(this.theme).BACKGROUND_COLOR)
        .border({ width: 2, color: Color.White, radius: 40 })
        .opacity(OPACITY_SWIPER)
      }
      .margin({ top: 10 })
      .padding({ left: 26, right: 26 })
    }
    .width('100%')
    .backgroundColor(getTheme(this.theme).TITLE_BACKGROUND)
  }
}