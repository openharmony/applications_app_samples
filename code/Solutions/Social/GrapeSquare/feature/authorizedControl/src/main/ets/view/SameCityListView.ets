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

import router from '@ohos.router';

const TAB_INDEX_0: number = 0;
const TAB_INDEX_1: number = 1;

class hotItem {
  public id: string;
  public number: string | Resource;
  public des: string | Resource;

  constructor(id: string, number: string | Resource, des: string | Resource) {
    this.id = id;
    this.number = number;
    this.des = des;
  }
}

class info {
  currentIndex: number = 1;
}

@Component
export struct SameCityListView {
  @State message: Resource = $r('app.string.hot_search_list');
  @State currentTabIndex: number = (router.getParams() as info).currentIndex;
  private controller: TabsController = new TabsController();

  @Builder
  TabBuilder(index: number, name: string | Resource) {
    Column() {

      Text(name)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize($r('app.integer.layout_size_16'))
        .fontColor(this.currentTabIndex === index ? $r('app.color.font_color_007DFF') : $r('app.color.font_color_182431'))
        .lineHeight($r('app.integer.layout_size_22'))
        .fontWeight(this.currentTabIndex === index ? 500 : 400)
        .margin({ bottom: $r('app.integer.layout_size_7') })
        .opacity(this.currentTabIndex === index ? $r('app.integer.layout_size_1') : $r('app.float.opacity'))
      Divider()
        .strokeWidth(2)
        .width($r('app.integer.layout_size_48'))
        .borderRadius($r('app.integer.layout_size_1'))
        .color($r('app.color.font_color_007DFF'))
        .opacity(this.currentTabIndex === index ? $r('app.integer.layout_size_1') : $r('app.integer.layout_size_0'))
        .margin({ bottom: $r('app.integer.layout_size_8') })
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .width($r('app.integer.layout_size_24'))
          .height($r('app.integer.layout_size_24'))
          .margin({ right: $r('app.integer.layout_size_24') })
          .onClick(() => {
            router.back()
          })
          .id('locationbackBtn')
        Text($r('app.string.hot_search_list'))
          .fontSize($r('app.integer.layout_size_20'))
          .fontWeight(FontWeight.Bold)
          .margin({ top: $r('app.integer.layout_size_15'), bottom: $r('app.integer.layout_size_10') })
      }
      .margin({ top: $r('app.integer.layout_size_10') })
      .width('90%')

      Row() {
        Tabs({ barPosition: BarPosition.Start, controller: this.controller, index: this.currentTabIndex }) {
          TabContent() {
            HotSearchDetail();
          }
          .tabBar(this.TabBuilder(TAB_INDEX_0,
            $r('app.string.hot_search_list')))

          TabContent() {
            SameCityDetail();
          }
          .tabBar(this.TabBuilder(TAB_INDEX_1,
            $r('app.string.same_city_list')))
        }
        .onChange((index: number) => {
          this.currentTabIndex = index;
          if (this.currentTabIndex === TAB_INDEX_0) {
            this.message = $r('app.string.hot_search_list');
          } else if (this.currentTabIndex === TAB_INDEX_1) {
            this.message = $r('app.string.same_city_list');
          }
        })
        .barWidth($r('app.integer.layout_size_200'))
      }
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor($r('app.color.tabbar_background'))
    .width('100%')
    .height('100%')
  }
}

@Component
export struct SameCityDetail {
  //微博热搜榜数据
  @State sameCityGroup: hotItem[] = [
    new hotItem('first', $r('app.string.number_one'), $r('app.string.hot_item_one')),
    new hotItem('second', $r('app.string.number_two'), $r('app.string.hot_item_two')),
    new hotItem('third', $r('app.string.number_three'), $r('app.string.hot_item_three')),
    new hotItem('fourth', $r('app.string.number_four'), $r('app.string.hot_item_four')),
    new hotItem('fifth', $r('app.string.number_five'), $r('app.string.hot_item_five')),
    new hotItem('sixth', $r('app.string.number_six'), $r('app.string.hot_item_six')),
    new hotItem('seventh', $r('app.string.number_seven'), $r('app.string.hot_item_seven')),
    new hotItem('eighth', $r('app.string.number_eight'), $r('app.string.hot_item_eight')),
    new hotItem('ninth', $r('app.string.number_nine'), $r('app.string.hot_item_nine')),
    new hotItem('tenth', $r('app.string.number_ten'), $r('app.string.hot_item_ten'))
  ]
  @StorageLink('location') displayLocation: string = '';

  build() {
    Column() {

      Stack() {
        Row() {
          Text($r('app.string.current_hot_point'))
            .fontSize($r('app.integer.layout_size_14'))
            .fontColor($r('app.color.font_color_182431'))
            .fontFamily('HarmonyHeiTi-Medium')
            .lineHeight($r('app.integer.layout_size_19'))
            .fontWeight(500)
            .margin({ left: $r('app.integer.layout_size_10') })
            .opacity($r('app.float.opacity'))
        }
        .height($r('app.integer.layout_size_48'))
        .width('90%')
        .justifyContent(FlexAlign.Start)

        Row() {
          Text($r('app.string.current_city'))
            .fontSize($r('app.integer.layout_size_10'))
            .height($r('app.integer.layout_size_14'))
          Text(`${this.displayLocation}`)
            .fontSize($r('app.integer.layout_size_10'))
            .height($r('app.integer.layout_size_14'))
            .id('locationDisplay')
        }
        .justifyContent(FlexAlign.End)
        .width('85%')
      }


      Row() {
        List() {
          //创建微博热搜榜
          ForEach(this.sameCityGroup, (item: hotItem) => {
            ListItem() {
              settingHotItem({ number: item.number, des: item.des })
            }
            .margin({ bottom: $r('app.integer.layout_size_5'), top: $r('app.integer.layout_size_5') })
            .width('100%')
          }, (item: hotItem) => item.id.toString())
        }
        .margin({ bottom: $r('app.integer.layout_size_4'), top: $r('app.integer.layout_size_4') })
        .borderRadius($r('app.integer.layout_size_24'))
        .divider({
          strokeWidth: $r('app.float.stroke_width_2'),
          color: $r('app.color.tabbar_background')
        })
        .backgroundColor($r('app.color.font_color_FFFFFF'))
      }
      .width('90%')

    }
    .backgroundColor($r('app.color.tabbar_background'))
    .width('100%')
    .height('100%')
  }
}

@Component
export struct HotSearchDetail {
  //微博热搜榜数据
  @State sameCityGroup: hotItem[] = [
    new hotItem('first', $r('app.string.number_one'), $r('app.string.hot_item_ones')),
    new hotItem('second', $r('app.string.number_two'), $r('app.string.hot_item_two')),
    new hotItem('third', $r('app.string.number_three'), $r('app.string.hot_item_three')),
    new hotItem('fourth', $r('app.string.number_four'), $r('app.string.hot_item_four')),
    new hotItem('fifth', $r('app.string.number_five'), $r('app.string.hot_item_five')),
    new hotItem('sixth', $r('app.string.number_six'), $r('app.string.hot_item_six')),
    new hotItem('seventh', $r('app.string.number_seven'), $r('app.string.hot_item_seven')),
    new hotItem('eighth', $r('app.string.number_eight'), $r('app.string.hot_item_eight')),
    new hotItem('ninth', $r('app.string.number_nine'), $r('app.string.hot_item_nine')),
    new hotItem('tenth', $r('app.string.number_ten'), $r('app.string.hot_item_ten'))
  ]

  build() {
    Column() {
      Row() {
        Text($r('app.string.current_hot_point'))
          .fontSize($r('app.integer.layout_size_14'))
          .fontColor($r('app.color.font_color_182431'))
          .fontFamily('HarmonyHeiTi-Medium')
          .lineHeight($r('app.integer.layout_size_19'))
          .fontWeight(500)
          .margin({
            left: $r('app.integer.layout_size_10'),
            top: $r('app.integer.layout_size_10'),
            bottom: $r('app.integer.layout_size_10')
          })
          .opacity($r('app.float.opacity'))
      }
      .height($r('app.integer.layout_size_48'))
      .width('90%')
      .justifyContent(FlexAlign.Start)

      Row() {
        List() {
          //创建微博热搜榜
          ForEach(this.sameCityGroup, (item: hotItem) => {
            ListItem() {
              settingHotItem({ number: item.number, des: item.des })
            }
            .margin({ bottom: $r('app.integer.layout_size_5'), top: $r('app.integer.layout_size_5') })
            .width('100%')
          }, (item: hotItem) => item.id.toString())
        }
        .margin({ bottom: $r('app.integer.layout_size_4'), top: $r('app.integer.layout_size_4') })
        .borderRadius($r('app.integer.layout_size_24'))
        .divider({
          strokeWidth: $r('app.float.stroke_width_2'),
          color: $r('app.color.tabbar_background')
        })
        .backgroundColor($r('app.color.font_color_FFFFFF'))
      }
      .width('90%')

    }
    .backgroundColor($r('app.color.tabbar_background'))
    .width('100%')
    .height('100%')
  }
}

@Component
struct settingHotItem {
  private des: string | Resource = ''; // 热搜榜编号
  private number: string | Resource = ''; //热搜榜描述

  build() {
    Row() {
      Column() {
        Text(this.number)
          .fontSize($r('app.integer.layout_size_16'))
          .fontWeight(FontWeight.Medium)
          .fontColor('#CD5555')
          .fontStyle(FontStyle.Italic)
          .margin({ left: $r('app.integer.layout_size_20') })
      }

      .margin({
        left: $r('app.integer.layout_size_10'),
        top: $r('app.integer.layout_size_10'),
        bottom: $r('app.integer.layout_size_10'),
        right: $r('app.integer.layout_size_10')
      })

      Column() {
        Text(this.des)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.font_color_182431'))
          .fontWeight(500)
          .fontSize($r('app.integer.layout_size_16'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('80%')
      }

    }
    .height($r('app.integer.layout_size_48'))
    .width('100%')
    .height($r('app.integer.layout_size_46'))
  }
}