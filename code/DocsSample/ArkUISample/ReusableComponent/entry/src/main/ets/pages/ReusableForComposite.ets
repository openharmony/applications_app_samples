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

// [Start reusable_for_composite]
import hilog from '@ohos.hilog';

const TAG = '[Sample_ReusableComponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'ReusableComponent_';

class MyDataSource implements IDataSource {
  private dataArray: string[] = [];
  private listener: DataChangeListener | undefined;

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): string {
    return this.dataArray[index];
  }

  public pushData(data: string): void {
    this.dataArray.push(data);
  }

  public reloadListener(): void {
    this.listener?.onDataReloaded();
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener;
  }

  public unregisterDataChangeListener(listener: DataChangeListener): void {
    this.listener = undefined;
  }
}

@Entry
@Component
struct MyComponent {
  private data: MyDataSource = new MyDataSource();

  aboutToAppear() {
    for (let i = 0; i < 1000; i++) { // 循环1000次
      this.data.pushData(i.toString());
    }
  }

  // itemBuilderOne作为复用组件的写法未展示，以下为转为Builder之后的写法。
  @Builder
  itemBuilderOne(item: string) {
    Column() {
      ChildComponentA({ item: item });
      ChildComponentB({ item: item });
      ChildComponentC({ item: item });
    }
  }

  // itemBuilderTwo转为Builder之后的写法。
  @Builder
  itemBuilderTwo(item: string) {
    Column() {
      ChildComponentA({ item: item });
      ChildComponentC({ item: item });
      ChildComponentD({ item: item });
    }
  }

  // itemBuilderThree转为Builder之后的写法。
  @Builder
  itemBuilderThree(item: string) {
    Column() {
      ChildComponentA({ item: item });
      ChildComponentB({ item: item });
      ChildComponentD({ item: item });
    }
  }

  build() {
    List({ space: 40 }) {
      LazyForEach(this.data, (item: string, index: number) => {
        ListItem() {
          if (index % 3 === 0) { // 当索引是 3 的倍数时（例如 0, 3, 6, 9...），调用 itemBuilderOne
            this.itemBuilderOne(item);
          } else if (index % 5 === 0) { // 当索引是 5 的倍数时（例如 5, 10, 15...），调用 itemBuilderTwo
            this.itemBuilderTwo(item);
          } else {
            this.itemBuilderThree(item);
          }
        }
        .backgroundColor('#cccccc')
        .width('100%')
        .onAppear(() => {
          hilog.info(DOMAIN, TAG, BUNDLE + `ListItem ${index} onAppear`);
        })
      }, (item: number) => item.toString())
    }
    .width('100%')
    .height('100%')
    .cachedCount(0)
  }
}

@Reusable
@Component
struct ChildComponentA {
  @State item: string = '';

  aboutToReuse(params: ESObject) {
    hilog.info(DOMAIN, TAG, BUNDLE + `ChildComponentA ${params.item} Reuse ${this.item}`);
    this.item = params.item;
  }

  aboutToRecycle(): void {
    hilog.info(DOMAIN, TAG, BUNDLE + `ChildComponentA ${this.item} Recycle`);
  }

  build() {
    Column() {
      Text(`Item ${this.item} Child Component A`)
        .fontSize(20)
        .margin({ left: 10 })
        .fontColor(Color.Blue)
      Grid() {
        ForEach((new Array(20)).fill(''), (item: string, index: number) => {
          GridItem() {
            // 请开发者自行在src/main/resources/base/media路径下添加app.media.startIcon图片，否则运行时会因资源缺失而报错。
            Image($r('app.media.startIcon'))
              .height(20)
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .width('90%')
      .height(160)
    }
    .margin({ left: 10, right: 10 })
    .backgroundColor(0xFAEEE0)
  }
}

@Reusable
@Component
struct ChildComponentB {
  @State item: string = '';

  aboutToReuse(params: ESObject) {
    this.item = params.item;
  }

  build() {
    Row() {
      Text(`Item ${this.item} Child Component B`)
        .fontSize(20)
        .margin({ left: 10 })
        .fontColor(Color.Red)
    }.margin({ left: 10, right: 10 })
  }
}

@Reusable
@Component
struct ChildComponentC {
  @State item: string = '';

  aboutToReuse(params: ESObject) {
    this.item = params.item;
  }

  build() {
    Row() {
      Text(`Item ${this.item} Child Component C`)
        .fontSize(20)
        .margin({ left: 10 })
        .fontColor(Color.Green)
    }.margin({ left: 10, right: 10 })
  }
}

@Reusable
@Component
struct ChildComponentD {
  @State item: string = '';

  aboutToReuse(params: ESObject) {
    this.item = params.item;
  }

  build() {
    Row() {
      Text(`Item ${this.item} Child Component D`)
        .fontSize(20)
        .margin({ left: 10 })
        .fontColor(Color.Orange)
    }.margin({ left: 10, right: 10 })
  }
}
// [End reusable_for_composite]