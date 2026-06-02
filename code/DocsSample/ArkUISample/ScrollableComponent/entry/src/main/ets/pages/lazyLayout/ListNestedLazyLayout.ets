/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { LengthMetrics, LazyVWaterFlowLayout, LazyVWaterFlowLayoutAttribute } from '@kit.ArkUI';

class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  protected dataArray: T[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): T {
    return this.dataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}

class MyDataSource<T> extends BasicDataSource<T> {
  public pushData(data: T): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

@Entry
@Component
export struct ListNestedLazyLayout {
  private arr1: MyDataSource<number> = new MyDataSource<number>();
  private arr2: MyDataSource<number> = new MyDataSource<number>();

  private itemHeight(index: number): number {
    return 80 + (index * 37 % 121)
  }

  aboutToAppear(): void {
    for (let i = 0; i < 6; i++) {
      this.arr1.pushData(i);
    }
    for (let i = 0; i < 100; i++) {
      this.arr2.pushData(i);
    }
  }

  build() {
    NavDestination() {
      Column() {
        List({ space: 10 }) {
          ListItem() {
            // 请将$r('app.string.list_nested_lazyLayout_grid')替换为实际资源文件
            // 在本示例中该资源文件的value值为"网格布局"
            Text($r('app.string.list_nested_lazyLayout_grid'))
              .fontSize(14)
              .fontColor(Color.Gray)
          }

          LazyVGridLayout() {
            LazyForEach(this.arr1, (item: number) => {
              Text('item' + item.toString())
                .height(96)
                .width('100%')
                .borderRadius(5)
                .backgroundColor('#ffe0e2e4')
                .textAlign(TextAlign.Center)
            }, (item: number) => item.toString())
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsGap(LengthMetrics.vp(10))
          .columnsGap(LengthMetrics.vp(10))
          .onVisibleIndexesChange((start: number, end: number) => {
            console.info('LazyVGridLayout visible indexes: start: ' + start + ', end: ' + end);
          })

          LazyVGridLayout() {
            LazyForEach(this.arr1, (item: number) => {
              Text('item' + (this.arr1.totalCount() + item).toString())
                .height(96)
                .width('100%')
                .borderRadius(5)
                .backgroundColor('#ffe0e2e4')
                .textAlign(TextAlign.Center)
            }, (item: number) => item.toString())
          }
          .columnsTemplate('1fr 2fr')
          .rowsGap(LengthMetrics.vp(10))
          .columnsGap(LengthMetrics.vp(10))
          .margin({ bottom: 16 })
          .onVisibleIndexesChange((start: number, end: number) => {
            console.info('LazyVGridLayout visible indexes: start: ' + (this.arr1.totalCount() + start) + ', end: ' +
              (this.arr1.totalCount() + end));
          })

          ListItem() {
            // 请将$r('app.string.list_nested_lazyLayout_waterFlow')替换为实际资源文件
            // 在本示例中该资源文件的value值为"瀑布流布局"
            Text($r('app.string.list_nested_lazyLayout_waterFlow'))
              .fontSize(14)
              .fontColor(Color.Gray)
          }

          LazyVWaterFlowLayout() {
            LazyForEach(this.arr2, (item: number) => {
              Text('item' + item.toString())
                .height(this.itemHeight(item))
                .width('100%')
                .borderRadius(5)
                .backgroundColor('#ffe0e2e4')
                .textAlign(TextAlign.Center)
            }, (item: number) => item.toString())
          }
          .columnsTemplate('1fr 1fr')
          .rowsGap(LengthMetrics.vp(10))
          .columnsGap(LengthMetrics.vp(10))
          .onVisibleIndexesChange((start: number, end: number) => {
            console.info('LazyVWaterFlowLayout visible indexes: start: ' + start + ', end: ' + end);
            // 滚动监听：即将触底时提前加载更多数据
            if (end + 20 >= this.arr2.totalCount()) {
              let currentCount = this.arr2.totalCount();
              for (let i = currentCount; i < currentCount + 100; i++) {
                this.arr2.pushData(i);
              }
            }
          })
        }
        .listDirection(Axis.Vertical)
        .backgroundColor(Color.White)
        .borderRadius(12)
        .padding(12)
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.list_nested_lazyLayout_title')替换为实际资源文件
    // 在本示例中该资源文件的value值为"List嵌套懒加载布局容器"
    .title($r('app.string.list_nested_lazyLayout_title'))
  }
}