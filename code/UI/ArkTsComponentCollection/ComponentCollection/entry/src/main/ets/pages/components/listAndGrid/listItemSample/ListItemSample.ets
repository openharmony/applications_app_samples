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
import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Extend(Column)
function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Extend(Text)
function listItemTextStyle() {
  .fontSize(15)
  .borderRadius(16)
  .textAlign(TextAlign.Center)
  .backgroundColor($r('app.color.background_grey'))
}

@Entry
@Component
struct RowSample {
  @State numberArray: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  @State selectable: boolean = false;
  @State output: string = '';

  @Builder
  swipeAction(index: number) {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround }) {
      Button(`删除`)
        .onClick(() => {
          this.numberArray.splice(index, 1);
        })
    }
    .width('30%')
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.list_item_title') })
        .flexGrow(0)
      IntroductionTitle({ introduction: $r('app.string.list_introduction_delete') })
      // component
      Column() {

        List({ space: 10 }) {
          ForEach(this.numberArray, (item: number, index: number) => {
            ListItem() {
              Text(item + ``)
                .listItemTextStyle()
                .height('20%')
                .width('80%')
            }
            .selectable(this.selectable)
            .onSelect((b) => {
              this.output = b === true ? `进入鼠标框选范围` : `移除鼠标框选范围`;
            })
            .swipeAction({
              end: this.swipeAction(index)
            })
          })
        }
        .alignListItem(ListItemAlign.Center)
        .height('100%')
        .width('100%')
        .multiSelectable(true)
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .backgroundStyle()
      .height(200)
      .width('100%')
      .flexGrow(0)

      // 状态栏
      IntroductionTitle({ introduction: $r('app.string.list_item_introduction_drag') })
      Column() {
        Text(this.output)
          .width('100%')
          .textAlign(TextAlign.Center)
      }
      .backgroundStyle()
      .height(100)
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 16 })
      .flexGrow(0)

      Scroll() {
        // 控制面板
        Column() {
          IntroductionTitle({ introduction: $r('app.string.list_item_introduction_properties') })
          Column() {
            CommonSwitcher({
              name: $r('app.string.list_item_properties_selectable'),
              bool: $selectable,
              testID: `listitem_001`
            })
          }
          .backgroundStyle()
        }
        .justifyContent(FlexAlign.Start)
        .height('100%')
        .width('100%')
      }
      .alignSelf(ItemAlign.Start)
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