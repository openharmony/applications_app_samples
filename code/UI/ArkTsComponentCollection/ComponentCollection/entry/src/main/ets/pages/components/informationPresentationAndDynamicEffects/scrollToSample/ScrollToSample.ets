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

@Extend(Text) function fancyText() {
  .width('90%')
  .height(80)
  .backgroundColor($r('app.color.scroll_item_color'))
  .borderRadius(15)
  .fontSize(16)
  .textAlign(TextAlign.Center)
  .margin({ top: 10 })
}

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontWeight(FontWeight.Medium)
  .fontSize(20)
  .height(22)
  .letterSpacing('40%')
  .alignSelf(ItemAlign.Start)
  .margin({ left: 24, top: 12 })
}

@Extend(Text) function gridText() {
  .fontSize(16)
  .backgroundColor($r('app.color.scroll_grid_item_color'))
  .height(80)
  .textAlign(TextAlign.Center)
}

@Extend(Column) function itemColumn() {
  .height('40%')
  .backgroundColor($r('app.color.white'))
  .alignItems(HorizontalAlign.Start)
}

@Extend(Button) function sampleButton() {
  .height(40)
  .margin(12)
  .fontColor(Color.White)
  .fontSize(15)
}

@Entry
@Component
struct ScrollToSample {
  private scroller: Scroller = new Scroller();
  private mScroller: Scroller = new Scroller();
  private listScroller: Scroller = new Scroller();
  private gridScroller: Scroller = new Scroller();
  private waterFlowScroller: Scroller = new Scroller();
  private scrollArr: Array<number> = new Array();

  aboutToAppear() {
    for (let i = 0; i < 24; i++) {
      this.scrollArr.push(i)
    }
  }

  @Builder itemFoot() {
    Column() {
      Text(`Footer`)
        .fontSize(10)
        .backgroundColor(Color.Red)
        .width(50)
        .height(50)
        .align(Alignment.Center)
        .margin({ top: 6 })
    }
  }
  build() {
    Column() {
      TitleBar({ title: $r('app.string.scroll_To_effect') });
      Scroll(this.scroller) {
        Column({ space: 10 }) {
          Column() {
            Text($r('app.string.scroller'))
              .leftTitleStyle();
            Button($r('app.string.scroll_To_effect'))
              .sampleButton()
              .alignSelf(ItemAlign.Center)
              .onClick(() => {
                if (this.mScroller.currentOffset().yOffset === 0) {
                  this.mScroller.scrollTo({ xOffset: 0, yOffset: this.mScroller.currentOffset().yOffset + 300,
                    animation: { duration: 800, curve: Curve.Linear }
                  },);
                } else {
                  this.mScroller.scrollTo({ xOffset: 0, yOffset: 0,
                    animation: { duration: 800, curve: Curve.Linear }
                  },);
                }
              }).id('scroll_to_effect_scroller');
            Scroll(this.mScroller) {
              Column() {
                ForEach(this.scrollArr, (item: number) => {
                  Text(item.toString())
                    .fancyText();
                }, (item: number) => item.toString());
              }
              .padding({ top: 6, bottom: 12 })
              .width('100%')
              .alignSelf(ItemAlign.Center)
              .backgroundColor(Color.White);
            }
            .alignSelf(ItemAlign.Center)
            .height('70%')
            .width('92%')
            .borderRadius(24)
            .backgroundColor(Color.White);

          }
          .itemColumn()
          .width('100%')
          .backgroundColor($r('app.color.background_shallow_grey'));

          Column() {
            Text($r('app.string.list'))
              .leftTitleStyle();
            Button($r('app.string.scroll_To_effect'))
              .sampleButton()
              .alignSelf(ItemAlign.Center)
              .onClick(() => {
                if (this.listScroller.currentOffset().yOffset === 0) {
                  this.listScroller.scrollTo({ xOffset: 0, yOffset: this.listScroller.currentOffset().yOffset + 300,
                    animation: { duration: 800, curve: Curve.Linear }
                  },);
                } else {
                  this.listScroller.scrollTo({ xOffset: 0, yOffset: 0,
                    animation: { duration: 800, curve: Curve.Linear }
                  },);
                }
              }).id('scroll_to_effect_list');

            List({ scroller: this.listScroller }) {
              ForEach(this.scrollArr, (item: number) => {
                ListItem() {
                  Text(item.toString())
                    .fancyText();
                }
                .width('100%')
                .alignSelf(ItemAlign.Center)
                .backgroundColor(Color.White);
              }, (item: number) => item.toString());

            }
            .alignSelf(ItemAlign.Center)
            .height('70%')
            .width('92%')
            .borderRadius(24)
            .backgroundColor(Color.White);

          }
          .itemColumn()
          .width('100%')
          .backgroundColor($r('app.color.background_shallow_grey'));

          Column() {
            Text($r('app.string.grid'))
              .leftTitleStyle();
            Button($r('app.string.scroll_To_effect'))
              .sampleButton()
              .alignSelf(ItemAlign.Center)
              .onClick(() => {
                if (this.gridScroller.currentOffset().yOffset <= 0) {
                  this.gridScroller.scrollTo({ xOffset: 0, yOffset: this.gridScroller.currentOffset().yOffset + 500,
                    animation: { duration: 2000, curve: Curve.Linear }
                  },);
                } else {
                  this.gridScroller.scrollTo({ xOffset: 0, yOffset: 0,
                    animation: { duration: 2000, curve: Curve.Linear }
                  },);
                }
              }).id('scroll_to_effect_grid');
            Grid(this.gridScroller) {
              ForEach(this.scrollArr, (day: string) => {
                GridItem() {
                  Text('world')
                    .width('100%')
                    .gridText();
                };
              }, (day: string) => day);
            }
            .alignSelf(ItemAlign.Center)
            .columnsTemplate('1fr 1fr 1fr')
            .columnsGap(12)
            .rowsGap(12)
            .height('70%')
            .width('92%')
            .borderRadius(24)
            .padding({ left: 12, right: 12, top: 12, bottom: 12 })
            .backgroundColor(Color.White);

          }
          .itemColumn()
          .width('100%')
          .backgroundColor($r('app.color.background_shallow_grey'));

          Column() {
            Text($r('app.string.waterFlow'))
              .leftTitleStyle();
            Button($r('app.string.scroll_To_effect'))
              .sampleButton()
              .alignSelf(ItemAlign.Center)
              .onClick(() => {
                if (this.waterFlowScroller.currentOffset().yOffset <= 0) {
                  this.waterFlowScroller.scrollTo({
                    xOffset: 0,
                    yOffset: this.waterFlowScroller.currentOffset().yOffset + 500,
                    animation: { duration: 2000, curve: Curve.Linear }
                  },);
                } else {
                  this.waterFlowScroller.scrollTo({
                    xOffset: 0,
                    yOffset: 0,
                    animation: { duration: 2000, curve: Curve.Linear }
                  },);
                }
              }).id('scroll_to_effect_waterflow');
            WaterFlow({ footer: (): void => this.itemFoot(), scroller: this.waterFlowScroller }) {
              ForEach(this.scrollArr, (day: string) => {
                FlowItem() {
                  Text('hello')
                    .width('30%')
                    .gridText();
                };
              }, (day: string) => day);
            }
            .alignSelf(ItemAlign.Center)
            .columnsTemplate('1fr 1fr 1fr')
            .layoutDirection(FlexDirection.Column)
            .columnsGap(12)
            .rowsGap(12)
            .height('70%')
            .width('92%')
            .borderRadius(24)
            .padding({ left: 12, right: 12, top: 12, bottom: 12})
            .backgroundColor(Color.White);
          }
          .itemColumn()
          .width('100%')
          .backgroundColor($r('app.color.background_shallow_grey'));
        }
        .backgroundColor($r('app.color.background_shallow_grey'))
        .width('100%');
      }
      .padding({left: 10, right: 10, bottom: 24})
      .height('90%')
      .backgroundColor($r('app.color.background_shallow_grey'))
      .scrollable(ScrollDirection.Vertical);
    }
    .width('100%')
    .padding({bottom: 12})
    .backgroundColor($r('app.color.background_shallow_grey'));
  }
}

