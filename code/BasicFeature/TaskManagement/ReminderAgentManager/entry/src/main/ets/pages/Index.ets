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

import { AlarmClock } from './alarmClock/AlarmClock'
import { ReminderCalendar } from './calendar/Calendar'
import { Timer } from './timer/Timer'

const CATEGORY: Array<{
  tabBarName: Resource,
  selectedImage: Resource,
  unSelectImage: Resource
}> = [
  {
    tabBarName: $r('app.string.alarm_clock'),
    selectedImage: $r('app.media.ic_public_clock_filled'),
    unSelectImage: $r('app.media.ic_public_clock')
  },
  {
    tabBarName: $r('app.string.calendar'),
    selectedImage: $r('app.media.ic_public_calendar_filled'),
    unSelectImage: $r('app.media.ic_public_calendar')
  },
  {
    tabBarName: $r('app.string.timer'),
    selectedImage: $r('app.media.ic_public_timer_filled'),
    unSelectImage: $r('app.media.ic_public_timer')
  }
]

@Entry
@Component
struct Index {
  @State tabsIndex: number = 0

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        ForEach(CATEGORY, (item, index) => {
          TabContent() {
            if (index === 0) {
              AlarmClock({ title: item.tabBarName })
            } else if (index === 1) {
              ReminderCalendar({ title: item.tabBarName })
            } else {
              Timer({ title: item.tabBarName })
            }
          }
          .tabBar(this.TabBarBuilder(index, item.selectedImage, item.unSelectImage, item.tabBarName))
        })
      }
      .barHeight(56)
      .barWidth('100%')
      .vertical(false)
      .scrollable(false)
      .backgroundColor($r('app.color.background_shallow_grey'))
      .onChange((index: number) => {
        this.tabsIndex = index
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder TabBarBuilder(index: number, selectedImage: Resource, unSelectedImage: Resource, tabBarName: Resource) {
    Column() {
      Image(this.tabsIndex === index ? selectedImage : unSelectedImage)
        .width(28)
        .height(28)
        .margin({ bottom: 4 })

      Text(tabBarName)
        .fontSize(12)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontColor(this.tabsIndex === index ? $r('app.color.tab_bar_select') : $r('app.color.tab_bar_unselect'))
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
    .alignItems(HorizontalAlign.Center)
  }
}