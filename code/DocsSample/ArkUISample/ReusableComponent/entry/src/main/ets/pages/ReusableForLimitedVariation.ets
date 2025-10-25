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

// [Start reusable_for_limited_variation]
class LimitedMyDataSource implements IDataSource {
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
struct LimitedIndex {
  private data: LimitedMyDataSource = new LimitedMyDataSource();

  aboutToAppear() {
    for (let i = 0; i < 1000; i++) { // 循环1000次
      this.data.pushData(i + '');
    }
  }

  build() {
    Column() {
      List({ space: 10 }) {
        LazyForEach(this.data, (item: number) => {
          ListItem() {
            ReusableComponent({ item: item })
            // 设置两种有限变化的reuseId
              .reuseId(item % 2 === 0 ? 'ReusableComponentOne' : 'ReusableComponentTwo')
          }
          .backgroundColor(Color.Orange)
          .width('100%')
        }, (item: number) => item.toString())
      }
      .cachedCount(2)
    }
  }
}

@Reusable
@Component
struct ReusableComponent {
  @State item: number = 0;

  aboutToReuse(params: ESObject) {
    this.item = params.item;
  }

  build() {
    Column() {
      // 组件内部根据类型差异渲染
      if (this.item % 2 === 0) {
        Text(`Item ${this.item} ReusableComponentOne`)
          .fontSize(20)
          .margin({ left: 10 })
      } else {
        Text(`Item ${this.item} ReusableComponentTwo`)
          .fontSize(20)
          .margin({ left: 10 })
      }
    }.margin({ left: 10, right: 10 })
  }
}
// [End reusable_for_limited_variation]
