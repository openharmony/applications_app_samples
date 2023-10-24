/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import { getStringData } from '../../../../data/ResourceDataHandle'
import { TitleBar } from '../../../../common/TitleBar'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'

@Extend(Column) function columnStyle() {
  .height(150)
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .margin({ bottom: 12 })
}

@AnimatableExtend(Text) function animatableFontSize(size: number) {
  .fontSize(size)
}

@Entry
@Component
struct SizeTransitionSample {
  @State mWidth: number = 400
  @State mTabIndex: number = 0
  @State mVisible: Visibility = Visibility.Visible
  @State mFontSize: number = 20
  private intervalID = 0

  @Builder tabbarTitle(name: Resource, index: number) {
    Stack() {
      Text(name)
        .fontSize(22)
        .fontColor(this.mTabIndex === index ? $r('app.color.title_colorone') : $r('app.color.title_colortwo'))

      if (this.mTabIndex === index) {
        Row()
          .backgroundColor($r('app.color.title_colorone'))
          .width(200)
          .height(2)
          .position({ y: 48 })
      }
    }.width(200)
    .height(56)
  }

  onPageShow() {
    this.intervalID = setInterval(() => {
      animateTo({ duration: 2000 }, () => {
        this.mWidth = (this.mWidth == 400 || this.mVisible == Visibility.Hidden) ? 200 : 400
        if (this.mVisible == Visibility.Visible) {
          this.mFontSize = this.mFontSize == 20 ? 40 : 20
        }
      })
      setTimeout(() => {
        animateTo({ duration: 2000 }, () => {
          if (this.mWidth == 200 && this.mVisible == Visibility.Visible) {
            this.mVisible = Visibility.Hidden
          }
          else if (this.mVisible == Visibility.Hidden) {
            this.mVisible = Visibility.Visible
          }
        })
      }, 2000);
    }, 4000);
  }

  onPageHide() {
    clearInterval(this.intervalID)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.size_transition_expansion') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.size_transition_flex') })
          Column() {
            Flex() {
              Text($r('app.string.size_transition_flex'))
            }
            .visibility(this.mVisible)
            .width(this.mWidth)
            .backgroundColor($r('app.color.radio_response_region_color'))
            .height(100)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.size_transition_grid_item') })
          Column() {
            Grid() {
              ForEach([1, 2, 3], (item: number) => {
                GridItem() {
                  Text(getStringData($r('app.string.size_transition_grid_item')) + item)
                }.margin(5).width(100)
              })
            }
            .visibility(this.mVisible)
            .margin(5)
            .width(this.mWidth)
            .backgroundColor($r('app.color.radio_response_region_color'))
            .height(100)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.size_transition_list_item') })
          Column() {
            List() {
              ForEach([1, 2, 3, 4], (item: number) => {
                ListItem() {
                  Text(getStringData($r('app.string.size_transition_list_item')) + item)
                }.margin(5).width(100)
              })
            }
            .visibility(this.mVisible)
            .listDirection(Axis.Horizontal)
            .margin(5)
            .width(this.mWidth)
            .backgroundColor($r('app.color.radio_response_region_color'))
            .height(100)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.size_transition_swiper_item') })
          Column() {
            Swiper() {
              ForEach([1, 2, 3, 4], (item: number) => {
                Text(getStringData($r('app.string.size_transition_swiper_item')) + item)
              })
            }
            .visibility(this.mVisible)
            .margin(5)
            .width(this.mWidth)
            .backgroundColor($r('app.color.radio_response_region_color'))
            .height(100)
          }
          .columnStyle()

          IntroductionTitle({ introduction: ($r('app.string.size_transition_expansion_tabContent')) })
          Column() {
            Tabs() {
              ForEach([0, 1, 2], (item: number) => {
                TabContent() {
                  Text(getStringData($r('app.string.size_transition_expansion_tabContent')) + item)
                }
                .backgroundColor($r('app.color.select_option_bg_color'))
                .tabBar(this.tabbarTitle($r('app.string.size_transition_expansion_tabContent'), item))
              })
            }
            .visibility(this.mVisible)
            .margin(5)
            .width(this.mWidth)
            .backgroundColor($r('app.color.radio_response_region_color'))
            .height(100)
            .onChange((index) => {
              this.mTabIndex = index
            })
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.size_transition_font_size') })
          Column() {
            Text(getStringData($r('app.string.size_transition_font_size')) + ': ' + this.mFontSize)
              .margin(5)
              .visibility(this.mVisible)
              .animatableFontSize(this.mFontSize)
              .backgroundColor($r('app.color.radio_response_region_color'))
              .height(100)
              .width(200)
          }
          .columnStyle()
          .margin({ bottom: 80 })
        }
        .constraintSize({ minWidth: '100%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}