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

import hiTraceMeter from '@ohos.hiTraceMeter';

@Component
struct TextItem {
  @State item: string = " ";

  build() {
    Text(this.item)
      .fontSize(16)
      .textAlign(TextAlign.Center)
      .backgroundColor(0xF9CF93)
      .width('100%')
      .height(80)
  }

  aboutToAppear() {
    hiTraceMeter.finishTrace("useGridLayoutOptions", 1);
  }
}

class MyDataSource implements IDataSource {
  private dataArray: string[] = [];

  public pushData(data: string): void {
    this.dataArray.push(data);
  }

  // 数据源的数据总量
  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): string {
    return this.dataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}

@Component
export struct GridLayoutOptionsView {
  // 数据源
  private dataSource: MyDataSource = new MyDataSource();
  scroller: Scroller = new Scroller();
  private irregularData: number[] = [];
  layoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    irregularIndexes: this.irregularData,
  };

  aboutToAppear() {
    for (let i = 1; i <= 2000; i++) {
      this.dataSource.pushData(i + "");
      if ((i - 1) % 4 === 0) {
        this.irregularData.push(i - 1);
      }
    }
  }

  build() {
    Column({ space: 5 }) {
      Text($r('app.string.use_layout_options'))
        .fontColor(0xCCCCCC)
        .fontSize(16)
        .width('90%')
      Grid(this.scroller, this.layoutOptions) {
        LazyForEach(this.dataSource, (item: string, index: number) => {
          GridItem() {
            TextItem({ item: item })
          }
        }, (item: string) => item)
      }
      .columnsTemplate("1fr 1fr 1fr")
      .columnsGap(10)
      .rowsGap(10)
      .width("90%")
      .height("40%")

      Button("scrollToIndex:1900")
        .id('scrollToIndexTwoBtn')
        .onClick(() => {
          // 开始打点任务
          hiTraceMeter.startTrace("useGridLayoutOptions", 1);
          this.scroller.scrollToIndex(1900);
        })
    }
    .width("100%")
    .margin({ top: 5 })
  }
}