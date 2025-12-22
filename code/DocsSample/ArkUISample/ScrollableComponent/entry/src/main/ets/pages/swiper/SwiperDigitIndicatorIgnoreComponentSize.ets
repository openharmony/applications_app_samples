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

import { LengthMetrics } from '@kit.ArkUI';
import { ComponentCard } from '../../common/Card';

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
export struct SwiperDigitIndicatorIgnoreComponentSize {
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
    NavDestination() {
      Column({ space: 12 }) {
        // 请将$r('app.string.SwiperDigitIndicatorIgnoreComponentSize_title')替换为实际资源文件，
        // 在本示例中该资源文件的value值为"设置数字导航点忽略导航点组件大小"
        ComponentCard({ title: $r('app.string.SwiperDigitIndicatorIgnoreComponentSize_title') }) {
          Scroll() {
            Column({ space: 20 }) {
              // [Start digit_indicator]
              Swiper(
                // [StartExclude digit_indicator]
                this.swiperController1
                // [EndExclude digit_indicator]
              ) {
                // [StartExclude digit_indicator]
                LazyForEach(this.data1, (item: string) => {
                  Text(item.toString())
                    .width('90%')
                    .height(120)
                    .backgroundColor(0xAFEEEE)
                    .textAlign(TextAlign.Center)
                    .fontSize(30)
                }, (item: string) => item)
                // [EndExclude digit_indicator]
              }
              .indicator(new DigitIndicator()
                .bottom(LengthMetrics.vp(0), true)
              )

              // [End digit_indicator]
            }.width('100%')
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.SwiperDigitIndicatorIgnoreComponentSize_title')替换为实际资源文件，在本示例中该资源文件的value值为"设置数字导航点忽略导航点组件大小"
    .title($r('app.string.SwiperDigitIndicatorIgnoreComponentSize_title'))
  }
}