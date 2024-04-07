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

import common from '@ohos.app.ability.common';
import { SetBrightness } from '../common/SetBrightness';
import { CountDown } from '../common/CountDown';
import { FlipClock } from '../common/FlipClock';
import { AlarmClock } from '../common/AlarmClock';
import { MyDataSource, TabType } from '../common/DataSource';
import { tabArray } from '../mock/TabData';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private isTabScrollable: boolean = false;
  private controller: TabsController = new TabsController();

  @Builder
  tabBuilder(item: TabType) {
    Column() {
      Column() {
        Image(this.currentIndex === item.num ? item.icon_after : item.icon)
          .flexGrow(1)
          .height(30)
          .width('30%')
          .objectFit(ImageFit.Contain)
          .opacity(this.currentIndex === item.num ? 1 : 0.5)

        Text(item.text)
          .flexGrow(1)
          .fontSize(20)
          .fontColor(this.currentIndex === item.num ? $r('app.color.text_select') : $r('app.color.text_normal'))
      }
      .width('200%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      Stack() {
        Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
          ForEach(tabArray, (item: TabType) => {
            TabContent() {
              if (item.num === 0) {
                FlipClock()
              } else if (item.num === 1) {
                AlarmClock()
              } else if (item.num === 2) {
                CountDown()
              } else if (item.num === 3) {
                SetBrightness()
              }
            }
            .tabBar(this.tabBuilder(item))
          }, item => JSON.stringify(item))
        }
        .zIndex(-1)
        .width('100%')
        .height('100%')
        .vertical(false)
        .barMode(BarMode.Fixed)
        .animationDuration(370)
        .padding({ bottom: 10 })
        .backgroundColor($r('app.color.divider_bg'))
        .scrollable(this.isTabScrollable)
        .onChange((index: number) => {
          this.currentIndex = index;
        })
      }
      .flexGrow(1)
      .zIndex(1)
      .width('100%')
      .height('100%')
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height('100%')
  }
}