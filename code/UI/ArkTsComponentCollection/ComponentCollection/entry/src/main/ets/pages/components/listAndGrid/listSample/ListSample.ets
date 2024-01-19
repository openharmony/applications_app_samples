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
import { ArgumentsSpaceControlPanel, ArgumentsInitIndexControlPanel,
  PropertiesListDirectionControlPanel,
  PropertiesStrokeWidthControlPanel,
  PropertiesLineColorControlPanel,
  PropertiesBarStateControlPanel,
  PropertiesScrollBarColorControlPanel,
  PropertiesScrollBarWidthControlPanel,
  PropertiesEdgeEffectControlPanel,
  PropertiesChainAnimationControlPanel,
  PropertiesMultiControlPanel,
  PropertiesLanesControlPanel,
  PropertiesAlignListItemControlPanel
} from './ListControlPanel';

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
  .borderRadius(8)
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
  @State scrollBarWidth: number = 0;
  @State scrollBarColor: Color = Color.Blue;

  @State initIndex: number = AppStorage.get<number>('listSampleInitIndex') || 0;
  @State edgeEffect: EdgeEffect = EdgeEffect.Spring;
  @State isChainAnimation: boolean = false;
  @State multiSelectable: boolean = false;
  @State lanes: number = 1;
  @State alignListItem: ListItemAlign = ListItemAlign.Center;
  private controller: Scroller = new Scroller();
  private numberArray: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  @Styles
  listItemTextDynamicSize(){
    .height(this.listDirection === Axis.Horizontal ? '80%' : '20%')
    .width(this.listDirection === Axis.Vertical ? '80%' : '20%')
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.list_title') })
        .flexGrow(0)

      // List
      Column() {
        List({ scroller: this.controller, initialIndex: this.initIndex, space: this.space }) {
          ForEach(this.numberArray, (item: number, index: number) => {
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
        .scrollBarColor(this.scrollBarColor)
        .scrollBarWidth(this.scrollBarWidth)
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
      .height('32%')
      .width('100%')
      .flexGrow(0)

      Column() {
        Text() {
          Span($r('app.string.current_initialIndex'))
          Span(this.initIndex.toString())
        }

        Text($r('app.string.modify_initialIndex_tips'))
          .textAlign(TextAlign.Start)
          .fontColor(Color.Gray)
      }
      .height('16%')
      .width('100%')
      .padding({left:12})
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .flexGrow(0)

      // tab页签
        Column() {
          ///////
          Tabs({ barPosition: BarPosition.Start }) {
            // 子页签：WaterFlow控制
            TabContent() {
              Column() {
                ArgumentsSpaceControlPanel({space: $space})
                  .backgroundColor(Color.White)
                  .height(96)
                  .margin({bottom:12})
                  .padding({left:12,right:12, top:17, bottom:17})
                  .borderRadius(16)

                ArgumentsInitIndexControlPanel({initIndex: $initIndex})
                  .backgroundColor(Color.White)
                  .borderRadius(16)
                  .padding({left:12,right:12,top:12})
                  .margin({bottom:12})
              }
              .height('100%')
            }.tabBar(new SubTabBarStyle($r('app.string.list_introduction_arguments')))

            // 子页签：WaterFlow属性
            TabContent() {
                Scroll() {
                  Column() {
                    PropertiesListDirectionControlPanel({listDirection: $listDirection})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})

                    PropertiesStrokeWidthControlPanel({strokeWidth: $strokeWidth})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})
                      .height(96)

                    PropertiesLineColorControlPanel({lineColor: $color})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})

                    PropertiesBarStateControlPanel({barState: $barState})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})

                    PropertiesScrollBarColorControlPanel({scrollBarColor: $scrollBarColor})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})

                    PropertiesScrollBarWidthControlPanel({scrollBarWidth: $scrollBarWidth})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})
                      .height(96)

                    PropertiesEdgeEffectControlPanel({edgeEffect: $edgeEffect})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})

                    PropertiesChainAnimationControlPanel({isChainAnimation: $isChainAnimation})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})

                    PropertiesMultiControlPanel({multiSelectable: $multiSelectable})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})

                    PropertiesLanesControlPanel({lanes: $lanes})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})

                    PropertiesAlignListItemControlPanel({alignListItem: $alignListItem})
                      .backgroundColor(Color.White)
                      .borderRadius(16)
                      .padding({left:12,right:12,top:12})
                      .margin({bottom:12})
                  }
                  .width('100%')
                }
                .flexGrow(1)
                .flexBasis(100)
                .margin({ bottom: 10 })
                .background()
              .id('list_properties_scroll')
            }.tabBar(new SubTabBarStyle($r('app.string.list_introduction_properties')))
          }
          .vertical(false)
          .scrollable(true)
          .barMode(BarMode.Fixed)
          .backgroundColor(Color.Pink)
          .onChange((index: number) => {
            console.info(index.toString())
          })
          .width('100%')
          .backgroundColor(0xF1F3F5)
        }
        .height('40%')
        .width('100%')
      }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}