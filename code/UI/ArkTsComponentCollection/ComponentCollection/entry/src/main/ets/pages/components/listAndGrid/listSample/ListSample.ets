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
import { ArgumentsControlPanel, PropertiesControlPanel } from './ListControlPanel';

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Extend(Text) function listItemTextStyle() {
  .fontSize(15)
  .borderRadius(24)
  .textAlign(TextAlign.Center)
  .backgroundColor($r('app.color.background_grey'))
}

@Entry
@Component
struct ListSample {
  @State listDirection: Axis = Axis.Vertical;
  @State space: number = 10;
  @State strokeWidth: number = 0;
  @State color: Resource = $r('app.color.background_blue');
  @State barState: BarState = BarState.Auto;
  @State initIndex: number = globalThis.listSampleInitIndex == undefined ? 0 : globalThis.listSampleInitIndex;
  @State edgeEffect: EdgeEffect = EdgeEffect.Spring;
  @State isChainAnimation: boolean = false;
  @State multiSelectable: boolean = false;
  @State lanes: number = 1;
  @State alignListItem: ListItemAlign = ListItemAlign.Center;
  private controller: Scroller = new Scroller();
  private numberArray: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  @Styles listItemTextDynamicSize(){
    .height(this.listDirection == Axis.Horizontal ? '80%' : '20%')
    .width(this.listDirection == Axis.Vertical ? '80%' : '20%')
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.list_title') })
        .flexGrow(0)

      // List
      Column() {
        List({ scroller: this.controller, initialIndex: this.initIndex, space: this.space }) {
          ForEach(this.numberArray, (item, index) => {
            ListItem() {
              Text(item + ``)
                .listItemTextStyle()
                .listItemTextDynamicSize()
            }
          })
        }
        .alignListItem(this.alignListItem)
        .height('100%')
        .width('100%')
        .listDirection(this.listDirection)
        .scrollBar(this.barState)
        .edgeEffect(this.edgeEffect)
        .multiSelectable(this.multiSelectable)
        .chainAnimation(this.isChainAnimation)
        .lanes(this.lanes)
        .divider(
          {
            strokeWidth: this.strokeWidth,
            color: this.color
          }
        )
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .backgroundStyle()
      .height(200)
      .width('100%')
      .flexGrow(0)

      // 状态栏
      IntroductionTitle({ introduction: $r('app.string.list_introduction_state') })
      Column() {
        Text(`当前 initialIndex 为:${this.initIndex}
修改 initialIndex 后请再次进入本页面查看效果`)
          .textAlign(TextAlign.Center)
          .fontColor(Color.Red)
      }
      .backgroundStyle()
      .height(100)
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .flexGrow(0)

      // 控制面板
      Scroll() {
        Column() {
          // 参数
          IntroductionTitle({ introduction: $r('app.string.list_introduction_arguments') })
          Column() {
            ArgumentsControlPanel({
              space: $space,
              initIndex: $initIndex
            })
          }
          .backgroundStyle()

          // 属性
          IntroductionTitle({ introduction: $r('app.string.list_introduction_properties') })
          Column() {
            PropertiesControlPanel({
              listDirection: $listDirection,
              strokeWidth: $strokeWidth,
              lineColor: $color,
              barState: $barState,
              edgeEffect: $edgeEffect,
              isChainAnimation: $isChainAnimation,
              multiSelectable: $multiSelectable,
              lanes: $lanes,
              alignListItem: $alignListItem
            })
          }
          .backgroundStyle()
        }
        .width('100%')
      }
      .flexGrow(1)
      .flexBasis(100)
      .margin({ bottom: 10 })
    }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}