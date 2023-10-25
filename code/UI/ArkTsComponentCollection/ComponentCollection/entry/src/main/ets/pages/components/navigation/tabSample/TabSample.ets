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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { ArgumentsControlPanel, PropertiesControlPanel } from './TabControlPanel';

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
  @State fontColor: string = '#182431';
  @State selectedFontColor: string = '#007DFF';
  @State currentIndex: number = 0;
  @State barPosition: BarPosition = BarPosition.Start;
  @State vertical: boolean = false;
  @State isScrollable: boolean = false;
  @State barMode: BarMode = BarMode.Fixed;
  @State animationDuration: number = 400;
  private controller: TabsController = new TabsController();

  @Builder TabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .margin({ top: 17, bottom: 7 })

      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.currentIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.tabs_title') })
        .flexGrow(0)
      // component
      Tabs({ barPosition: this.barPosition, controller: this.controller }) {
        TabContent() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#00CB87')
        }.tabBar(this.TabBuilder(0, 'green'))

        TabContent() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#007DFF')
        }.tabBar(this.TabBuilder(1, 'blue'))

        TabContent() {
          Column().width('100%').height('100%').backgroundColor('#FFBF00')
        }.tabBar(this.TabBuilder(2, 'yellow'))

        TabContent() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#E67C92')
        }.tabBar(this.TabBuilder(3, 'pink'))
      }
      .vertical(this.vertical)
      .barMode(this.barMode)
      .scrollable(this.isScrollable)
      .animationDuration(this.animationDuration)
      .height(300)
      .width('100%')
      .barWidth(360)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .flexGrow(0)

      Scroll() {
        // 控制面板
        Column() {
          IntroductionTitle({ introduction: $r('app.string.tabs_introduction_arguments') })
          Column() {
            ArgumentsControlPanel({
              barPosition: $barPosition,
              changeIndex: (index: number) => {
                this.controller.changeIndex(index);
              }
            })
          }
          .backgroundStyle()

          IntroductionTitle({ introduction: $r('app.string.tabs_introduction_properties') })
          Column() {
            PropertiesControlPanel({
              vertical: $vertical,
              barMode: $barMode,
              isScrollable: $isScrollable,
              animationDuration: $animationDuration
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