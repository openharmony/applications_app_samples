/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { WaterFlowScrollByControlPanel, WaterFlowScrollEdgeControlPanel, WaterFlowDataSource,
  WaterFlowPropertiesScrollBarControlPanel,
  WaterFlowPropertiesScrollBarColorControlPanel,
  WaterFlowPropertiesScrollBarWidthControlPanel,
  WaterFlowPropertiesEdgeEffectControlPanel,
} from './WaterFlowDataSource'

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
@Extend(Column) function columnStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Entry
@Component
struct WaterFlowSample {
  @State listDirection: Axis = Axis.Vertical;

  @State initIndex: number = AppStorage.get<number>('listSampleInitIndex') || 0;
  @State curScrollEvent: string = ""; // $r('app.string.current_event_value')
  @State scrollState: ScrollState = ScrollState.Idle
  @State scrollOffset: number = 10;
  @State firstIndex: number = 0;
  @State lastIndex: number = 0;
  @State currentIndex: number = 0;

  @State isChainAnimation: boolean = false;
  @State multiSelectable: boolean = false;
  @State lanes: number = 1;
  @State alignListItem: ListItemAlign = ListItemAlign.Center;

  @State @Watch("onScrollByChange") scrollBy: number = 100;
  @State @Watch("onChange") scrollEdge: Edge = Edge.Top;

  @State edgeEffect: EdgeEffect = EdgeEffect.Spring;
  @State scrollBarWidth: number = 0;
  @State scrollBarColor: Color = Color.Blue;
  @State scrollBar: BarState = BarState.On;

  private itemHeightArray: number[] = [];

  scroller: Scroller = new Scroller();
  dataSource: WaterFlowDataSource = new WaterFlowDataSource();

  onScrollByChange() {
    this.scroller.scrollBy(0, this.scrollBy);
  }

  onChange(){
    this.scroller.scrollEdge(this.scrollEdge);
  }

    // 保存flow item宽/高
    getItemSizeArray() {
      for (let i = 0; i < 100; i++) {
       if (i % 4 == 0) {
         this.itemHeightArray.push(102);
       } else if (i % 4 == 1) {
         this.itemHeightArray.push(136);
       } else if (i % 4 == 2) {
         this.itemHeightArray.push(136);
       }  else if (i % 4 == 3) {
         this.itemHeightArray.push(102);
       }
      }
    }

    aboutToAppear() {
      this.getItemSizeArray();
    }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.water_flow_title') })
        .flexGrow(0)

      Column() {
        WaterFlow({scroller: this.scroller}) {
          LazyForEach(this.dataSource, (item: number) => {
        FlowItem() {
          Column() {
            Image('resources/base/media/water_flow_'+ item % 4 + '.png')
              .borderRadius(16)
              .objectFit(ImageFit.Fill)
          }
          .height('100%')
          .borderRadius(16)
          .height(this.itemHeightArray[item % 4])
        }
        .width('100%')
        .backgroundColor(Color.White)
      }, (item: string) => item)
    }
        .columnsTemplate("1fr 1fr")
        .columnsGap(12)
        .rowsGap(12)
        .width('100%')
        .scrollBar(this.scrollBar)
        .scrollBarColor(this.scrollBarColor)
        .scrollBarWidth(this.scrollBarWidth)
        .edgeEffect(this.edgeEffect)
        .onScroll((scrollOffset: number, scrollState: ScrollState) => {
          this.curScrollEvent = "onScroll";
          this.scrollOffset = scrollOffset;
          this.scrollState = scrollState;
        })
        .onScrollIndex((first: number, last: number) => {
          this.curScrollEvent = "onScrollIndex";
          this.firstIndex = first;
          this.lastIndex = last;
        })
        .onScrollStart(() => {
          this.curScrollEvent = "onScrollStart";
        })
        .onScrollStop(() => {
          this.curScrollEvent = "onScrollStop";
        })
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .backgroundStyle()
      .height('45%')
      .width('100%')
      .flexGrow(0)

      // 状态栏
      Column() {
        Text() {
          Span($r('app.string.current_scroll_event'));
          Span(this.curScrollEvent);
        }

        Text() {
          Span($r('app.string.current_scroll_state'));
          Span(this.scrollState.toString());
        }

        Text() {
          Span($r('app.string.current_scroll_distance'));
          Span(this.scrollOffset.toString());
        }

        Text() {
          Span($r('app.string.current_scroll_index_first'));
          Span(this.firstIndex.toString());
          Span($r('app.string.current_scroll_index_last'));
          Span(this.lastIndex.toString());
        }
      }
      .height('16%')
      .width('100%')
      .padding({left:12})
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .flexGrow(0)

      // tab 页签
        Column() {
          Tabs({ barPosition: BarPosition.Start }) {
            // 子页签：WaterFlow控制
            TabContent() {
              Column() {
                WaterFlowScrollByControlPanel({
                  scrollBy: $scrollBy
                })
                WaterFlowScrollEdgeControlPanel({
                  scrollEdge: $scrollEdge
                })
              }
              .width('100%')
              .height('100%')
            }.tabBar(new SubTabBarStyle($r('app.string.water_flow_controller')))

            // 子页签：WaterFlow属性
            TabContent() {
              Scroll() {
              Column() {
                WaterFlowPropertiesScrollBarControlPanel({scrollBar: $scrollBar})
                .backgroundColor(Color.White)
                .borderRadius(16)
                .padding({left:12,right:12,top:12})
                .margin({bottom:12})

                WaterFlowPropertiesScrollBarColorControlPanel({scrollBarColor: $scrollBarColor})
                .backgroundColor(Color.White)
                .borderRadius(16)
                .padding({left:12,right:12,top:12})
                .margin({bottom:12})

                WaterFlowPropertiesScrollBarWidthControlPanel({scrollBarWidth: $scrollBarWidth})
                  .backgroundColor(Color.White)
                  .borderRadius(16)
                  .padding({left:12,right:12,top:12})
                  .margin({bottom:12})

                WaterFlowPropertiesEdgeEffectControlPanel({edgeEffect: $edgeEffect})
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
            }.tabBar(new SubTabBarStyle($r('app.string.water_flow_properties')))

          }
          .vertical(false)
          .scrollable(true)
          .barMode(BarMode.Fixed)
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
