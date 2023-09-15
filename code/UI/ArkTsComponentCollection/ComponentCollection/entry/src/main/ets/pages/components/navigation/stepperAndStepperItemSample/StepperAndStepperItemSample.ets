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

import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Styles function itemStyle () {
  .width(336)
  .height(621)
  .margin({ top: 48, left: 12 })
  .borderRadius(16)
  .backgroundColor('#FFFFFF')
}

@Extend(Text) function itemTextStyle () {
  .fontColor('#182431')
  .fontSize(36)
  .fontWeight(500)
  .opacity(0.4)
  .margin({ top: 82, bottom: 40 })
}

@Entry
@Component
struct GridSample {
  @State currentIndex: number = 0;
  @State firstState: ItemState = ItemState.Normal;
  @State secondState: ItemState = ItemState.Normal;
  @State thirdState: ItemState = ItemState.Normal;

  build() {
    Flex({direction : FlexDirection.Column}){
      TitleBar({ title: $r('app.string.stepper_title')})
        .flexGrow(0)
      Stepper({
        index: this.currentIndex
      }) {
        StepperItem() {
          Column() {
            Text('Page One')
              .itemTextStyle()
            Button('change status:' + this.firstState)
              .backgroundColor('#007dFF')
              .onClick(() => {
                this.firstState = this.firstState === ItemState.Skip ? ItemState.Normal : ItemState.Skip;
              })
          }.itemStyle()
        }
        .nextLabel('Next')
        .status(this.firstState)
        StepperItem() {
          Column() {
            Text('Page Two')
              .itemTextStyle()
            Button('change status:' + this.secondState)
              .backgroundColor('#007dFF')
              .onClick(() => {
                this.secondState = this.secondState === ItemState.Disabled ? ItemState.Normal : ItemState.Disabled;
              })
          }.itemStyle()
        }
        .nextLabel('Next')
        .prevLabel('Previous')
        .status(this.secondState)
        StepperItem() {
          Column() {
            Text('Page Three')
              .itemTextStyle()
            Button('change status:' + this.thirdState)
              .backgroundColor('#007dFF')
              .onClick(() => {
                this.thirdState = this.thirdState === ItemState.Waiting ? ItemState.Normal : ItemState.Waiting;
              })
          }.itemStyle()
        }
        .status(this.thirdState)
        StepperItem() {
          Column() {
            Text('Page Four')
              .itemTextStyle()
          }.itemStyle()
        }
      }
      .width('100%')
      .height(100)
      .flexGrow(1)
      .onFinish(() => {
        console.info('onFinish');
      })
      .onSkip(() => {
        console.info('onSkip');
      })
      .onChange((prevIndex: number, index: number) => {
        this.currentIndex = index;
      })
    }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}