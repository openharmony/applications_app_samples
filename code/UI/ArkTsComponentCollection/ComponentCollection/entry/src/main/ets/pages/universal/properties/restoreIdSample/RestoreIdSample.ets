/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { getStringData } from '../../../../data/ResourceDataHandle';
import Logger from '../../../../util/Logger';

@Extend(Button) function commonButtonStyle() {
  .margin(8)
  .fontSize(16)
  .width('100%')
  .margin({ left: 24, right: 24, top: 12 })
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
  .margin({ left: 12, right: 12, bottom: 12 })
}

@Entry
@Component
struct RestoreIdExample {
  @State outSetValueTwo: number = 40
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  private apple: string = getStringData($r('app.string.text_picker_text_apple'));
  private orange: string = getStringData($r('app.string.text_picker_text_orange'));
  private peach: string = getStringData($r('app.string.text_picker_text_peach'));
  private grape: string = getStringData($r('app.string.text_picker_text_grape'));
  private banana: string = getStringData($r('app.string.text_picker_text_banana'));
  private fruits: string[] = [this.apple, this.orange, this.peach, this.grape, this.banana];

  @Builder TabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.currentIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {

    Column() {
      TitleBar({ title: $r('app.string.restore_id') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.list') })
          Column() {
            List({ space: 8 }) {
              ForEach(this.fruits, (item: string) => {
                ListItem() {
                  Button(item)
                    .commonButtonStyle()
                }
              }, (item: string) => item)
            }
            .alignListItem(ListItemAlign.Center)
            .width('100%')
            .restoreId(1)
          }.cardStyle()

          IntroductionTitle({ introduction: $r('app.string.checkbox') })
          Column() {
            Checkbox()
              .select(true)
              .selectedColor(0xed6f21)
              .restoreId(2)
          }.cardStyle()

          IntroductionTitle({ introduction: $r('app.string.radio_title') })
          Column() {
            Radio({ value: 'Radio1', group: 'radioGroup' })
              .checked(true)
              .restoreId(3)
          }.cardStyle()

          IntroductionTitle({ introduction: $r('app.string.toggle_title') })
          Column() {
            Toggle({ type: ToggleType.Switch, isOn: false })
              .selectedColor('#007DFF')
              .switchPointColor('#FFFFFF')
              .restoreId(4)
          }.cardStyle()

          IntroductionTitle({ introduction: $r('app.string.swiper_name') })
          Column() {
            Swiper() {
              ForEach(['1', '2', '3'], (item: string) => {
                Text(item)
                  .width('90%')
                  .height(160)
                  .backgroundColor(0xAFEEEE)
                  .textAlign(TextAlign.Center)
                  .fontSize(30)
              }, (item: string) => item)
            }
            .cachedCount(2)
            .index(1)
            .autoPlay(true)
            .interval(4000)
            .indicator(true)
            .loop(true)
            .duration(1000)
            .itemSpace(0)
            .curve(Curve.Linear)
            .restoreId(5)
          }.cardStyle()

          IntroductionTitle({ introduction: $r('app.string.tabs_name') })
          Column() {
            Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
              TabContent() {
                Column().width('100%').height('100%').backgroundColor('#00CB87')
              }.tabBar(this.TabBuilder(0, 'green'))

              TabContent() {
                Column().width('100%').height('100%').backgroundColor('#007DFF')
              }.tabBar(this.TabBuilder(1, 'blue'))

              TabContent() {
                Column().width('100%').height('100%').backgroundColor('#FFBF00')
              }.tabBar(this.TabBuilder(2, 'yellow'))

              TabContent() {
                Column().width('100%').height('100%').backgroundColor('#E67C92')
              }.tabBar(this.TabBuilder(3, 'pink'))
            }
            .vertical(false)
            .barMode(BarMode.Fixed)
            .barWidth(360)
            .barHeight(56)
            .animationDuration(400)
            .onChange((index: number) => {
              this.currentIndex = index
            })
            .width(360)
            .height(296)
            .margin({ top: 52 })
            .backgroundColor('#F1F3F5')
            .restoreId(6)
          }.cardStyle()

          IntroductionTitle({ introduction: $r('app.string.tabs_name') })
          Column() {
            Slider({
              value: this.outSetValueTwo,
              step: 10,
              style: SliderStyle.OutSet
            })
              .showSteps(true)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.outSetValueTwo = value
                Logger.info('value:' + value + 'mode:' + mode.toString())
              })
              .restoreId(7)
            Text(this.outSetValueTwo.toFixed(0)).fontSize(12)
          }.cardStyle()

          IntroductionTitle({ introduction: $r('app.string.select_name') })
          Column() {
            Select([{ value: 'aaa', icon: $r('app.media.ic_select_global') },
              { value: 'bbb', icon: $r('app.media.ic_select_global') },
              { value: 'ccc', icon: $r('app.media.ic_select_global') },
              { value: 'ddd', icon: $r('app.media.ic_select_global') }])
              .selected(2)
              .value('TTTTT')
              .font({ size: 16, weight: 500 })
              .fontColor('#182431')
              .selectedOptionFont({ size: 16, weight: 400 })
              .optionFont({ size: 16, weight: 400 })
              .onSelect((index: number) => {
                Logger.info('Select:' + index)
              })
              .restoreId(8)
          }.cardStyle().margin({ bottom: 80 })
        }
        .padding(12)
        .constraintSize({ minHeight: '100%' })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}