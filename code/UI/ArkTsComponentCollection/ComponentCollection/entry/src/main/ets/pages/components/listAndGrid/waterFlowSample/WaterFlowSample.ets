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
// import { ArgumentsSpaceControlPanel, PropertiesControlPanel } from '../listSample/ListControlPanel';
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
  // .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Entry
@Component
struct WaterFlowSample {
  @State listDirection: Axis = Axis.Vertical;
  //
  // @State strokeWidth: number = 0;
  // @State color: Resource = $r('app.color.background_blue');
  // @State barState: BarState = BarState.Auto;
  @State initIndex: number = AppStorage.get<number>('listSampleInitIndex') || 0;
  @State curScrollEvent: String = '无事件';
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

  // scrollBarColor(color: Color | number | string): T;

  @State edgeEffect: EdgeEffect = EdgeEffect.Spring;
  @State scrollBarWidth: number = 0;
  @State scrollBarColor: Color = Color.Blue; // $r('app.color.background_blue') Color.Black
  @State scrollBar: BarState = BarState.On;

  private itemHeightArray: number[] = []

  scroller: Scroller = new Scroller()
  dataSource: WaterFlowDataSource = new WaterFlowDataSource()

  // private controller: Scroller = new Scroller();
  // private numberArray: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  // @Styles
  // listItemTextDynamicSize(){
  //   .height(this.listDirection === Axis.Horizontal ? '80%' : '20%')
  //   .width(this.listDirection === Axis.Vertical ? '80%' : '20%')
  // }

  onScrollByChange() {
    // console.log("WaterFlowControlPanel onScrollByChange test")
    this.scroller.scrollBy(0, this.scrollBy)
  }

  onChange(){
    // console.log("WaterFlowControlPanel scrollEdge onChange test")
    this.scroller.scrollEdge(this.scrollEdge)
  }

    // 保存flow item宽/高
    getItemSizeArray() {
      for (let i = 0; i < 100; i++) {
       if (i % 4 == 0) {
         this.itemHeightArray.push(102)
       } else if (i % 4 == 1) {
         this.itemHeightArray.push(136)
       } else if (i % 4 == 2) {
         this.itemHeightArray.push(136)
       }  else if (i % 4 == 3) {
         this.itemHeightArray.push(102)
       }
      }
    }

    aboutToAppear() {
      this.getItemSizeArray()
    }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.water_flow_title') })
        .flexGrow(0)

      // WaterFlow { space: 2 }
      Column() {
        // (options?: {footer?: CustomBuilder, scroller?: Scroller})
        //
        // // List({ scroller: this.controller, initialIndex: this.initIndex, space: this.space }) {
        // List(value?:{space?: number | string, initialIndex?: number, scroller?: Scroller})

        WaterFlow({scroller: this.scroller}) {
          LazyForEach(this.dataSource, (item: number) => {
        FlowItem() {
          Column() {
            // Text("N" + item).fontSize(12).height('16')
            Image('resources/base/media/water_flow_'+ item % 4 + '.png')
              // .width('65%')
              // .height('65%')
              // .margin({right:0})
              // .padding({right:12})
              // .borderRadius(16)
              // .backgroundColor(Color.White)
              // .layoutWeight(0.25)
              .borderRadius(16)
              .objectFit(ImageFit.Fill)
          }
          // .backgroundColor(Color.Pink)
          // .padding({left:12, top:12})
          .height('100%')
          .borderRadius(16)
          .height(this.itemHeightArray[item % 4])
          // .width('90%')
        }
        .onAppear(() => {
          console.log("WaterFlowControlPanel onAppear test")

          // 即将触底时提前增加数据
          if (item + 20 == this.dataSource.totalCount()) {
            for (let i = 0; i < 40; i++) {
              // this.dataSource.addLastItem()
            }
          }
        })
        .width('100%')
        // .height(50)
        // .height(this.itemHeightArray[item % 4])
        .backgroundColor(Color.White)
        // .borderRadius(16)
      }, (item: string) => item)
    }
        .columnsTemplate("1fr 1fr")
        .columnsGap(12)
        .rowsGap(12)
        // .backgroundColor(Color.Black)
        .width('100%')
        // .height('100%')
        .scrollBar(this.scrollBar)
        .scrollBarColor(this.scrollBarColor)
        .scrollBarWidth(this.scrollBarWidth)
        .edgeEffect(this.edgeEffect)
        .onScroll((scrollOffset: number, scrollState: ScrollState) => {
          this.curScrollEvent = "onScroll";
          this.scrollOffset = scrollOffset;
          this.scrollState = scrollState;

          console.info("WaterFlowControlPanel onScroll this.scrollOffset" + this.scrollOffset)
          console.info("WaterFlowControlPanel onScroll this.scrollState" + this.scrollState)
        })
        .onScrollIndex((first: number, last: number) => {
          this.curScrollEvent = "onScrollIndex";
          this.firstIndex = first;
          this.lastIndex = last;
          console.info("WaterFlowControlPanel onScrollIndex this.firstIndex" + this.firstIndex)
          console.info("WaterFlowControlPanel onScrollIndex this.lastIndex " + this.lastIndex )

        })
        .onScrollStart(() => {
          this.curScrollEvent = "onScrollStart";
          console.info('WaterFlowControlPanel onScrollStart')
        })
        .onScrollStop(() => {
          this.curScrollEvent = "onScrollStop";
          console.info('WaterFlowControlPanel onScrollStop')
        })
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .backgroundStyle()
      .height('45%')
      .width('100%')
      .flexGrow(0)

      // 状态栏
      Column() {
        Text(`当前滚动事件为：${this.curScrollEvent}
当前滚动状态为：${this.scrollState}
本次滚动距离为：${this.scrollOffset}
当前index,first:${this.firstIndex}, last:${this.lastIndex}`)
          .textAlign(TextAlign.Start)
          .fontColor(Color.Gray)
      }
      // .backgroundStyle()
      .height('16%')
      .width('100%')
      .padding({left:12})
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .flexGrow(0)

      // 控制面板
      // Scroll() {
        Column() {

          Tabs({ barPosition: BarPosition.Start }) {
            // 子页签：WaterFlow控制
            TabContent() {
              Column() {
                WaterFlowScrollByControlPanel({
                  scrollBy: $scrollBy
                })
                  // .backgroundColor(Color.White)
                  // .borderRadius(16)
                  // .padding({left:12,right:12,top:12})
                  // .margin({bottom:12})
                  // .backgroundColor(Color.Red)

                WaterFlowScrollEdgeControlPanel({
                  scrollEdge: $scrollEdge
                })
                  // .backgroundColor(Color.White)
                  // .borderRadius(16)
                  // .padding({left:12,right:12})
                  // .backgroundColor(Color.Blue)
                  // .columnStyle()
              }
              .width('100%')
              .height('100%')
              // .backgroundStyle()
              // .columnStyle()
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
              // .backgroundStyle()

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
      // }
      // .flexGrow(1)
      // .flexBasis(100)
      // .margin({ bottom: 10 })
    }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}


//
// @Entry
// @Component
// struct WaterFlowDemo {
//   @State minSize: number = 80
//   @State maxSize: number = 180
//   @State fontSize: number = 24
//   @State colors: number[] = [0xFFC0CB, 0xDA70D6, 0x6B8E23, 0x6A5ACD, 0x00FFFF, 0x00FF7F]
//   scroller: Scroller = new Scroller()
//   dataSource: WaterFlowDataSource = new WaterFlowDataSource()
//   private itemWidthArray: number[] = []
//   private itemHeightArray: number[] = []
//
//   // 计算flow item宽/高
//   getSize() {
//     let ret = Math.floor(Math.random() * this.maxSize)
//     return (ret > this.minSize ? ret : this.minSize)
//   }
//
//   // 保存flow item宽/高
//   getItemSizeArray() {
//     for (let i = 0; i < 100; i++) {
//       this.itemWidthArray.push(this.getSize())
//       this.itemHeightArray.push(this.getSize())
//     }
//   }
//
//   aboutToAppear() {
//     this.getItemSizeArray()
//   }
//
//   @Builder
//   itemFoot() {
//     Column() {
//       Text(`Footer`)
//         .fontSize(10)
//         .backgroundColor(Color.Red)
//         .width(50)
//         .height(50)
//         .align(Alignment.Center)
//         .margin({ top: 2 })
//     }
//   }
//
//   build() {
//     Column({ space: 2 }) {
//       WaterFlow() {
//         LazyForEach(this.dataSource, (item: number) => {
//           FlowItem() {
//             Column() {
//               Text("N" + item).fontSize(12).height('16')
//               Image($r('app.media.water_flow_1')) // + item % 4 + '.png'
//                 .width('150%')
//                 .height('100%')
//                 .objectFit(ImageFit.Contain)
//
//               // Image('res/waterFlowTest(' + item % 5 + ').jpg')
//               //   .objectFit(ImageFit.Fill)
//               //   .width('100%')
//               //   .layoutWeight(1)
//             }
//           }
//           .onAppear(() => {
//             // 即将触底时提前增加数据
//             if (item + 20 == this.dataSource.totalCount()) {
//               for (let i = 0; i < 100; i++) {
//                 this.dataSource.addLastItem()
//               }
//             }
//           })
//           .width('100%')
//           .height(this.itemHeightArray[item % 100])
//           .backgroundColor(this.colors[item % 5])
//         }, (item: string) => item)
//       }
//       .columnsTemplate("1fr 1fr")
//       .columnsGap(10)
//       .rowsGap(5)
//       .backgroundColor(0xFAEEE0)
//       .width('100%')
//       .height('100%')
//     }
//   }
// }