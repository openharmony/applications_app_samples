/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ComponentCard } from "../../common/Card";

// xxx.ets
class MyDataSource implements IDataSource {
  private list: number[] = [];

  constructor(list: number[]) {
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): number {
    return this.list[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener() {
  }
}

@Entry
@Component
export struct SwiperAndTabsLinkage {
  @State fontColor: string = '#182431';
  @State selectedFontColor: string = '#007DFF';
  @State currentIndex: number = 0;
  private list: number[] = [];
  private tabsController: TabsController = new TabsController();
  private swiperController: SwiperController = new SwiperController();
  private swiperData: MyDataSource = new MyDataSource([]);

  aboutToAppear(): void {
    for (let i = 0; i <= 9; i++) {
      this.list.push(i);
    }
    this.swiperData = new MyDataSource(this.list);
  }

  @Builder tabBuilder(index: number, name: string) {
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
    }.width('20%')
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SwiperAndTabsLinkage_title') }) {
          Column() {
            Tabs({ barPosition: BarPosition.Start, controller: this.tabsController }) {
              ForEach(this.list, (index: number) =>{
                TabContent().tabBar(this.tabBuilder(index, '页签 ' + this.list[index]))
              })
            }
            .onTabBarClick((index: number) => {
              this.currentIndex = index;
              this.swiperController.changeIndex(index, true);
            })
            .barMode(BarMode.Scrollable)
            .backgroundColor('#F1F3F5')
            .height(56)
            .width('100%')

            Swiper(this.swiperController) {
              LazyForEach(this.swiperData, (item: string) => {
                Text(item.toString())
                  .onAppear(()=>{
                    console.info('onAppear ' + item.toString());
                  })
                  .onDisAppear(()=>{
                    console.info('onDisAppear ' + item.toString());
                  })
                  .width('100%')
                  .height('40%')
                  .backgroundColor(0xAFEEEE)
                  .textAlign(TextAlign.Center)
                  .fontSize(30)
              }, (item: string) => item)
            }
            .loop(false)
            .onSelected((index: number) => {
              console.info("onSelected:" + index);
              this.currentIndex = index;
              this.tabsController.changeIndex(index);
            })
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SwiperAndTabsLinkage_title'))
  }
}