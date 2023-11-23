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

// 导入性能打点模块
import hiTraceMeter from "@ohos.hiTraceMeter";

@Component
struct TextItem {
  @State item: string = "";

  build() {
    Text(this.item)
      .fontSize(16)
      .backgroundColor(0xF9CF93)
      .width('100%')
      .height(80)
      .textAlign(TextAlign.Center)
  }

  aboutToAppear() {
    // 结束打点任务
    hiTraceMeter.finishTrace("useColumnStartColumnEnd", 1);
  }
}

class MyDataSource implements IDataSource {
  private dataArray: string[] = [];

  public pushData(data: string): void {
    this.dataArray.push(data);
  }

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
export struct GridColumnStartView {
  private datasource: MyDataSource = new MyDataSource();
  scroller: Scroller = new Scroller();

  aboutToAppear() {
    for (let i = 1; i < 2000; i++) {
      this.datasource.pushData(i + '');
    }
  }

  build() {
    Column({ space: 5 }) {
      Text($r('app.string.use_column_start'))
        .fontColor(0xCCCCCC)
        .fontSize(9)
        .width('90%')
      Grid(this.scroller) {
        LazyForEach(this.datasource, (item: string, index: number) => {
          if ((index % 4) === 0) {
            GridItem() {
              TextItem({ item: item })
            }.columnStart(0).columnEnd(2)
          }
          else {
            GridItem() {
              TextItem({ item: item })
            }
          }

        }, (item: string) => item)
      }
      .columnsTemplate("1fr 1fr 1fr")
      .columnsGap(10)
      .rowsGap(10)
      .width("90%")
      .height("40%")

      Button("scrollToIndex:1900")
        .id('scrollToIndexBtn')
        .onClick(() => {
          // 开始打点任务
          hiTraceMeter.startTrace("useColumnStartColumnEnd", 1);
          this.scroller.scrollToIndex(1900);
        })
    }
    .width("100%")
    .margin({ top: 5 })
  }
}