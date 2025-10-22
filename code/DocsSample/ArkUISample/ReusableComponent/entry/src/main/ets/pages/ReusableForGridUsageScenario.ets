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

// [Start reusable_for_grid_usage_scenario]
// MyDataSource类实现IDataSource接口。
class MyDataSource implements IDataSource {
  private dataArray: number[] = [];

  public pushData(data: number): void {
    this.dataArray.push(data);
  }

  // 数据源的数据总量。
  public totalCount(): number {
    return this.dataArray.length;
  }

  // 返回指定索引位置的数据。
  public getData(index: number): number {
    return this.dataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}

@Entry
@Component
struct MyComponent {
  // 数据源。
  private data: MyDataSource = new MyDataSource();

  aboutToAppear() {
    for (let i = 1; i < 1000; i++) { // 循环1000次
      this.data.pushData(i);
    }
  }

  build() {
    Column({ space: 5 }) {
      Grid() {
        LazyForEach(this.data, (item: number) => {
          GridItem() {
            // 使用可复用自定义组件。
            ReusableChildComponent({ item: item });
          }
        }, (item: string) => item)
      }
      .cachedCount(2) // 设置GridItem的缓存数量。
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .margin(10)
      .height(500)
      .backgroundColor(0xFAEEE0)
    }
  }
}

@Reusable
@Component
struct ReusableChildComponent {
  @State item: number = 0;

  // aboutToReuse从复用缓存中加入到组件树之前调用，可在此处更新组件的状态变量以展示正确的内容。
  // aboutToReuse参数类型已不支持any，这里使用Record指定明确的数据类型。Record用于构造一个对象类型，其属性键为Keys，属性值为Type。
  aboutToReuse(params: Record<string, number>) {
    this.item = params.item;
  }

  build() {
    Column() {
      // 请开发者自行在src/main/resources/base/media路径下添加app.media.app_icon图片，否则运行时会因资源缺失而报错。
      Image($r('app.media.app_icon'))
        .objectFit(ImageFit.Fill)
        .layoutWeight(1)
      Text(`图片${this.item}`)
        .fontSize(16)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height(120)
    .backgroundColor(0xF9CF93)
  }
}
// [End reusable_for_grid_usage_scenario]