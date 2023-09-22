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

import { CommonSwitcher } from '../../../../common/AttributeModificationTool';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.Start)
}

@Entry
@Component
struct TabSample {
  @State barPosition: BarPosition = BarPosition.Start;
  @State isDisabled: boolean = true;
  @State isBottomTabBar: boolean = false;
  @State vertical: boolean = false;
  private controller: TabsController = new TabsController();

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.tab_content_title') })
        .flexGrow(0)
      // component
      Tabs({
        barPosition: this.vertical ? BarPosition.Start : this.isBottomTabBar ? BarPosition.End : BarPosition.Start,
        controller: this.controller
      }) {
        TabContent() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#00CB87')
        }
        .tabBar(new SubTabBarStyle('green')
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 10,
            minFontSize: 10,
            heightAdaptivePolicy: TextHeightAdaptivePolicy.MAX_LINES_FIRST,
            font: { size: 16 }
          }))

        TabContent() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#007DFF')
        }
        .tabBar(new SubTabBarStyle('blue')
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 10,
            minFontSize: 10,
            heightAdaptivePolicy: TextHeightAdaptivePolicy.MAX_LINES_FIRST,
            font: { size: 16 }
          }))

        TabContent() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#FFBF00')
        }
        .tabBar(new SubTabBarStyle('yellow')
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 10,
            minFontSize: 10,
            heightAdaptivePolicy: TextHeightAdaptivePolicy.MAX_LINES_FIRST,
            font: { size: 16 }
          }))

        TabContent() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#E67C92')
        }
        .tabBar(new SubTabBarStyle('pink')
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 10,
            minFontSize: 10,
            heightAdaptivePolicy: TextHeightAdaptivePolicy.MAX_LINES_FIRST,
            font: { size: 16 }
          }))
      }
      .vertical(this.vertical)
      .barMode(BarMode.Fixed)
      .width('100%')
      .height(300)
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 20 })
      .flexGrow(0)

      Scroll() {
        // 控制面板
        Column() {
          Column() {
            CommonSwitcher({
              name: $r('app.string.tab_content_introduction'),
              bool: $isBottomTabBar,
              testID: `tabcontent_001`
            })
              .enabled(this.vertical ? false : true)
            Button($r('app.string.tab_content_side'))
              .padding(12)
              .enabled(this.isBottomTabBar ? true : false)
              .id(`tabcontent_002`)
              .onClick(() => {
                this.vertical = !this.vertical;
              })
          }
          .backgroundStyle()
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .height('100%')
      }
      .flexGrow(1)
      .height(100)
      .margin({ bottom: 10 })
    }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}