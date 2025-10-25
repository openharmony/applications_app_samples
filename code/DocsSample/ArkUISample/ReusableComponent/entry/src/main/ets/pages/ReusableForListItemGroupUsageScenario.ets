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

// [Start reusable_for_list_item_group_usage_scenario]
@Entry
@Component
struct ListItemGroupAndReusable {
  data: DataSrc2 = new DataSrc2();

  @Builder
  itemHead(text: string) {
    Text(text)
      .fontSize(20)
      .backgroundColor(0xAABBCC)
      .width('100%')
      .padding(10)
  }

  aboutToAppear() {
    for (let i = 0; i < 10000; i++) { // 循环10000次
      let data1 = new DataSrc1();
      for (let j = 0; j < 12; j++) { // 循环12次
        data1.data.push(`测试条目数据: ${i} - ${j}`);
      }
      this.data.data.push(data1);
    }
  }

  build() {
    Stack() {
      List() {
        LazyForEach(this.data, (item: DataSrc1, index: number) => {
          ListItemGroup({ header: this.itemHead(index.toString()) }) {
            LazyForEach(item, (ii: string, index: number) => {
              ListItem() {
                Inner({ str: ii });
              }
            })
          }
          .width('100%')
          .height('60vp')
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}

@Reusable
@Component
struct Inner {
  @State str: string = '';

  aboutToReuse(param: ESObject) {
    this.str = param.str;
  }

  build() {
    Text(this.str);
  }
}

class DataSrc1 implements IDataSource {
  public listeners: DataChangeListener[] = [];
  public data: string[] = [];

  public totalCount(): number {
    return this.data.length;
  }

  public getData(index: number): string {
    return this.data[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听。
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听。
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件。
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件。
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件。
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件。
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换。
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    });
  }
}

class DataSrc2 implements IDataSource {
  public listeners: DataChangeListener[] = [];
  public data: DataSrc1[] = [];

  public totalCount(): number {
    return this.data.length;
  }

  public getData(index: number): DataSrc1 {
    return this.data[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听。
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听。
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件。
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件。
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件。
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件。
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换。
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    });
  }
}
// [End reusable_for_list_item_group_usage_scenario]
