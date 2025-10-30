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

// [Start dot_indicator]
import { LengthMetrics } from '@kit.ArkUI';
// [StartExclude dot_indicator]
import { ComponentCard } from '../../common/Card';
// [EndExclude dot_indicator]


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
export struct SwiperIgnoreComponentSize {

  @State space: LengthMetrics = LengthMetrics.vp(0);
  @State spacePool: LengthMetrics[] = [LengthMetrics.vp(0), LengthMetrics.px(3), LengthMetrics.vp(10)];
  @State spaceIndex: number = 0;

  @State ignoreSize: boolean = false;
  @State ignoreSizePool: boolean[] = [false, true];
  @State ignoreSizeIndex: number = 0;

  private swiperController1: SwiperController = new SwiperController();
  private data1: MyDataSource = new MyDataSource([]);

  aboutToAppear(): void {
    let list1: number[] = [];
    for (let i = 1; i <= 10; i++) {
      list1.push(i);
    }
    this.data1 = new MyDataSource(list1);
  }

  build() {
    // [StartExclude dot_indicator]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SwiperIgnoreComponentSize_title') }) {
          // [EndExclude dot_indicator]
          Scroll() {
            Column({ space: 20 }) {
              // [Start dot_indicator_space]
              // [Start dot_indicator_bottom]
              Swiper(
                // [StartExclude dot_indicator_space]
                // [StartExclude dot_indicator_bottom]
                this.swiperController1
                // [EndExclude dot_indicator_bottom]
                // [EndExclude dot_indicator_space]
              ) {
                // [StartExclude dot_indicator_space]
                // [StartExclude dot_indicator_bottom]
                LazyForEach(this.data1, (item: string) => {
                  Text(item.toString())
                    .width('90%')
                    .height(120)
                    .backgroundColor(0xAFEEEE)
                    .textAlign(TextAlign.Center)
                    .fontSize(30)
                }, (item: string) => item)
                // [EndExclude dot_indicator_bottom]
                // [EndExclude dot_indicator_space]
              }
              .indicator(new DotIndicator()
                // [StartExclude dot_indicator_bottom]
                .space(this.space)
                // [EndExclude dot_indicator_bottom]
                // [StartExclude dot_indicator_space]
                .bottom(LengthMetrics.vp(0), this.ignoreSize) // true
                // [StartExclude dot_indicator_bottom]
                .itemWidth(15)
                .itemHeight(15)
                .selectedItemWidth(15)
                .selectedItemHeight(15)
                .color(Color.Gray)
                .selectedColor(Color.Blue)
                // [EndExclude dot_indicator_space]
                // [EndExclude dot_indicator_bottom]
              )
              // [End dot_indicator_bottom]
              // [End dot_indicator_space]
              .displayArrow({
                showBackground: true,
                isSidebarMiddle: true,
                backgroundSize: 24,
                backgroundColor: Color.White,
                arrowSize: 18,
                arrowColor: Color.Blue
              }, false)

              Column({ space: 4 }) {
                Button('spaceIndex:' + this.spaceIndex).onClick(() => {
                  this.spaceIndex = (this.spaceIndex + 1) % this.spacePool.length;
                  this.space = this.spacePool[this.spaceIndex];
                }).margin(10)

                Button('ignoreSizeIndex:' + this.ignoreSizeIndex).onClick(() => {
                  this.ignoreSizeIndex = (this.ignoreSizeIndex + 1) % this.ignoreSizePool.length;
                  this.ignoreSize = this.ignoreSizePool[this.ignoreSizeIndex];
                }).margin(10)
              }.margin(2)
            }.width('100%')
          }
          // [StartExclude dot_indicator]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SwiperIgnoreComponentSize_title'))
    // [EndExclude dot_indicator]
  }
}
// [End dot_indicator]